import 'package:args/command_runner.dart';

import 'bloc_create_command.dart';
import 'bloc_update_template_command.dart';

class BlocCommand extends Command {
  BlocCommand() {
    addSubcommand(BlocCreateCommand());
    addSubcommand(BlocUpdateTemplateCommand());
  }
  @override
  final name = "bloc";

  @override
  final description = "bloc tools";
}
