import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fin_sage/core/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class SecureKeyService {
  SecureKeyService(this._storage);

  final FlutterSecureStorage _storage;

  static const AndroidOptions _primaryAndroidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'finsage_secure_storage',
    preferencesKeyPrefix: 'finsage_',
  );

  static const AndroidOptions _legacyAndroidOptions = AndroidOptions();
  static const String _vaultFileName = '.finsage_db_key';

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

    final vault = await _readVaultKey();
    if (vault != null && !candidates.contains(vault)) {
      candidates.add(vault);
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
    final vaultSaved = await _writeVaultKey(key);
    return primarySaved || legacySaved || vaultSaved;
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
    await _deleteVaultKey();
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

  Future<String?> _readVaultKey() async {
    try {
      final file = await _vaultFile();
      if (file == null || !await file.exists()) {
        return null;
      }
      final value = (await file.readAsString()).trim();
      if (value.isEmpty) {
        return null;
      }
      return value;
    } on Object {
      return null;
    }
  }

  Future<bool> _writeVaultKey(String value) async {
    try {
      final file = await _vaultFile();
      if (file == null) {
        return false;
      }
      await file.parent.create(recursive: true);
      final tmp = File('${file.path}.tmp');
      await tmp.writeAsString(value, flush: true);
      if (await file.exists()) {
        await file.delete();
      }
      await tmp.rename(file.path);
      return true;
    } on Object {
      return false;
    }
  }

  Future<void> _deleteVaultKey() async {
    try {
      final file = await _vaultFile();
      if (file != null && await file.exists()) {
        await file.delete();
      }
    } on Object {
      return;
    }
  }

  Future<File?> _vaultFile() async {
    try {
      final directory = await getApplicationSupportDirectory();
      return File('${directory.path}/$_vaultFileName');
    } on Object {
      return null;
    }
  }
}
