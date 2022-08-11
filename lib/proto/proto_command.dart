import 'dart:async';

import 'package:args/command_runner.dart';

import 'proto_build_command.dart';

class ProtoCommand extends Command {
  ProtoCommand() {
    addSubcommand(ProtoBuildCommand());
  }
  @override
  final name = "proto";

  @override
  final description = "proto tools";

  @override
  FutureOr run() async {}
}
