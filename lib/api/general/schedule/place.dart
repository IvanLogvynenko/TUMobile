class Place {
  final String? _name;
  final String? _link;

  Place.empty()
      : _name = "",
        _link = "";

  Place(this._name, this._link);

  String get name => _name!;
  String get link => _link!;
}
