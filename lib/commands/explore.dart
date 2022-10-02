import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;

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
  final oldImg = File('final.png');
  final logoFile = File('logo.png');
  final logoFile1 = File('logo1.png');
  final dlOld = File('dl_bg.png');

  if (oldImg.exists == true) {
    oldImg.delete();
  }
  if (logoFile.exists == true) {
    logoFile.delete();
  }
  if (logoFile1.exists == true) {
    logoFile1.delete();
  }
  if (dlOld.exists == true) {
    dlOld.delete();
  }

  await event.acknowledge();

  if (bg == null) {
    final bgImg = File('default_bg.png').uri.pathSegments.last;
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
      new File('dl_bg.png').writeAsBytes(response.bodyBytes);
    });
    final bgImg = File('dl_bg.png').uri.pathSegments.last;
    print(bgImg.length);
    baseImage = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage, width: 854);
  }

  print('$tag, $name, $start, $end, $duration, $bg, $logo');

  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 208,
      'New Exploration Mission to:');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 248, dest);
  if (tag == null) {
    drawString(resizedImage!, BitmapFont.fromZip(font), 0, 288,
        'Carrier: $name $ident');
  } else {
    drawString(resizedImage!, BitmapFont.fromZip(font), 0, 288,
        'Carrier: $tag $name $ident');
  }
  drawString(
      resizedImage!, BitmapFont.fromZip(font), 0, 328, 'Start System: $start');
  drawString(
      resizedImage!, BitmapFont.fromZip(font), 0, 368, 'End System: $end');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 408,
      'Start Date: $startDate');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 448,
      'Duration: $duration days');

  if (logo != null) {
    http
        .get(Uri.parse(event.interaction.resolved!.attachments
            .singleWhere((logo) => logo.id == event.interaction.getArg('logo'))
            .url))
        .then((response) {
      new File('logo.png').writeAsBytes(response.bodyBytes);
    });
    final logoImg = File('logo.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 150) {
      resLogo = copyResize(logoImage, width: 150);
      File('logo1.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('logo1.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    final xSize = logoImage!.width.toInt();
    final ySize = logoImage!.height.toInt();
    final xLoc = 854 - xSize;
    final yLoc = 480 - ySize;
    drawImage(resizedImage!, resLogo!, dstX: xLoc.toInt(), dstY: yLoc.toInt());
  }

  File('final.png').writeAsBytesSync(encodePng(resizedImage));
  String outF = File('final.png').uri.pathSegments.last;
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
