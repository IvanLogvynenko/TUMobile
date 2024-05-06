// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:xml/xml.dart';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'package:tumobile/requests/model/language.dart';
import 'package:tumobile/requests/model/login_status.dart';
import 'package:tumobile/requests/model/session.dart';

import 'package:tumobile/schedule/view_model/schedule_data.dart';
import 'package:tumobile/schedule/model/appointment_data.dart';
import 'package:tumobile/schedule/model/place.dart';

class Client {
  final _ctx = "${String.fromCharCode(36)}ctx";
  final _host = "https://campus.tum.de/tumonline";

  static const bool _showAsList = false;

  static const Set<Language> supportedLanguages = {
    Language.german,
    Language.english
  };

  Session? _session;
  HttpClient? _httpClient;

  Client.empty()
      : _session = null,
        _httpClient = null;
  Client()
      : _session = Session.empty(),
        _httpClient = null;
  Client.fromSession(Session session)
      : _session = session,
        _httpClient = HttpClient();
  Client.byCredentials(String username, String password)
      : _session = Session.byCreds(username, password),
        _httpClient = HttpClient();

  Future<void> init() async {
    if (_httpClient != null) return;
    _httpClient = HttpClient();
    print("TUMClient init done");
    HttpClientRequest clientRequest = await _httpClient!
        .getUrl(Uri.parse("$_host/pl/ui/$_ctx/wbOAuth2.session?language=de"));
    print("requested");
    print(clientRequest.toString());
    HttpClientResponse clientResponse = await clientRequest.close();
    // print("Client response");
    print(clientResponse.statusCode.toString());
    // print(clientResponse.cookies.length.toString());
    for (var item in clientResponse.cookies) {
      // print("parsing cookies");
      if (item.name == "PSESSIONID") {
        _session!.cookies = clientResponse.cookies;
        // print("setting cookies");
        break;
      }
    }
  }

  Future<String> _getNewStateWrapper() async {
    HttpClientRequest clientRequest =
        await _httpClient!.postUrl(Uri.parse("$_host/ee/rest/auth/user"));
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    String responceData = await clientResponse.transform(utf8.decoder).join();
    List<String> splitted = responceData.split("authEndpointUrl>");
    for (var item in splitted[1].split("&amp;")) {
      if (item.startsWith("pStateWrapper")) return item.substring(14);
    }
    return "";
  }

  Future<void> login() async {
    HttpClientRequest clientRequest = await _httpClient!
        .postUrl(Uri.parse("$_host/pl/ui/$_ctx/wbOAuth2.approve?"
            "pConfirm=X"
            "&pPassword=${_session!.password}"
            "&pSkipOauth2=F"
            "&pStateWrapper=${await _getNewStateWrapper()}"
            "&pUsername=${_session!.username}"));
    clientRequest.cookies.addAll(_session!.cookies);
    clientRequest.headers.forEach((name, values) => print("$name:$values"));
    HttpClientResponse clientResponse = await clientRequest.close();
    _session!.cookies = clientResponse.cookies;
    if (clientResponse.statusCode == HttpStatus.found) {
      String redirectUrl = clientResponse.headers["location"]![0];
      clientResponse.drain();

      var nextRequest = await _httpClient!.getUrl(Uri.parse(redirectUrl));

      var nextResponse = await nextRequest.close();

      _session!.authorisationToken = (jsonDecode(
              await nextResponse.transform(const Latin1Decoder()).join())
          as Map<String, dynamic>)["access_token"];
    }
    print("logged in");
    _session!.loginStatus = LoginStatus.loggedIn;
  }

  Future<void> logout() async {
    if (_session!.loginStatus != LoginStatus.loggedIn) {
      throw Exception("User should be logged in");
    }
    HttpClientRequest clientRequest = await _httpClient!
        .getUrl(Uri.parse("$_host/ee/rest/auth/generic/doLogout"));
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    print(await clientResponse.transform(utf8.decoder).join());
  }

