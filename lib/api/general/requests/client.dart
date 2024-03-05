import 'package:tumobile/api/general/requests/session.dart';

abstract class Client {
  final Session? _session;

  Client.empty() : _session = Session.empty();

  Session get session => _session!;
}
