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

    print('Connected');

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
            CommandOptionType.string, 'ident', "Carrier's Identification Tag",
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'start-date', 'Start system of mission',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'start', 'System Mission Starts in',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'end', 'System mission ends in',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'destination', 'destination system',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'duration', 'How long mission runs for.',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'tag', "Carrier tag i.e. N.A.C. or T.S.C. (Optional)",
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'bg', 'background image (Optional)',
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'logo', 'logo of carrier (Optional)',
            required: false)
      ])
            ..registerHandler(tte.exploreCommand))
      ..syncOnReady();
  } catch (e) {
    print(e);
  }
}
