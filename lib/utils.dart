// import 'dart:async';
import 'dart:io';
// 
// import 'package:nyxx/nyxx.dart';
// import 'package:toml/toml.dart';
// // import 'package:toml/toml.dart';
// // import 'dart:convert';
// 
// DateTime _approxMemberCountLastAccess = DateTime.utc(2005);
// int _approxMemberCount = -1;
// int _approxMemberOnline = -1;
// var document;

//Future tomlFile(String file) async {
//  try {
//    document = await TomlDocument.load(file);
//    var config = document.toMap();
//    print('Loaded config file' + file);
//  } catch (e) {
//    print('ERROR: $e')
//  }
//  return config
//}

// String? get TOMLPrefix => conf('Bot/Prefix');

Future<void> cleanImages(List images) async {
  images.forEach((image) {
    var image1 = File(image);
    if (image1.exists != false) {
      image1.delete();
    }
  });
}