import 'dart:async';
import 'dart:io' show Platform, ProcessInfo;

import 'package:nyxx/nyxx.dart';
import 'package:toml/toml.dart';
// import 'package:toml/toml.dart';
// import 'dart:convert';

DateTime _approxMemberCountLastAccess = DateTime.utc(2005);
int _approxMemberCount = -1;
int _approxMemberOnline = -1;
var document;

Future<void> tomlFile(String file) async {
  document = await TomlDocument.load(file);
  print('Loaded config file' + file);
}

String conf(String path) {
  var config = document.toMap();
  var parts = path.split('/');
  for (var part in parts) {
    config = config[part];
  }
  return config;
}

String? get TOMLPrefix => conf('Bot/Prefix');
bool getSyncCommandsOrOverride([bool? overrideSync]) => overrideSync ?? syncCommands;