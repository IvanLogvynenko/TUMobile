import 'dart:convert';
import 'dart:io';

import 'package:tumobile/schedule/model/place.dart';

class AppointmentData {
  DateTime begin, end;
  String name;
  Place place;
  List<Place> additionalPlaces = [];
  String description;
  String info;

  AppointmentData.empty()
      : begin = DateTime.fromMicrosecondsSinceEpoch(0),
        end = DateTime.fromMicrosecondsSinceEpoch(0),
        name = "",
        place = Place(),
        additionalPlaces = [],
        description = "",
        info = "";

  AppointmentData(this.begin, this.end, this.name, this.place, this.info,
      [this.description = "", additionalPlaces]);

  factory AppointmentData.fromJSON(String input) {
    final data = jsonDecode(input) as Map<String, dynamic>;
    DateTime beginning = DateTime.parse(data["beginning"]);
    DateTime ending = DateTime.parse(data["ending"]);

    return AppointmentData(beginning, ending, data["name"],
        Place.fromJSON(data["place"]), data["info"], data["description"]);
  }
  factory AppointmentData.fromJSONFile(File file) =>
      AppointmentData.fromJSON(file.readAsStringSync());

  String toJSON() {
    return '{\n'
        '\t"beginning": "${begin.toIso8601String()}",\n'
        '\t"ending": "${end.toIso8601String()}",\n'
        '\t"name": "$name",\n'
        '\t"place": ${place.toJSON()},\n'
        '\t"info": "$info",\n'
        '\t"description": "$description"\n'
        '}';
  }
}
