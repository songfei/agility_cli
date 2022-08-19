import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';

class PubGetCommand extends Command {
  @override
  final name = "get";

  @override
  final description = "pub get all BLoCs";

  @override
  FutureOr run() async {
    await pubGet(Directory.current);
  }

  Future<void> pubGet(Directory currentDirectory) async {
    if (await currentDirectory.exists()) {
      String pubFilePath = path.join(currentDirectory.path, 'pubspec.yaml');
      File pubFile = File(pubFilePath);
      if (await pubFile.exists()) {
        var shell = Shell(throwOnError: false, workingDirectory: currentDirectory.path);
        await shell.run('flutter pub get');
      } else {
        List fileList = currentDirectory.listSync();
        for (final element in fileList) {
          if (element is Directory) {
            await pubGet(element);
          }
        }
      }
    }
  }
}
