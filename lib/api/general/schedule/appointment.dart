
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
      : _begin = Time(),
        _end = Time(),
        _name = "",
        _place = Place(),
        _description = "",
        _info = "";
  Appointment(this._begin, this._end, this._name, this._place, this._info,
      [this._description = ""]);
  Time getTimeOfBegin() => _begin!;
  Time getDuration() => Time.byMinutes(_begin!.getDifferenceInMinutes(_end!));
  String getName() => _name!;
  Place getPlace() => _place!;
  String getDescription() => _description!;
  String getInfo() => _info!;
}
