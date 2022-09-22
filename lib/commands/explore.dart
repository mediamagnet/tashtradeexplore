import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';

Future<void> exploreCommand(ISlashCommandInteractionEvent event) async {
  File file = File('./font/atkinson.zip');
  List<int> font = file.readAsBytesSync();
  final tag = event.getArg('tag').value.toString();
  final name = event.getArg('name').value.toString();
  final start = event.getArg('start').value.toString();
  final end = event.getArg('end').value.toString();
  final duration = event.getArg('duration').value;
  print('$tag, $name, $start, $end, $duration');
  String defaultBg = File('bg.png').uri.pathSegments.last;
  var image = decodePng(File(defaultBg).readAsBytesSync());
  drawString(image!, BitmapFont.fromZip(font), 0, 0, 'Hello World!');
  File('test.png').writeAsBytesSync(encodePng(image));
  String outF = File('test.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  return event
      .respond(MessageBuilder.content('New File here!')..files = [attachment]);
}
