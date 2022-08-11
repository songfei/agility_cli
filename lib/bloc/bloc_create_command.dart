import 'dart:async';
import 'dart:io';

import 'package:agility_cli/utils.dart';
import 'package:args/command_runner.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';
import 'package:recase/recase.dart';

class BlocCreateCommand extends Command {
  BlocCreateCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      // mandatory: true,
      help: 'BLoC Name, use `snake_case`.',
    );

    argParser.addOption(
      'type',
      abbr: 't',
      defaultsTo: 'business',
      allowedHelp: {
        'business': 'For Business BLoC.',
        'shared': 'for Shared BLoC.',
      },
    );

    argParser.addFlag(
      'use-proto',
      abbr: 'p',
      defaultsTo: true,
      help: 'Use *.proto to describe data model',
    );

    argParser.addOption(
      'template',
      defaultsTo: 'default',
      help: 'Use BLoC template',
    );
  }
  @override
  final name = "create";

  @override
  final description = "Create and Modify BLoC";

  @override
  FutureOr run() async {
    // print(argResults!['name']);
    // print(argResults!['use-proto']);
    // print(argResults!['type']);

    String? name = argResults!['name'];

    if (name == null || name.isEmpty) {
      print('BLoC name is empty.');
      return;
    }

    ReCase reCaseName = ReCase(name);

    String type = argResults!['type'];

    String outputPath = name;
    if (type == 'business') {
      outputPath = path.join('bloc', name);
    } else {
      outputPath = path.join('shared_bloc', name);
    }

    // await updateTemplateFromGithub();

    var templateBasePath = await getAgilityTemplatePath();

    // var list = await listTemplateFile(templateBasePath);
    await renderTemplate(templateBasePath: templateBasePath, outputPath: outputPath, data: {
      'bloc_name': name,
      'bloc_name_pascal_case': reCaseName.pascalCase,
    });
  }
}

Future<void> checkDirector(String filePath) async {
  Directory file = Directory(filePath);
  try {
    bool exists = await file.exists();
    if (!exists) {
      await file.create();
    }
  } catch (e) {
    print(e);
  }
}

Future<String> getAgilityBasePath() async {
  String homeDir = homeDirectory()!;
  String agilityBasePath = path.join(homeDir, '.agility');

  checkDirector(agilityBasePath);

  return agilityBasePath;
}

Future<String> getAgilityTemplatePath() async {
  String basePath = await getAgilityBasePath();
  String templatePath = path.join(basePath, 'template');

  checkDirector(templatePath);

  return templatePath;
}

Future<void> updateTemplateFromGithub() async {
  String templatePath = await getAgilityTemplatePath();

  var shell = Shell(throwOnError: false, workingDirectory: templatePath);

  bool hasGit = await isGitDirectory(templatePath, shell);

  if (hasGit) {
    await shell.run('git pull');
  } else {
    await shell.run('git clone https://github.com/songfei/agility_redux_bloc_template.git .');
  }
}

Future<bool> isGitDirectory(String templatePath, Shell shell) async {
  var result = await shell.run('git rev-parse --is-inside-work-tree');
  if (result.first.exitCode == 0) {
    return true;
  }
  return false;
}

Future<List<String>> listTemplateFile(
  String templateBasePath, {
  String templateName = 'default',
}) async {
  String templatePath = path.join(templateBasePath, templateName);
  Directory templateDirectory = Directory(templatePath);
  var list = templateDirectory.list(recursive: true);

  List<String> result = [];

  await list.forEach((element) {
    if (element is File) {
      if (element.path.endsWith('.DS_Store')) {
        return;
      }
      result.add(element.path);
    }
  });

  return result;
}

Future<void> renderTemplateFile({
  required String baseTemplatePath,
  required String templateFilePath,
  required String outputPath,
  required Map<String, dynamic> data,
}) async {
  File templateFile = File(templateFilePath);
  String templateText = await templateFile.readAsString();
  var template = Template(templateText);

  String filePath = templateFilePath.substring(baseTemplatePath.length + 1);
  var filePathTemplate = Template(filePath);
  filePath = filePathTemplate.renderString(data);

  String outputFilePath = path.join(outputPath, filePath);
  print('generate: $outputFilePath');
  File outputFile = File(outputFilePath);
  if (!await outputFile.parent.exists()) {
    await outputFile.parent.create(recursive: true);
  }

  await outputFile.writeAsString(template.renderString(data));
}

Future<void> renderTemplate({
  required String templateBasePath,
  String templateName = 'default',
  required String outputPath,
  required Map<String, dynamic> data,
}) async {
  var fileList = await listTemplateFile(templateBasePath, templateName: templateName);
  String templatePath = path.join(templateBasePath, templateName);
  for (final fileItem in fileList) {
    renderTemplateFile(
      baseTemplatePath: templatePath,
      templateFilePath: fileItem,
      outputPath: outputPath,
      data: data,
    );
  }
}
