import 'package:agility_cli/pub/pub_get_command.dart';
import 'package:args/command_runner.dart';

class PubCommand extends Command {
  PubCommand() {
    addSubcommand(PubGetCommand());
  }

  @override
  final name = "pub";

  @override
  final description = "pub tools";
}
