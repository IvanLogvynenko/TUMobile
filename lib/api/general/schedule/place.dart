class Place {
  final String? _name;
  final String _link;
  Place()
      : _name = "",
        _link = "";
  Place.full(this._name, this._link);
  getName() => _name;
  getlink() => _link;
}
