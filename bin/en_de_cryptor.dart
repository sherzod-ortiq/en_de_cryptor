import 'dart:io';

import 'package:args/args.dart';

import '../lib/en_de_cryptor.dart';

const encr = 'encrypt';
const decr = 'decrypt';
const help = 'help';
const helpMessage = '''
Usage format:
  <command> -<action flag> <file path>

  Action flags:
    -e or --encrypt - encrypt
    -d or --decrypt - decrypt''';
void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(encr, abbr: 'e')
    ..addFlag(decr, abbr: 'd')
    ..addFlag(help, abbr: 'h');

  try {
    ArgResults argResults = parser.parse(arguments);
    final paths = argResults.rest;

    if (argResults[help]) {
      stdout.writeln(helpMessage);
      return;
    }

    if (argResults[encr] == argResults[decr]) {
      if (argResults[encr]) {
        stdout.writeln('Use one flag at a time.');
      } else {
        stdout.writeln('No flag was chosen.');
      }
      stdout.writeln('Use -h or --help for help');
      return;
    } else {
      if (paths.length > 1) {
        stdout.writeln('Choose only one file at a time.');
        stdout.writeln('Use -h or --help for help');
        return;
      }
      if (paths.length <= 0) {
        stdout.writeln('No file was chosen.');
        stdout.writeln('Use -h or --help for help');
        return;
      }
      if (await FileSystemEntity.isDirectory(paths[0])) {
        stdout.writeln('Only files are accepted, not directories.');
        stdout.writeln('Use -h or --help for help');
        return;
      }
    }

    argResults[encr] ? encypt(getKey(), paths[0]) : decypt(getKey(), paths[0]);
  } catch (e) {
    stderr.writeln(e.toString());
    return;
  }
}

String? getKey() {
  try {
    stdin.echoMode = false;
    stdout.writeln("Enter key:");
    final String? key = stdin.readLineSync();
    if (!([16, 24, 32].contains(key!.length))) {
      throw ('Wrong key length, only 16, 24, 32 are allowed.');
    }
    return key;
  } catch (e) {
    throw (e);
  }
}
