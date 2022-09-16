import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'dart:math';
import 'package:nyxx/nyxx.dart';

Future<void> exploreCommand(ISlashCommandInteractionEvent event) async {
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));
  Image image = Image(1000, 150);
  fill(image, getColor(0, 0, 255));
  drawString(image, arial_24, 0, 0, 'Hello World');
  drawLine(image, 0, 0, 1000, 150, getColor(255, 0, 0), thickness: 3);
  gaussianBlur(image, 10);
  File('test.png').writeAsBytesSync(encodePng(image));
  String outF = File('test.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  return event
      .respond(MessageBuilder.content('New File here!')..files = [attachment]);
}
