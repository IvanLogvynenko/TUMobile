import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
import 'package:tumobile/api/general/requests/language.dart';
import 'package:tumobile/api/general/requests/session.dart';
import 'package:tumobile/api/general/schedule/schedule.dart';
import 'package:tumobile/api/general/schedule/time_range.dart';

class TUMClient implements IClient {
  final _ctx = "${String.fromCharCode(36)}ctx";
  final _host = "https://campus.tum.de/tumonline";

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
  Future<Schedule> getCalendar<T>(DateTime dateTime,
      [TimeRange timeRange = TimeRange.day, bool showAsList = false]) async {
    // Logger logger = Logger("TUMClient.getCalendar");
    HttpClientRequest clientRequest = await _httpClient!.getUrl(Uri.parse(
        "https://campus.tum.de/tumonline/pl/ui/$_ctx;design=ca2;header=max;lang=de/wbKalender.cbPersonalKalender?"
        "pDisplayMode=${timeRange.value}&"
        "pDatum=${dateTime.day}.${dateTime.month}.${dateTime.year}&"
        "pOrgNr=&pShowAsList=${showAsList ? 'T' : 'F'}&"
        "pZoom=100&pNurStandardGrp="));
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    final document =
        HtmlParser(await clientResponse.transform(utf8.decoder).join()).parse();

    String result = document
        .querySelectorAll("div.cocal-events-gutter")
        .map((e) => e.innerHtml)
        .join();

    return Schedule(result);
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

//   Future<Day> getCalendar(Date date,
//       [TimeRange timeRange = TimeRange.day, bool showAsList = false]) async {
//     HttpClient client = HttpClient();
//     Uri url = Uri.parse(
//         "https://campus.tum.de/tumonline/pl/ui/$_ctx;design=ca2;header=max;lang=de/wbKalender.cbPersonalKalender?"
//         "pDisplayMode=${timeRange.getValue()}&"
//         "pDatum=${date.toString()}&"
//         "pOrgNr=&pShowAsList=${showAsList ? 'T' : 'F'}&"
//         "pZoom=100&pNurStandardGrp=");
//     HttpClientRequest clientRequest = await client.getUrl(url);
//     clientRequest.cookies.addAll(_session?.getCookies());
//     HttpClientResponse clientResponse = await clientRequest.close();
//     HTMLParser htmlParser = HTMLParser();
//     return htmlParser.parseDayScheduleFromHtml(
//         await clientResponse.transform(utf8.decoder).join(), date);
//   }
// }



