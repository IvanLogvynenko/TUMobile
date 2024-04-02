import 'dart:convert';
import 'dart:io';

import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
import 'package:tumobile/api/general/requests/language.dart';
import 'package:tumobile/api/general/requests/session.dart';
import 'package:tumobile/api/general/schedule/schedule.dart';

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

  Future<String> getNewStateWrapper() async {
    HttpClientRequest clientRequest =
        await _httpClient!.postUrl(Uri.parse("$_host/ee/rest/auth/user"));
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    return clientResponse.transform(utf8.decoder).join();
  }

  @override
  void login() async {
    HttpClientRequest clientRequest = await _httpClient!
        .postUrl(Uri.parse("$_host/pl/ui/$_ctx/wbOAuth2.approve?"
            "pConfirm=X"
            "&pPassword=${_session!.password}"
            "&pSkipOauth2=F"
            // "&pStateWrapper=${await _getNewStateWrapper()}"
            "&pUsername=${_session!.username}"));
    clientRequest.cookies.addAll(_session!.cookies);
    HttpClientResponse clientResponse = await clientRequest.close();
    _session!.cookies = clientResponse.cookies;
  }

  @override
  void logout() {
    throw UnimplementedError();
  }

  @override
  Schedule<T> getCalendar<T>() {
    throw UnimplementedError();
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

// import 'dart:convert';
// import 'dart:io';

// import 'package:tumobile/api/general/requests/session.dart';
// import 'package:tumobile/api/general/schedule/day.dart';
// import 'package:tumobile/api/general/time/date.dart';
// import 'package:tumobile/api/general/time/time_range.dart';

// class DataRequest {

//   Session? _session;

//   DataRequest();
//   DataRequest.bySession(this._session);

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

// import 'dart:convert';
// import 'dart:io';

// import 'package:tumobile/api/general/data_parsing/xml_parser.dart';
// import 'package:tumobile/api/general/requests/exceptions/failed_to_get_session_id.dart';
// import 'package:tumobile/api/general/requests/session.dart';



