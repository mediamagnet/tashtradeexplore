import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;
// import 'package:tashtradeexplore/utils.dart' as utils;

Future<void> exploreCommand(ISlashCommandInteractionEvent event) async {
  File file = File('./font/atkinson.zip');
  List<int> font = file.readAsBytesSync();
  final tag = event.interaction.getArg('tag'); // Carrier Tag
  final name = event.interaction.getArg('name'); // Carrier name
  final ident = event.interaction.getArg('ident'); // Carrier Ident
  final startDate = event.interaction.getArg('start-date'); // Start Date
  final start = event.interaction.getArg('start'); // Start System
  final end = event.interaction.getArg('end'); // End System
  final dest = event.interaction.getArg('destination'); // Target System
  final duration = event.interaction.getArg('duration'); // Length of mission
  final bg = event.interaction.getArg('bg'); // Background if not default
  final logo = event.interaction.getArg('logo'); // Logo of carrier
  var baseImage;
  var resizedImage;
  var logoImage;
  var msgText;
  var resLogo;

//  utils.cleanImages(['final.png', 'logo.png', 'logo1.png', 'dl_bg.png']);

  await event.acknowledge(hidden: true);

  if (bg == null) {
    final bgImg = File('./images/default_bg.png').uri.pathSegments.last;
    baseImage = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage, width: 854);
  } else {
    print(event.interaction.resolved!.attachments
        .singleWhere((bg) => bg.id == event.interaction.getArg('bg'))
        .url);
    print(event.interaction.resolved!.attachments.length);
    print(event.interaction.resolved!.attachments
        .singleWhere((logo) => logo.id == event.interaction.getArg('logo'))
        .url);
    http
        .get(Uri.parse(event.interaction.resolved!.attachments
            .singleWhere((bg) => bg.id == event.interaction.getArg('bg'))
            .url))
        .then((response) {
      new File('./images/dl_bg.png').writeAsBytes(response.bodyBytes);
    });
    final bgImg = File('./images/dl_bg.png').uri.pathSegments.last;
    print(bgImg.length);
    baseImage = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage, width: 854);
  }

  print('$tag, $name, $start, $end, $duration, $bg, $logo');

  drawString(resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 208,
      'New Exploration Mission to:');
  drawString(resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 248, dest);
  if (tag == null) {
    drawString(resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 288,
        'Carrier: $name $ident');
  } else {
    drawString(resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 288,
        'Carrier: $tag $name $ident');
  }
  drawString(
      resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 328, 'Start System: $start');
  drawString(
      resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 368, 'End System: $end');
  drawString(resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 408,
      'Start Date: $startDate');
  drawString(resizedImage!, font: BitmapFont.fromZip(font), x: 0, y: 448,
      'Duration: $duration days');

  if (logo != null) {
    http
        .get(Uri.parse(event.interaction.resolved!.attachments
            .singleWhere((logo) => logo.id == event.interaction.getArg('logo'))
            .url))
        .then((response) {
      new File('./images/logo.png').writeAsBytes(response.bodyBytes);
    });
    final logoImg = File('./images/logo.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 150) {
      resLogo = copyResize(logoImage, width: 150);
      File('./images/logo1.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('./images/logo1.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    final xSize = logoImage!.width.toInt();
    final ySize = logoImage!.height.toInt();
    final xLoc = 854 - xSize;
    final yLoc = 480 - ySize;
    compositeImage(resizedImage!, resLogo!, dstX: xLoc.toInt(), dstY: yLoc.toInt());
  }

  File('./images/final.png').writeAsBytesSync(encodePng(resizedImage));
  String outF = File('./images/final.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  if (tag == null) {
    msgText =
        '```New Exploration Mission on ***$name $ident*** to \n***$dest*** starts on ***$startDate*** from ***$start*** and returns to ***$end*** after ***$duration*** days.```';
  } else {
    msgText =
        '```New Exploration Mission on ***$tag $name $ident*** to \n***$dest*** starts on ***$startDate*** from ***$start*** and returns to ***$end*** after ***$duration*** days.```';
  }

  return event.respond(MessageBuilder.content(msgText)..files = [attachment],
      hidden: true);
}
