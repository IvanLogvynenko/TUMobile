class PauseData {
  DateTime begin, end;
  PauseData.empty()
      : begin = DateTime.fromMicrosecondsSinceEpoch(0),
        end = DateTime.fromMicrosecondsSinceEpoch(0);
  PauseData(this.begin, this.end);
}
