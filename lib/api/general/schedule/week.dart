import 'package:tumobile/api/general/schedule/day.dart';
import 'package:tumobile/api/general/schedule/time_range.dart';

class Week {
  final List<Day> days;
  static const TimeRange timeRange = TimeRange.week;

  Week(this.days);
}
