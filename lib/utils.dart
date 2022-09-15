import 'dart:async';
import 'dart:io' show Platform, ProcessInfo;

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/nyxx_commander.dart';
import 'package:toml/toml.dart';
// import 'package:toml/toml.dart';
// import 'dart:convert';

DateTime _approxMemberCountLastAccess = DateTime.utc(2005);
int _approxMemberCount = -1;
int _approxMemberOnline = -1;
var document;

String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split('(').first;
}

bool get isTest => isBool(conf('bot/test'));
bool get syncCommands => isBool(conf('Bot/SyncCommands'));
Snowflake? get testGuildSnowflake =>
    isTest ? Snowflake(108344598018957312) : null;

bool isBool(String? value) {
  return value != null && (value == 'true' || value == '1');
}

bool getSyncCommandsOrOverride([bool? overrideSync]) =>
    overrideSync ?? syncCommands;

String getMemoryUsageString() {
  final current = (ProcessInfo.currentRss / 1024 / 1024).toStringAsFixed(2);
  final rss = (ProcessInfo.maxRss / 1024 / 1024).toStringAsFixed(2);
  return '$current/${rss}MB';
}

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

FutureOr<String?> prefixHandler(IMessage message) async =>
    mentionPrefixHandler(message) ?? TOMLPrefix;

String getApproxMemberCount(INyxxWebsocket client) {
  if (DateTime.now().difference(_approxMemberCountLastAccess).inMinutes > 5 ||
      _approxMemberCount == -1) {
    Future(() async {
      var amc = 0;
      var amo = 0;

      for (final element in client.guilds.values) {
        final guildPreview = await element.fetchGuildPreview();

        amc += guildPreview.approxMemberCount;
        amo += guildPreview.approxOnlineMembers;
      }

      _approxMemberCount = amc;
      _approxMemberOnline = amo;
    });
  }

  if (_approxMemberCount == -1 || _approxMemberOnline == -1) {
    return 'Loading...';
  }

  return '$_approxMemberOnline/$_approxMemberCount';
}
