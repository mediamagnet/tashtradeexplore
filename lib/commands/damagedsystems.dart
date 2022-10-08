/*
/damagedsystems command. No arguments.
scrapes the following website and outputs the data to discord embed.
https://inara.cz/elite/thargoidwar-locations/

You may leave the comments in there if you want to, uncomment for debugging to console.

REFERENCES:
https://gpalma.pt/blog/web-scrappers-in-dart/
https://www.tutorialspoint.com/dart_programming/dart_programming_map.htm
https://stackoverflow.com/questions/49757486/how-to-use-regex-in-dart

AUTHOR:
Kougyoku

*/
import 'dart:math';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

Future<void> damagedsystemsCommand(ISlashCommandInteractionEvent event) async {
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));

//snag the page
  var client = http.Client();
  http.Response response = await client.get((Uri(
      scheme: "https",
      host: "inara.cz",
      path: "/elite/thargoidwar-locations/")));

//scrape the table data
  final dataExtrator = RegExp(r'>(?<data>.*)<\/a');
  var document = parser.parse(response.body);
  List<dom.Element> tableData = document.querySelectorAll('td');
  //print("table data: ");
  //print(tableData);
  //print('--------------');

  var tableDataMap = new Map();
  tableDataMap["sd"] = "";
  tableDataMap["star"] = "";
  tableDataMap["state"] = "";

  int i = 0;
  for (dom.Element tdata in tableData) {
    //  print("tdata: ");
    //  print(tdata);
    var htmlData = tdata.innerHtml;
    var match = dataExtrator.firstMatch(htmlData);
    // print("html data: " + htmlData);
    var matchedText = match?.group(1); //returns 'overlook' then 'hip22460'
    //  print("matched text string: ");
    //  print(matchedText);

    //Place the data into the map based on table position
    switch (i % 3) {
      case 0:
        tableDataMap["sd"] = tableDataMap["sd"] + matchedText + "\n";
        break;
      case 1:
        tableDataMap["star"] = tableDataMap["star"] + matchedText + "\n";
        break;
      case 2: //for future use?
        tableDataMap["state"] = "Damaged";
        break;
    }
    i++;
  }

  //print(tableDataMap["sd"]);

  final embed = EmbedBuilder()
    ..color = color
    ..addField(
        name: "Stations Damaged", content: tableDataMap["sd"], inline: true)
    ..addField(
        name: "Star System", content: tableDataMap["star"], inline: true);

  await event.respond(MessageBuilder.embed(embed));
  //print(tableHeaders);
}
