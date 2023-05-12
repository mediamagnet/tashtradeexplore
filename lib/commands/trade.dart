import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;
// import 'package:tashtradeexplore/utils.dart' as utils;

Future<void> loadCommand(ISlashCommandInteractionEvent event) async {
  File file1 = File('./font/atkinson.zip');
  List<int> atkinson = file1.readAsBytesSync();
  File file2 = File('./font/varino.zip');
  List<int> varino = file2.readAsBytesSync();
  File file3 = File('./font/atkinson18.zip');
  List<int> atkinson18 = file3.readAsBytesSync();
  File file4 = File('./font/atkinson22.zip');
  List<int> atkinson22 = file4.readAsBytesSync();
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
  var baseImageFile = File('./images/tradebase.png').uri.pathSegments.last;
  baseImage = decodePng(File(baseImageFile).readAsBytesSync());

  await event.acknowledge(hidden: true);

  if (bg != null) {
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
      new File('./images/tradeDl_bg.png').writeAsBytes(response.bodyBytes);
    });
    final bgImg = File('./images/tradeDl_bg.png').uri.pathSegments.last;
    print(bgImg.length);
    var baseImage1 = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage1!, width: 434);
    compositeImage(baseImage, resizedImage!, dstX: 42, dstY: 12);
  }

  print('$tag, $name, $station, $system, $units, $bg, $logo');

  drawString(baseImage!,font: BitmapFont.fromZip(varino),x: 546,y: 38,
      'CARRIER LOADING MISSION');
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson18),x: 702,y: 62,
      ident.toString().toUpperCase());
  if (tag != null) {
    drawString(baseImage!,font: BitmapFont.fromZip(atkinson22),x: 546,y: 83,
        "$tag $name".toUpperCase());
  } else {
    drawString(baseImage!,font: BitmapFont.fromZip(atkinson22),x: 546,y: 83,
        "$name".toUpperCase());
  }
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 125,
      commodity.toString().toUpperCase());
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 157,
      system.toString().toUpperCase());
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 189,
      station.toString().toUpperCase());
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 221,
      '$profit k per unit, $units units');

  if (logo != null) {
    http
        .get(Uri.parse(event.interaction.resolved!.attachments
            .singleWhere((logo) => logo.id == event.interaction.getArg('logo'))
            .url))
        .then((response) {
      new File('./images/tradeLogo.png').writeAsBytes(response.bodyBytes);
    });
    final logoImg = File('./images/tradeLogo.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 150) {
      resLogo = copyResize(logoImage, width: 100);
      File('./images/tradeLogo1.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('./images/tradeLogo1.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    compositeImage(baseImage!, resLogo!, dstX: 930, dstY: 13);
  } else {
    final logoImg = File('./images/trade.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 100) {
      resLogo = copyResize(logoImage, width: 100);
      File('./images/trade.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('./images/trade.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    compositeImage(baseImage!, resLogo!, dstX: 930, dstY: 13);
  }

  File('./images/tradeFinal.png').writeAsBytesSync(encodePng(baseImage));
  String outF = File('./images/tradeFinal.png').uri.pathSegments.last;
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
  File file1 = File('./font/atkinson.zip');
  List<int> atkinson = file1.readAsBytesSync();
  File file2 = File('./font/varino.zip');
  List<int> varino = file2.readAsBytesSync();
  File file3 = File('./font/atkinson18.zip');
  List<int> atkinson18 = file3.readAsBytesSync();
  File file4 = File('./font/atkinson22.zip');
  List<int> atkinson22 = file4.readAsBytesSync();
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
  var baseImageFile = File('./images/tradebase.png').uri.pathSegments.last;
  baseImage = decodePng(File(baseImageFile).readAsBytesSync());

  await event.acknowledge(hidden: true);

  if (bg != null) {
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
      new File('./images/tradeDl_bg.png').writeAsBytes(response.bodyBytes);
    });
    final bgImg = File('./images/tradeDl_bg.png').uri.pathSegments.last;
    print(bgImg.length);
    var baseImage1 = decodePng(File(bgImg).readAsBytesSync());
    resizedImage = copyResize(baseImage1!, width: 434);
    compositeImage(baseImage, resizedImage!, dstX: 42, dstY: 12);
  }

  print('$tag, $name, $station, $system, $units, $bg, $logo');

  drawString(baseImage!,font: BitmapFont.fromZip(varino),x: 546,y: 38,
      'CARRIER UNLOADING MISSION');
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson18),x: 702,y: 62,
      ident.toString().toUpperCase());
  if (tag != null) {
    drawString(baseImage!,font: BitmapFont.fromZip(atkinson22),x: 546,y: 83,
        "$tag $name".toUpperCase());
  } else {
    drawString(baseImage!,font: BitmapFont.fromZip(atkinson22),x: 546,y: 83,
        "$name".toUpperCase());
  }
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 125,
      commodity.toString().toUpperCase());
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 157,
      system.toString().toUpperCase());
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 189,
      station.toString().toUpperCase());
  drawString(baseImage!,font: BitmapFont.fromZip(atkinson),x: 671,y: 221,
      '$profit k per unit, $units units');

  if (logo != null) {
    http
        .get(Uri.parse(event.interaction.resolved!.attachments
            .singleWhere((logo) => logo.id == event.interaction.getArg('logo'))
            .url))
        .then((response) {
      new File('./images/tradeLogo.png').writeAsBytes(response.bodyBytes);
    });
    final logoImg = File('./images/tradeLogo.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 150) {
      resLogo = copyResize(logoImage, width: 100);
      File('./images/tradeLogo1.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('./images/tradeLogo1.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    compositeImage(baseImage!, resLogo!, dstX: 930, dstY: 13);
  } else {
    final logoImg = File('./images/trade.png').uri.pathSegments.last;
    logoImage = decodePng(File(logoImg).readAsBytesSync());
    if (logoImage!.width >= 100) {
      resLogo = copyResize(logoImage, width: 100);
      File('./images/trade.png').writeAsBytesSync(encodePng(resLogo));
      var resLogo1 = File('./images/trade.png').uri.pathSegments.last;
      logoImage = decodePng(File(resLogo1).readAsBytesSync());
    }
    compositeImage(baseImage!, resLogo!, dstX: 930, dstY: 13);
  }

  File('./images/tradeFinal.png').writeAsBytesSync(encodePng(baseImage));
  String outF = File('./images/tradeFinal.png').uri.pathSegments.last;
  print(outF);
  final attachment = AttachmentBuilder.file(File(outF));

  if (tag == null) {
    msgText =
        '```New Load Mission for ***$name $ident*** \nUnload ***$units*** of ***$commodity*** for ***$profit*** per unit from ***$station*** in ***$system***```';
  } else {
    msgText =
        '```New Load Mission for ***$tag $name $ident*** \nUnload ***$units*** of ***$commodity*** for ***$profit*** per unit from ***$station*** in ***$system***```';
  }

  return event.respond(MessageBuilder.content(msgText)..files = [attachment],
      hidden: true);
}
