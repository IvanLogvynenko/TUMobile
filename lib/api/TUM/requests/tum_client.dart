import 'dart:io';

import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/requests/client.dart';
import 'package:tumobile/api/general/requests/language.dart';
import 'package:tumobile/api/general/requests/session.dart';
import 'package:tumobile/api/general/schedule/schedule.dart';

class TUMClient implements Client {
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
    Logger logger = Logger();
    _httpClient = HttpClient();
    print("TUMClient init done");
    HttpClientRequest clientRequest = await _httpClient!
        .getUrl(Uri.parse("$_host/pl/ui/$_ctx/wbOAuth2.session?language=de"));
    print("requested");
    print(clientRequest);
    HttpClientResponse clientResponse = await clientRequest.close();
    print("Client response");
    print(clientResponse.statusCode);
    print(clientResponse.cookies.length);
    for (var item in clientResponse.cookies) {
      print("parsing cookies");
      if (item.name == "PSESSIONID") {
        _session!.cookies = clientResponse.cookies;
        print("setting cookies");
        break;
      }
    }
  }

  @override
  Future<void> login() {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<Schedule<T>> getCalendar<T>() {
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    _session!.close();
    _httpClient!.close();
    _session = null;
    _httpClient = null;
    return Future.value(null);
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

// class Request {
//   static const String host = "https://campus.tum.de";
//   final _ctx = "${String.fromCharCode(36)}ctx";

//   static Request? _instance;

//   Session? _session;

//   factory Request() {
//     _instance ??= Request._createInstance();
//     return _instance!;
//   }
//   Request._createInstance() : _session = Session();

//   Session getSession() {
//     return _session!;
//   }

//   Future<Session> startNewSession() async {
//     HttpClient client = HttpClient();
//     HttpClientRequest clientRequest = await client.getUrl(
//         Uri.parse("$host/tumonline/pl/ui/$_ctx/wbOAuth2.session?language=de"));
//     HttpClientResponse clientResponse = await clientRequest.close();
//     for (var item in clientResponse.cookies) {
//       if (item.name == "PSESSIONID") {
//         _instance!._session = Session.byID(item.value);
//         return _instance!._session!;
//       }
//     }
//     throw FailedToGetSessionID();
//   }

//   Future<Session> loginInSystem(String login, String password) async {
//     XmlParser parser = XmlParser();
//     HttpClient client = HttpClient();
//     HttpClientRequest clientRequest = await client.postUrl(Uri.parse(
//         "$host/tumonline/pl/ui/$_ctx/wbOAuth2.approve?"
//         "pConfirm=X"
//         "&pPassword=$password"
//         "&pSkipOauth2=F"
//         "&pStateWrapper=${parser.parseStateWrapper(await _getNewStateWrapper())}"
//         "&pUsername=$login"));
//     clientRequest.cookies.addAll(_session!.getCookies());
//     HttpClientResponse clientResponse = await clientRequest.close();
//     _session!.setCookies(clientResponse.cookies);
//     return _session!;
//   }

//   Future<String> _getNewStateWrapper() async {
//     HttpClient client = HttpClient();
//     Uri url = Uri.parse("$host/tumonline/ee/rest/auth/user");
//     HttpClientRequest clientRequest = await client.postUrl(url);
//     clientRequest.cookies.addAll(_session!.getCookies());
//     HttpClientResponse clientResponse = await clientRequest.close();
//     return clientResponse.transform(utf8.decoder).join();
//   }
// }
