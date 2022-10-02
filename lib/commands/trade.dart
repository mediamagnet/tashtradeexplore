import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;
// import 'package:tashtradeexplore/utils.dart' as utils;

Future<void> loadCommand(ISlashCommandInteractionEvent event) async {
  File file = File('./font/atkinson.zip');
  List<int> font = file.readAsBytesSync();
  final tag = event.interaction.getArg('tag'); // Carrier Tag
  final name = event.interaction.getArg('name'); // Carrier name
  final ident = event.interaction.getArg('ident'); // Carrier Ident
  final commodity = event.interaction.getArg('commodity'); // Traded Commodity
  final station = event.interaction.getArg('station'); // Station
  final system = event.interaction.getArg('system'); // System
  final profit = event.interaction.getArg('profit'); // Profit
  final units = event.interaction.getArg('units'); // Total units
  final bg = event.interaction.getArg('bg'); // Background if not default
  final logo = event.interaction.getArg('logo'); // Logo of carrier
  var baseImage;
  var resizedImage;
  var logoImage;
  var msgText;
  var resLogo;


  await event.acknowledge(hidden: true);

  if (bg == null) {
    final bgImg = File('tradeDefault_bg.png').uri.pathSegments.last;
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
      new File('tradeDl_bg.png').writeAsBytes(response.bodyBytes);
    });
    final bgImg = File('tradeDl_bg.png').uri.pathSegments.last;
    print(bgImg.length);
    baseImage = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage, width: 854);
  }

  print('$tag, $name, $station, $system, $units, $bg, $logo');

  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 208,
      'New Carrier load request for:');
  if (tag == null) {
    drawString(resizedImage!, BitmapFont.fromZip(font), 0, 248,
        'Carrier: $name $ident');
  } else {
    drawString(resizedImage!, BitmapFont.fromZip(font), 0, 248,
        'Carrier: $tag $name $ident');
  }
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 288,
      'Load from: $station in $system');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 328,
      'Load $units of $commodity');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 408,
      'Total Profit $profit K/Unit');

  if (logo != null) {
    http
        .get(Uri.parse(event.interaction.resolved!.attachments
            .singleWhere((logo) => logo.id == event.interaction.getArg('logo'))
            .url))
        .then((response) {
      new File('tradeLogo.png').writeAsBytes(response.bodyBytes);
    });
    final logoImg = File('tradeLogo.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 150) {
      resLogo = copyResize(logoImage, width: 150);
      File('tradeLogo1.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('tradeLogo1.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    final xSize = logoImage!.width.toInt();
    final ySize = logoImage!.height.toInt();
    final xLoc = 854 - xSize;
    final yLoc = 480 - ySize;
    drawImage(resizedImage!, resLogo!, dstX: xLoc.toInt(), dstY: yLoc.toInt());
  }

  File('tradeFinal.png').writeAsBytesSync(encodePng(resizedImage));
  String outF = File('tradeFinal.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  if (tag == null) {
    msgText =
        '```New Load Mission for ***$name $ident*** \nLoad ***$units*** of ***$commodity*** for ***$profit*** per unit from ***$station*** in ***$system***```';
  } else {
    msgText =
        '```New Load Mission for ***$tag $name $ident*** \nLoad ***$units*** of ***$commodity*** for ***$profit*** per unit from ***$station*** in ***$system***```';
  }

  return event.respond(MessageBuilder.content(msgText)..files = [attachment],
      hidden: true);
}

Future<void> unloadCommand(ISlashCommandInteractionEvent event) async {
  File file = File('./font/atkinson.zip');
  List<int> font = file.readAsBytesSync();
  final tag = event.interaction.getArg('tag'); // Carrier Tag
  final name = event.interaction.getArg('name'); // Carrier name
  final ident = event.interaction.getArg('ident'); // Carrier Ident
  final commodity = event.interaction.getArg('commodity'); // Traded Commodity
  final station = event.interaction.getArg('station'); // Station
  final system = event.interaction.getArg('system'); // System
  final profit = event.interaction.getArg('profit'); // Profit
  final units = event.interaction.getArg('units'); // Total units
  final bg = event.interaction.getArg('bg'); // Background if not default
  final logo = event.interaction.getArg('logo'); // Logo of carrier
  var baseImage;
  var resizedImage;
  var logoImage;
  var msgText;
  var resLogo;

  await event.acknowledge(hidden: true);

  if (bg == null) {
    final bgImg = File('tradeDefault_bg.png').uri.pathSegments.last;
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
      new File('tradeDl_bg.png').writeAsBytes(response.bodyBytes);
    });
    final bgImg = File('tradeDl_bg.png').uri.pathSegments.last;
    print(bgImg.length);
    baseImage = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage, width: 854);
  }

  print('$tag, $name, $station, $system, $units, $bg, $logo');

  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 208,
      'New Carrier unload request for:');
  if (tag == null) {
    drawString(resizedImage!, BitmapFont.fromZip(font), 0, 248,
        'Carrier: $name $ident');
  } else {
    drawString(resizedImage!, BitmapFont.fromZip(font), 0, 248,
        'Carrier: $tag $name $ident');
  }
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 288,
      'Unload to: $station in $system');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 328,
      'Unload $units of $commodity');
  drawString(resizedImage!, BitmapFont.fromZip(font), 0, 408,
      'Total Profit $profit K/Unit');

  if (logo != null) {
    http
        .get(Uri.parse(event.interaction.resolved!.attachments
            .singleWhere((logo) => logo.id == event.interaction.getArg('logo'))
            .url))
        .then((response) {
      new File('tradeLogo.png').writeAsBytes(response.bodyBytes);
    });
    final logoImg = File('tradeLogo.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 150) {
      resLogo = copyResize(logoImage, width: 150);
      File('tradeLogo1.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('tradeLogo1.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    final xSize = logoImage!.width.toInt();
    final ySize = logoImage!.height.toInt();
    final xLoc = 854 - xSize;
    final yLoc = 480 - ySize;
    drawImage(resizedImage!, resLogo!, dstX: xLoc.toInt(), dstY: yLoc.toInt());
  }

  File('tradeFinal.png').writeAsBytesSync(encodePng(resizedImage));
  String outF = File('tradeFinal.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  if (tag == null) {
    msgText =
        '```New Unload Mission for ***$name $ident*** \nUnload ***$units*** of ***$commodity*** for ***$profit*** per unit to ***$station*** in ***$system***```';
  } else {
    msgText =
        '```New Unload Mission for ***$tag $name $ident*** \nUnload ***$units*** of ***$commodity*** for ***$profit*** per unit to ***$station*** in ***$system***```';
  }

  return event.respond(MessageBuilder.content(msgText)..files = [attachment],
      hidden: true);
}
