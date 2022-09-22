import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';

Future<void> exploreCommand(ISlashCommandInteractionEvent event) async {
  File file = File('./font/atkinson.zip');
  List<int> font = file.readAsBytesSync();
  final tag = event.interaction.getArg('tag');
  final name = event.interaction.getArg('name');
  final start = event.interaction.getArg('start');
  final end = event.interaction.getArg('end');
  final duration = event.interaction.getArg('duration');
  final bg = event.interaction.getArg('bg');
  final logo = event.interaction.getArg('logo');
  var baseImage;

  await event.acknowledge();

  if (bg == null) {
    final bgImg = File('default_bg.png').uri.pathSegments.last;
    baseImage = decodePng(File(bgImg).readAsBytesSync());
  } else {
    final request = await HttpClient().getUrl(
        Uri.parse(event.interaction.resolved!.attachments.elementAt(0).url));
    final response = await request.close();
    response.pipe(File('dl_bg.png').openWrite());
    final bgImg = File('dl.bg.png').uri.pathSegments.last;
    baseImage = decodePng(File(bgImg).readAsBytesSync());
  }

  print('$tag, $name, $start, $end, $duration, $bg, $logo');

  drawString(baseImage!, BitmapFont.fromZip(font), 0, 0, 'Carrier: $tag $name');
  drawString(baseImage!, BitmapFont.fromZip(font), 0, 50, 'Start Date: $start');
  drawString(baseImage!, BitmapFont.fromZip(font), 0, 100, 'End Date: $end');
  File('test.png').writeAsBytesSync(encodePng(baseImage));
  String outF = File('test.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  return event
      .respond(MessageBuilder.content('New File here!')..files = [attachment]);
}
