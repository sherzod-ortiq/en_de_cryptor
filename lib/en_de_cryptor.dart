import 'dart:io';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';

void encypt(encrKey, textFilePath) async {
  try {
    final String keyString = encrKey;
    final String textString = await File(textFilePath).readAsString();
    final Key key = Key.fromUtf8(keyString);
    final iv =
        IV.fromSecureRandom(16); // has size equal to AES single block size
    final Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final Encrypted encrypted = encrypter.encrypt(textString, iv: iv);
    final String encrData = '${iv.base64}${encrypted.base64}';

    await File(textFilePath).writeAsString(encrData);
  } catch (e) {
    throw (e);
  }
}

void decypt(encrKey, textFilePath) async {
  try {
    final String keyString = encrKey;
    final String encrData = await File(textFilePath).readAsString();
    final Key key = Key.fromUtf8(keyString);
    final Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrIv = encrData.substring(
        0, 24); // 24 because base64 uses padding, TO DO: read about it
    final encrPayload = encrData.substring(24);
    final decrPayload = encrypter.decrypt64(
      base64.normalize(encrPayload),
      iv: IV.fromBase64(encrIv),
    );

    await File(textFilePath).writeAsString(decrPayload);
  } catch (e) {
    throw (e);
  }
}
