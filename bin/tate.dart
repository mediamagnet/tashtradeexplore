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
var botStatus;
var file = 'config.toml';

Future main() async {
  try {
    var document = await TomlDocument.load(file);
    var config = document.toMap();
    print('Loaded config file' + file);
    ownerID = config['Owner']['ID'];
    botID = config['Bot']['ID'];
    botToken = config['Bot']['Token'];
    botStatus = config['Bot']['Status'];

    print('Connected');

    bot = NyxxFactory.createNyxxWebsocket(botToken, GatewayIntents.all)
      ..registerPlugin(Logging())
      ..registerPlugin(IgnoreExceptions())
      ..registerPlugin(CliIntegration())
      ..connect();

    bot.eventsWs.onReady.listen((IReadyEvent e) {
      print('Connected to Discord');

      bot.setPresence(PresenceBuilder.of(
          status: UserStatus.online,
          activity: ActivityBuilder(botStatus, ActivityType.game,
              url: 'https://github.com/mediamagnet/tashtradeexplore')));
    });

    bot.eventsWs.onMessageReceived.listen((IMessageReceivedEvent e) {
      if (e.message.content.contains(botID)) {
        e.message.createReaction(UnicodeEmoji('🫡'));
      }
    });

    IInteractions.create(WebsocketInteractionBackend(bot))
      ..registerSlashCommand(SlashCommandBuilder('ping', 'Shows latency', [])
        ..registerHandler((tte.pingCommand)))
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
        CommandOptionBuilder(CommandOptionType.string, 'tag',
            "Carrier tag i.e. N.A.C. or T.S.C. (Optional)",
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'bg', 'background image (Optional)',
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'logo', 'logo of carrier (Optional)',
            required: false)
      ])
            ..registerHandler(tte.exploreCommand))
      ..registerSlashCommand(
          SlashCommandBuilder('load', 'Create a Loading Mission', [
        CommandOptionBuilder(CommandOptionType.string, 'name', "Carrier's name",
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'ident', "Carrier's Identification Tag",
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'commodity', 'Commodity you are loading',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'system', 'System loading from',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'station', 'Station loading from',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'units', 'Total number of units',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'profit', 'Profit in K credits per unit.',
            required: true),
        CommandOptionBuilder(CommandOptionType.string, 'tag',
            "Carrier tag i.e. N.A.C. or T.S.C. (Optional)",
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'bg', 'background image (Optional)',
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'logo', 'logo of carrier (Optional)',
            required: false)
      ])
            ..registerHandler((tte.loadCommand)))
      ..registerSlashCommand(
          SlashCommandBuilder('unload', 'Create an unloading mission', [
        CommandOptionBuilder(CommandOptionType.string, 'name', "Carrier's name",
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'ident', "Carrier's Identification Tag",
            required: true),
        CommandOptionBuilder(CommandOptionType.string, 'commodity',
            'Commodity you are unloading',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'system', 'System unloading from',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'station', 'Station unloading from',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'units', 'Total number of units',
            required: true),
        CommandOptionBuilder(
            CommandOptionType.string, 'profit', 'Profit in K credits per unit.',
            required: true),
        CommandOptionBuilder(CommandOptionType.string, 'tag',
            "Carrier tag i.e. N.A.C. or T.S.C. (Optional)",
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'bg', 'background image (Optional)',
            required: false),
        CommandOptionBuilder(
            CommandOptionType.attachment, 'logo', 'logo of carrier (Optional)',
            required: false)
      ])
            ..registerHandler((tte.unloadCommand)))
      ..syncOnReady();
  } catch (e) {
    print(e);
  }
}
