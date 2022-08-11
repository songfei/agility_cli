import 'dart:io';

String? homeDirectory() {
  switch (Platform.operatingSystem) {
    case 'linux':
    case 'macos':
      return Platform.environment['HOME'];

    case 'windows':
      return Platform.environment['USERPROFILE'];

    default:
      return null;
  }
}
