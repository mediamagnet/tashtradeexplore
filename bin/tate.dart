import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:toml/toml.dart';
import 'package:tashtradeexplore/tte.dart' as tte;
// import 'package:tashtradeexplore/utils.dart' as utils;
import 'dart:async';

late INyxxWebsocket bot;

var ownerID;
var launch = DateTime.now();
var botID;
var botToken;
var file = 'config.toml';

Future main() async {
  try {
    var document = await TomlDocument.load(file);
    var config = document.toMap();
    print('Loaded config file' + file);
    ownerID = config['Owner']['ID'];
    botID = config['Bot']['ID'];
    botToken = config['Bot']['Token'];

    print(botToken);

    bot = NyxxFactory.createNyxxWebsocket(botToken, GatewayIntents.all)
      ..registerPlugin(Logging())
      ..registerPlugin(IgnoreExceptions())
      ..registerPlugin(CliIntegration())
      ..connect();

    bot.onReady.listen((IReadyEvent e) {
      print('Connected to Discord');

//      bot.setPresence(PresenceBuilder.of(
//          status: UserStatus.online,
//          activity: ActivityBuilder('with the BGS', ActivityType.game,
//              url: 'https://github.com/mediamagnet/tashtradeexplore')));
    });

    IInteractions.create(WebsocketInteractionBackend(bot))
      ..registerSlashCommand(
          SlashCommandBuilder('explore', 'Set up exploration mission', [
        CommandOptionBuilder(CommandOptionType.string, 'name', "Carrier's name",
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'start', 'Start system of mission',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'end', 'System mission ends in',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'duration', 'How long misison runs for.',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'tag', "Adds carriers tag if it has one",
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'bg', 'background image',
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'logo', 'logo of carrier',
            required: false)
      ])
            ..registerHandler(tte.exploreCommand))
      ..syncOnReady();
  } catch (e) {
    print(e);
  }
}
