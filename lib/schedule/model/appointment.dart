import 'dart:convert';
import 'dart:io';

import 'package:tumobile/schedule/model/place.dart';

class Appointment {
  DateTime _begin;
  DateTime _end;
  String _name;
  Place _place;
  String _description;
  String _info;

  Appointment.empty()
      : _begin = DateTime.fromMicrosecondsSinceEpoch(0),
        _end = DateTime.fromMicrosecondsSinceEpoch(0),
        _name = "",
        _place = Place.empty(),
        _description = "",
        _info = "";

  Appointment(this._begin, this._end, this._name, this._place, this._info,
      [this._description = ""]);

  factory Appointment.fromJSON(String input) {
    final data = jsonDecode(input) as Map<String, dynamic>;
    DateTime beginning = DateTime.parse(data["beginning"]);
    DateTime ending = DateTime.parse(data["ending"]);

    return Appointment(beginning, ending, data["name"],
        Place.fromJSON(data["place"]), data["info"], data["description"]);
  }
  factory Appointment.fromJSONFile(File file) =>
      Appointment.fromJSON(file.readAsStringSync());

  DateTime get timeOfBegin => _begin;
  DateTime get timeOfEnd => _end;
  DateTime get duration => DateTime.fromMicrosecondsSinceEpoch(
      _begin.microsecondsSinceEpoch - _end.microsecondsSinceEpoch);
  String get name => _name;
  Place get place => _place;
  String get description => _description;
  String get info => _info;

  String toJSON() {
    return '{\n'
        '\t"beginning": "${_begin.toIso8601String()}",\n'
        '\t"ending": "${_end.toIso8601String()}",\n'
        '\t"name": "$_name",\n'
        '\t"place": ${_place.toJSON()},\n'
        '\t"info": "$_info",\n'
        '\t"description": "$_description"\n'
        '}';
  }
}