  DateTime _parseTime(String time, {DateTime? dateTime}) {
    dateTime ??= DateTime.now();

    String hour = time.split(":")[0];
    String minute = time.split(":")[1];

    DateTime result =
        dateTime.copyWith(hour: int.parse(hour), minute: int.parse(minute));
    return result;
  }

  Future<ScheduleData> getSchedule<T>(DateTime dateTime) async {
    if (_session!.loginStatus != LoginStatus.loggedIn) {
      throw Exception("User should be logged in");
    }
    // getting data from server
    HttpClientRequest clientRequest = await _httpClient!.getUrl(Uri.parse(
        "$_host/pl/ui/$_ctx;design=ca2;header=max;lang=de/wbKalender.cbPersonalKalender?"
        "pDisplayMode=t&"
        "pDatum=${dateTime.day}.${dateTime.month}.${dateTime.year}&"
        "pOrgNr=&pShowAsList=${_showAsList ? 'T' : 'F'}&"
        "pZoom=100&pNurStandardGrp="));
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();

    //parsing data
    final document =
        HtmlParser(await clientResponse.transform(utf8.decoder).join()).parse();

    List<AppointmentData> result = List.empty(growable: true);
    document.querySelectorAll("div.cocal-events-gutter").forEach(
        (e) => e.querySelectorAll("div.cocal-ev-content").forEach((element) {
              String time = element
                  .querySelector("div.cocal-ev-header>span.cocal-ev-time")!
                  .text;
              String beginning = time.split("-")[0];
              String end = time.split("-")[1];

              String title = element
                  .querySelector("div.cocal-ev-header>span.cocal-ev-title")!
                  .text;

              Element? divPlace = element.querySelector(
                  "div.cocal-ev-header>span.cocal-ev-location>a");
              Place place = Place();
              if (divPlace != null) {
                place = Place(divPlace.text, divPlace.attributes["href"] ?? "");
              }

              String info = element
                  .querySelector("div.cocal-ev-body>span.cocal-ev-desc")!
                  .text;

              result.add(AppointmentData(
                  _parseTime(beginning, dateTime: dateTime),
                  _parseTime(end, dateTime: dateTime),
                  title,
                  place,
                  info));
            }));

    return ScheduleData(result, dateTime);
  }

  Future<String> getUsername() async {
    HttpClientRequest clientRequest = await _httpClient!.getUrl(
        Uri.parse("$_host/ee/rest/brm.lib.dtop.home/v1/desktop/profile"));
    clientRequest.cookies.addAll(_session!.cookies);
    clientRequest.headers.contentType = ContentType.json;
    clientRequest.headers
        .add("Authorization", "Bearer ${_session!.authorisationToken}");
    clientRequest.headers.forEach((name, values) => print("$name:$values"));
    HttpClientResponse clientResponse = await clientRequest.close();
    _session!.cookies = clientResponse.cookies;
    print(clientResponse.statusCode);
    String responceData = await clientResponse.transform(utf8.decoder).join();
    // return responceData;
    XmlDocument document = XmlDocument.parse(responceData);
    return document.rootElement
        .findElements("resource")
        .first
        .findElements("content")
        .first
        .findElements("xsi:desktopProfileLibDto")
        .first
        .findAllElements("nickname")
        .first
        .innerText;
  }

  void dispose() {
    _session!.close();
    _httpClient!.close();
    _session = null;
    _httpClient = null;
  }

  void setCredentials(String username, String password) {
    _session!.username = username;
    _session!.password = password;
  }

  Session get session => _session!;

  Cookie getCookie(String cookieName) =>
      _session!.cookies.firstWhere((cookie) => cookie.name == cookieName);

  bool get isLoggedIn => _session!.loginStatus == LoginStatus.loggedIn;
  bool get credentialsProvided => _session!.credentialsProvided;
}
