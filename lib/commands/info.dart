import 'dart:math';

import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;

Future<void> pingCommand(ISlashCommandInteractionEvent event) async {
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));
  final gatewayDelayInMillis = (event.client as INyxxWebsocket)
          .shardManager
          .shards
          .map((e) => e.gatewayLatency.inMilliseconds)
          .reduce((value, element) => value + element) /
      (event.client as INyxxWebsocket).shards;

  final apiStopwatch = Stopwatch()..start();
  await http.head(
      Uri(scheme: "https", host: Constants.host, path: Constants.baseUri));
  final apiPing = apiStopwatch.elapsedMilliseconds;

  final stopwatch = Stopwatch()..start();

  final embed = EmbedBuilder()
    ..color = color
    ..imageUrl = 'https://i.imgur.com/pFhWc7e.gif'
    ..addField(
        name: "Gateway latency",
        content: "${gatewayDelayInMillis.abs().floor()} ms",
        inline: true)
    ..addField(name: "REST latency", content: "$apiPing ms", inline: true)
    ..addField(
        name: "Message roundup time", content: "Pending...", inline: true);

  await event.respond(MessageBuilder.embed(embed));

  embed.replaceField(
      name: "Message roundup time",
      content: "${stopwatch.elapsedMilliseconds} ms",
      inline: true);

  await event.editOriginalResponse(MessageBuilder.embed(embed));
}
