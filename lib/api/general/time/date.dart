class Date {
  int? _day, _month, _year;

  factory Date.today() {
    DateTime dt = DateTime.now();
    return Date(dt.day, dt.month, dt.year);
  }
  Date(this._day, this._month, this._year);
  @override
  String toString([String separator = "."]) {
    return "$_day$separator$_month$separator$_year";
  }

  int get day => _day!;
  int get month => _month!;
  int get year => _year!;
}
