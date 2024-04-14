import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:tumobile/api/TUM/schedule/tum_schedule.dart';
import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
import 'package:tumobile/api/general/requests/language.dart';
import 'package:tumobile/api/general/requests/login_status.dart';
import 'package:tumobile/api/general/requests/session.dart';
import 'package:tumobile/api/general/schedule/appointment.dart';
import 'package:tumobile/api/general/schedule/ischedule.dart';
import 'package:tumobile/api/general/schedule/place.dart';

class TUMClient implements IClient {
  final _ctx = "${String.fromCharCode(36)}ctx";
  final _host = "https://campus.tum.de/tumonline";

  static const bool _showAsList = false;

  static const Set<Language> supportedLanguages = {
    Language.german,
    Language.english
  };

  Session? _session;
  HttpClient? _httpClient;

  TUMClient.empty()
      : _session = null,
        _httpClient = null;
  TUMClient()
      : _session = Session.empty(),
        _httpClient = null;
  TUMClient.fromSession(Session session)
      : _session = session,
        _httpClient = HttpClient();
  TUMClient.byCredentials(String username, String password)
      : _session = Session.byCreds(username, password),
        _httpClient = HttpClient();

  @override
  Future<void> init() async {
    Logger logger = Logger("TUMClient.init");
    _httpClient = HttpClient();
    logger.log("TUMClient init done");
    HttpClientRequest clientRequest = await _httpClient!
        .getUrl(Uri.parse("$_host/pl/ui/$_ctx/wbOAuth2.session?language=de"));
    logger.log("requested");
    logger.log(clientRequest.toString());
    HttpClientResponse clientResponse = await clientRequest.close();
    logger.log("Client response");
    logger.log(clientResponse.statusCode.toString());
    logger.log(clientResponse.cookies.length.toString());
    for (var item in clientResponse.cookies) {
      logger.log("parsing cookies");
      if (item.name == "PSESSIONID") {
        _session!.cookies = clientResponse.cookies;
        logger.log("setting cookies");
        break;
      }
    }
  }

  @override
  void setCredentials(String username, String password) {
    _session!.username = username;
    _session!.password = password;
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

  @override
  Future<void> login() async {
    Logger logger = Logger("TUMCLient.login");
    HttpClientRequest clientRequest = await _httpClient!
        .postUrl(Uri.parse("$_host/pl/ui/$_ctx/wbOAuth2.approve?"
            "pConfirm=X"
            "&pPassword=${_session!.password}"
            "&pSkipOauth2=F"
            "&pStateWrapper=${await _getNewStateWrapper()}"
            "&pUsername=${_session!.username}"));
    clientRequest.followRedirects = true;
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    _session!.cookies = clientResponse.cookies;
    logger.log("logged in");
    _session!.loginStatus = LoginStatus.loggedIn;
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  DateTime _parseTime(String time, {DateTime? dateTime}) {
    dateTime ??= DateTime.now();

    String hour = time.split(":")[0];
    String minute = time.split(":")[1];

    DateTime result =
        dateTime.copyWith(hour: int.parse(hour), minute: int.parse(minute));
    return result;
  }

  @override
  Future<ISchedule> getCalendar<T>(DateTime dateTime) async {
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

    List<Appointment> result = List.empty(growable: true);
    document.querySelectorAll("div.cocal-events-gutter").forEach((e) =>
        e.querySelectorAll("div.cocal-ev-content").forEach((element) {
          String time = element
              .querySelector("div.cocal-ev-header>span.cocal-ev-time")!
              .text;
          String beginning = time.split("-")[0];
          String end = time.split("-")[1];

          String title = element
              .querySelector("div.cocal-ev-header>span.cocal-ev-title")!
              .text;

          String place = element
              .querySelector("div.cocal-ev-header>span.cocal-ev-location>a")!
              .text;

          String link = element
              .querySelector("div.cocal-ev-header>span.cocal-ev-location>a")!
              .attributes['href']!;
          String info = element
              .querySelector("div.cocal-ev-body>span.cocal-ev-desc")!
              .text;

          result.add(Appointment(
              _parseTime(beginning, dateTime: dateTime),
              _parseTime(end, dateTime: dateTime),
              title,
              Place(place, link),
              info));
        }));

    return TUMSchedule(result, dateTime);
  }

  @override
  void dispose() {
    _session!.close();
    _httpClient!.close();
    _session = null;
    _httpClient = null;
  }

  Session get session => _session!;

  Cookie getCookie(String cookieName) =>
      _session!.cookies.firstWhere((cookie) => cookie.name == cookieName);

  @override
  bool get isLoggedIn => _session!.loginStatus == LoginStatus.loggedIn;
  @override
  bool get credentialsProvided => _session!.credentialsProvided;
}
