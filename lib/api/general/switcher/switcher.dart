import 'package:tumobile/api/TUM/custom_widgets/tum_color_theme.dart';
import 'package:tumobile/api/TUM/requests/tum_client.dart';
import 'package:tumobile/api/general/custom_widgets/icolor_theme.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
import 'package:tumobile/api/general/switcher/availible_universities.dart';

/// The purpose of this class is to pass right implementations to the main.dart
class Switcher {
  final University _university;
  late IClient _client;
  late ColorTheme _colorTheme;

  Switcher(this._university) {
    switch (_university) {
      case University.technicalUniversityMunich:
        _client = TUMClient();
        _colorTheme = TUMColorTheme();
        break;
      default:
        throw Exception(
            "No data would be provided, since it is unknown University");
    }
  }

  IClient get client => _client;
  ColorTheme get colorTheme => _colorTheme;
}
