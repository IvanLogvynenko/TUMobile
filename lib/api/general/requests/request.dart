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
