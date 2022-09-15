import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:toml/toml.dart';
import 'package:tashtradeexplore/utils.dart';
import 'dart:async';

late INyxxWebsocket bot;

var ownerID;
var launch = DateTime.now();
var prefix;
var botID;
var botToken;

Future main(List<String> arguments) async {
    await utils.tomlFile('config.toml');
  // final cron = Cron();
  Logger.root.level = Level.INFO;
  try {

    ownerID = utils.conf('Owner/ID');
    botID = utils.conf('Bot/ID');
    botToken = utils.conf('Bot/Token');

    bot = NyxxFactory.createNyxxWebsocket(botToken, GatewayIntents.all)
      ..registerPlugin(Logging())
      ..registerPlugin(IgnoreExceptions());
    await bot.connect();

    bot.onReady.listen((IReadyEvent e){
      print('Connected to Discord');
      bot.setPresence(PresenceBuilder.of(
        status: UserStatus.online,
        activity: ActivityBuilder(
          'with the BGS', ActivityType.game,
          url: 'example.com')));
      
    })
}