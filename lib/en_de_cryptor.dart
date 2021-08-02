import 'dart:io';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';

void hello() {
  String keyString = getKey();
  String plainText = getText();
  final Key key = Key.fromUtf8(keyString);
  final iv = IV.fromSecureRandom(16); // has size equal to AES single block size
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final encrData = '${iv.base64}${encrypted.base64}';
  final encrIv = encrData.substring(
      0, 24); // 24 because base64 uses padding, TO DO: read about it
  final encrPayload = encrData.substring(24);

  print(encrIv);
  print(encrPayload);

  final decrPayload = encrypter.decrypt64(
    base64.normalize(encrPayload),
    iv: IV.fromBase64(encrIv),
  );

  print(decrPayload);
}

String getKey() {
  print("Enter key:");
  stdin.echoMode = false;
  return stdin.readLineSync();
}

String getText() {
  print("Enter text:");
  stdin.echoMode = true;
  return stdin.readLineSync();
}
