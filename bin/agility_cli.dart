import 'package:agility_cli/bloc/bloc_command.dart';
import 'package:agility_cli/proto/proto_command.dart';
import 'package:agility_cli/pub/pub_command.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) async {
  CommandRunner(
    "agility",
    "An Agility Flutter App Framework.",
  )
    ..addCommand(PubCommand())
    ..addCommand(BlocCommand())
    ..addCommand(ProtoCommand())
    ..run(arguments);
}
