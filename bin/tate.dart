import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:toml/toml.dart';
import 'package:tashtradeexplore/utils.dart' as utils;
import 'dart:async';
import 'package:logging/logging.dart';

late INyxxWebsocket bot;

var ownerID;
var launch = DateTime.now();
var botID;
var botToken;

Future main(List<String> arguments) async {
  await utils.tomlFile('config.toml');
  Logger.root.level = Level.INFO;
  try {
    ownerID = utils.conf('Owner/ID');
    botID = utils.conf('Bot/ID');
    botToken = utils.conf('Bot/Token');

    bot = NyxxFactory.createNyxxWebsocket(botToken, GatewayIntents.all)
      ..registerPlugin(Logging())
      ..registerPlugin(IgnoreExceptions())
      ..registerPlugin(CliInterface())
      ..connect();

    bot.onReady.listen((IReadyEvent e) {
      print('Connected to Discord');

      bot.setPresence(PresenceBuilder.of(
          status: UserStatus.online,
          activity: ActivityBuilder('with the BGS', ActivityType.game,
              url: 'https://github.com/mediamagnet/tashtradeexplore')));

      bot.eventsWs.onMessageReceived.listen((IMessageReceivedEvent e) {
        if (e.message.content.contains(botID)) {
          e.message.createReaction(UnicodeEmoji('🟥'));
        }
      });
    });

    IInteractions.create(WebsocketInteractionBackend(bot))
      ..registerHandler("test", "This is test command", [],
          handler: (event) async {
        await event
            .reply(MessageBuilder.content("This is example message result"));
      })
      ..syncOnReady(
          syncRule:
              ManualCommandSync(sync: utils.getSyncCommandsOrOverride(true)));
  } catch (e) {
    print(e);
  }
}
