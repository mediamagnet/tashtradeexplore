import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';

Future<void> exploreCommand(ISlashCommandInteractionEvent event) async {
  String defaultBg = File('bg.png').uri.pathSegments.last;
  var image = decodePng(File(defaultBg).readAsBytesSync());
  drawString(image!, arial_48, 0,0, 'Hello World!');
  File('test.png').writeAsBytesSync(encodePng(image));
  String outF = File('test.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  return event
      .respond(MessageBuilder.content('New File here!')..files = [attachment]);
}
