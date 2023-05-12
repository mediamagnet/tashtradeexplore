import 'dart:convert';
import 'dart:math';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:http/http.dart' as http;
import 'package:toml/toml.dart';

Future<void> abandonedCommand(ISlashCommandInteractionEvent event) async {
  var document = await TomlDocument.load('config.toml');
  var config = document.toMap();
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));
  // Make a request to the Inara API to retrieve the information about the abandoned stations
  http.Response response = await http.get(Uri.parse(
      "https://inara.cz/inapi/v1/stations/?searchsystemname=&searchstationname=&stationstatustype=&minlandingpad=&maxlandingpad=&includestations=1&includemajorfactions=1&includedockedships=0&maxdistancely=&startrow=0&numrows=10000&sort=&cmdr_name=${config['Inara']['Token']}"));

  // Parse the JSON response
  Map<String, dynamic> data = json.decode(response.body);

  // Get the list of systems with abandoned stations
  List<Map<String, dynamic>> systems = data["stations"]
      .where((station) => station["stationStatus"] == "Abandoned")
      .map((station) => station["systemName"])
      .toSet()
      .toList();

  // Send the list of systems to the user who requested it

  final embed = EmbedBuilder()
    ..color = color
    ..addField(name: 'Systems', content: systems.toString(), inline: false);
  await event.respond(MessageBuilder.embed(embed));
}
