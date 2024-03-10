import 'package:tumobile/api/general/schedule/place.dart';

class Appointment {
  final DateTime? _begin;
  final DateTime? _end;
  final String? _name;
  final Place? _place;
  final String? _description;
  final String? _info;

  Appointment.empty()
      : _begin = null,
        _end = null,
        _name = "",
        _place = Place.empty(),
        _description = "",
        _info = "";

  Appointment(this._begin, this._end, this._name, this._place, this._info,
      [this._description = ""]);

  DateTime get timeOfBegin => _begin!;
  DateTime get timeOfEnd => _end!;
  DateTime get duration => DateTime.fromMicrosecondsSinceEpoch(
      _begin!.microsecondsSinceEpoch - _end!.microsecondsSinceEpoch);
  String get name => _name!;
  Place get place => _place!;
  String get description => _description!;
  String get info => _info!;
}
