import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;

Future<void> exploreCommand(ISlashCommandInteractionEvent event) async {
  File file = File('./font/atkinson.zip');
  List<int> font = file.readAsBytesSync();
  final tag = event.interaction.getArg('tag');
  final name = event.interaction.getArg('name');
  final startDate = event.interaction.getArg('start-date');
  final start = event.interaction.getArg('start');
  final end = event.interaction.getArg('end');
  final duration = event.interaction.getArg('duration');
  final bg = event.interaction.getArg('bg');
  final logo = event.interaction.getArg('logo');
  var baseImage;
  var resizedImage;

  await event.acknowledge();

  if (bg == null) {
    final bgImg = File('default_bg.png').uri.pathSegments.last;
    baseImage = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage, width: 854);
  } else {
    print(event.interaction.resolved!.attachments.first.url);
    http
        .get(Uri.parse(event.interaction.resolved!.attachments.first.url))
        .then((response) {
      new File('dl_bg.png').writeAsBytes(response.bodyBytes);
    });
    final bgImg = File('dl_bg.png').uri.pathSegments.last;
    print(bgImg.length);
    baseImage = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage, width: 854);
  }

  print('$tag, $name, $start, $end, $duration, $bg, $logo');

  drawString(
      resizedImage!, BitmapFont.fromZip(font), 0, 0, 'Carrier: $tag $name');
  drawString(
      resizedImage!, BitmapFont.fromZip(font), 0, 50, 'Start Date: $start');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 100, 'End Date: $end');

  File('test.png').writeAsBytesSync(encodePng(resizedImage));
  String outF = File('test.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  return event.respond(
      MessageBuilder.content('New File here!')..files = [attachment],
      hidden: true);
}
