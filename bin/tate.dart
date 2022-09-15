import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:toml/toml.dart';
import 'package:tashtradeexplore/utils.dart' as utils;
import 'dart:async';

late INyxxWebsocket bot;

var ownerID;
var launch = DateTime.now();
var botID;
var botToken;

Future main() async {
  await utils.tomlFile('config.toml');
  ownerID = utils.conf('Owner/ID');
  botID = utils.conf('Bot/ID');
  botToken = utils.conf('Bot/Token');

  bot = NyxxFactory.createNyxxWebsocket(botToken, GatewayIntents.all)
    ..registerPlugin(Logging())
    ..registerPlugin(IgnoreExceptions())
    ..registerPlugin(CliIntegration())
    ..connect();

  bot.onReady.listen((IReadyEvent e) {
    print('Connected to Discord');

    bot.setPresence(PresenceBuilder.of(
        status: UserStatus.online,
        activity: ActivityBuilder('with the BGS', ActivityType.game,
            url: 'https://github.com/mediamagnet/tashtradeexplore')));
  });

  IInteractions.create(WebsocketInteractionBackend(bot))
    ..registerSlashCommand(SlashCommandBuilder(
      "test",
      "this is a test command",
      [
        CommandOptionBuilder(
            CommandOptionType.subCommand, "subtest", "This is a subtest")
          ..registerHandler(
              (event) => event.respond(MessageBuilder.content('Example')))
      ],
    ))
    ..syncOnReady(
        syncRule:
            ManualCommandSync(sync: utils.getSyncCommandsOrOverride(true)));
}
