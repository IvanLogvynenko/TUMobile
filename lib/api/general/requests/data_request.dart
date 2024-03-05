// import 'dart:convert';
// import 'dart:io';

// import 'package:tumobile/api/general/requests/session.dart';
// import 'package:tumobile/api/general/schedule/day.dart';
// import 'package:tumobile/api/general/time/date.dart';
// import 'package:tumobile/api/general/time/time_range.dart';

// class DataRequest {
//   final _ctx = "${String.fromCharCode(36)}ctx";

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
