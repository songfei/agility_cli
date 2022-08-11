import 'dart:async';

import 'package:args/command_runner.dart';

class ProtoBuildCommand extends Command {
  @override
  final name = "build";

  @override
  final description = "build all BLoCs proto file";

  @override
  FutureOr run() async {}
}
