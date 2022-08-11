import 'dart:async';

import 'package:agility_cli/bloc/bloc_create_command.dart';
import 'package:args/command_runner.dart';

class BlocUpdateTemplateCommand extends Command {
  @override
  final name = "update_template";

  @override
  final description = "Update BLoC Template.";

  @override
  FutureOr run() async {
    await updateTemplateFromGithub();
  }
}
