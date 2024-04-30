import 'dart:convert';

class Place {
  final String _name;
  final String _link;

  Place([name = "", link = ""])
      : _name = name,
        _link = link;

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
