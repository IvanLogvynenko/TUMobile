
import 'package:tumobile/api/general/schedule/place.dart';
import 'package:tumobile/api/general/time/time.dart';

class Appointment {
  final Time? _begin;
  final Time? _end;
  final String? _name;
  final Place? _place;
  final String? _description;
  final String? _info;

  Appointment.empty()
      : _begin = Time.empty(),
        _end = Time.empty(),
        _name = "",
        _place = Place.empty(),
        _description = "",
        _info = "";

  Appointment(this._begin, this._end, this._name, this._place, this._info,
      [this._description = ""]);

  Time get timeOfBegin => _begin!;
  Time get timeOfEnd => _end!;
  Time get duration => _begin! - _end!;
  String get name => _name!;
  Place get place => _place!;
  String get description => _description!;
  String get info => _info!;
}
