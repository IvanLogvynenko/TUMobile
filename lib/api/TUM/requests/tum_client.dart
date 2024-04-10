import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:tumobile/api/TUM/schedule/tum_schedule.dart';
import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
import 'package:tumobile/api/general/requests/language.dart';
import 'package:tumobile/api/general/requests/session.dart';
import 'package:tumobile/api/general/schedule/ischedule.dart';

class TUMClient implements IClient {
  final _ctx = "${String.fromCharCode(36)}ctx";
  final _host = "https://campus.tum.de/tumonline";

  static bool _showAsList = true;

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
    print(clientRequest.cookies);
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    _session!.cookies = clientResponse.cookies;
    logger.log("logged in");
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<ISchedule> getCalendar<T>(DateTime dateTime) async {
    HttpClientRequest clientRequest = await _httpClient!.getUrl(Uri.parse(
        "$_host/pl/ui/$_ctx;design=ca2;header=max;lang=de/wbKalender.cbPersonalKalender?"
        "pDisplayMode=t&"
        "pDatum=${dateTime.day}.${dateTime.month}.${dateTime.year}&"
        "pOrgNr=&pShowAsList=${_showAsList ? 'T' : 'F'}&"
        "pZoom=100&pNurStandardGrp="));
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    final document =
        HtmlParser(await clientResponse.transform(utf8.decoder).join()).parse();

    ISchedule result = TUMSchedule();
    print("xxx");
    document.querySelectorAll("div.cocal-events-gutter").forEach((e) {
      print("new: ${e.innerHtml}");
      print("some");
    });
    print("fgf");

    return result;
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
}
