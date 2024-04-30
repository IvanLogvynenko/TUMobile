class Event {
  final DateTime begin, end;
  final String name;

  Event.empty()
      : name = "",
        begin = DateTime.fromMicrosecondsSinceEpoch(0),
        end = DateTime.fromMicrosecondsSinceEpoch(0);
  Event(this.begin, this.end, this.name);
}
