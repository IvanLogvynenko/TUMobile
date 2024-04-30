import 'dart:convert';

class Place {
  final String _name;
  final String _link;

  Place.empty()
      : _name = "",
        _link = "";

  Place(this._name, this._link);

  factory Place.fromJSON(String input) {
    final data = jsonDecode(input) as Map<String, dynamic>;
    return Place(data["name"], data["link"]);
  }

  String toJSON() {
    return '\n{\n'
        '\t"name": "$_name",\n'
        '\t"link": "$_link"\n'
        '}';
  }

  String get name => _name;
  String get link => _link;
}
