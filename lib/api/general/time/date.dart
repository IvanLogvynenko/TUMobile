class Date {
  int? _day, _month, _year;
  factory Date.today() {
    DateTime dt = DateTime.now();
    return Date.full(dt.day, dt.month, dt.year);
  }
  Date.full(this._day, this._month, [this._year = 2023]);
  @override
  String toString() {
    return "$_day.$_month.$_year";
  }
  getDay() => _day;
  getMonth() => _month;
  getYear() => _year;
}
