import 'dart:convert';
import 'dart:math';

import 'package:fin_sage/core/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyService {
  SecureKeyService(this._storage);

  final FlutterSecureStorage _storage;

  static const AndroidOptions _primaryAndroidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'finsage_secure_storage',
    preferencesKeyPrefix: 'finsage_',
  );

  static const AndroidOptions _legacyAndroidOptions = AndroidOptions();

  Future<String?> readDbKey() async {
    final candidates = await readDbKeyCandidates();
    return candidates.isEmpty ? null : candidates.first;
  }

  Future<List<String>> readDbKeyCandidates() async {
    final candidates = <String>[];
    final existing = await _readWithOptions(_primaryAndroidOptions);
    if (existing != null) {
      candidates.add(existing);
    }

    final legacy = await _readWithOptions(_legacyAndroidOptions);
    if (legacy != null && !candidates.contains(legacy)) {
      candidates.add(legacy);
    }

    if (existing == null && legacy != null) {
      await _writeWithOptions(_primaryAndroidOptions, legacy);
    }

    return candidates;
  }

  Future<String> createDbKey() async {
    final random = Random.secure();
    final values = List<int>.generate(32, (_) => random.nextInt(256));
    final key = base64UrlEncode(values);
    final persisted = await persistDbKey(key);
    if (!persisted) {
      throw PlatformException(
        code: 'secure_storage_write_failed',
        message: 'Failed to persist database encryption key.',
      );
    }
    return key;
  }

  Future<bool> persistDbKey(String key) async {
    final primarySaved = await _writeWithOptions(_primaryAndroidOptions, key);
    final legacySaved = await _writeWithOptions(_legacyAndroidOptions, key);
    return primarySaved || legacySaved;
  }

  Future<String> getOrCreateDbKey() async {
    final existing = await readDbKey();
    if (existing != null) {
      return existing;
    }
    return createDbKey();
  }

  Future<void> deleteDbKey() async {
    await _deleteWithOptions(_primaryAndroidOptions);
    await _deleteWithOptions(_legacyAndroidOptions);
  }

  Future<String?> _readWithOptions(AndroidOptions options) async {
    try {
      final value = await _storage.read(
        key: AppConstants.dbEncryptionKey,
        aOptions: options,
      );
      if (value == null || value.isEmpty) {
        return null;
      }
      return value;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> _writeWithOptions(AndroidOptions options, String value) async {
    try {
      await _storage.write(
        key: AppConstants.dbEncryptionKey,
        value: value,
        aOptions: options,
      );
      return true;
    } on PlatformException {
      return false;
    }
  }

  Future<void> _deleteWithOptions(AndroidOptions options) async {
    try {
      await _storage.delete(
        key: AppConstants.dbEncryptionKey,
        aOptions: options,
      );
    } on PlatformException {
      return;
    }
  }
}
