import 'dart:async';

import 'package:args/command_runner.dart';

class PubGetCommand extends Command {
  @override
  final name = "get";

  @override
  final description = "pub get all BLoCs";

  @override
  FutureOr run() async {}
}
