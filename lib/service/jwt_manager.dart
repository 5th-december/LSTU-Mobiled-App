import 'dart:convert' show json, base64, ascii;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtManager {
  static JwtManager get instance => _instance;

  static const _jwtKeyName = 'jwt';
  static const _refreshKeyName = 'refresh';

  FlutterSecureStorage _storage;

  static final JwtManager _instance = JwtManager._();
  JwtManager._() {
    this._storage = FlutterSecureStorage();
  }

  Future<bool> hasSavedKeyPair() async {
    return await _storage.containsKey(key: _jwtKeyName)
      && await _storage.containsKey(key: _refreshKeyName);
  }

  Future<String> getSavedJwt() async {
    String jwt = await _storage.read(key: 'jwt');
    return jwt;
  }

  Future<String> getSavedRefresh() async {
    String refresh = await _storage.read(key: _refreshKeyName);
    return refresh;
  }

  Future<void> setSavedJwt(String jwt) async {
    await _storage.write(key: _jwtKeyName, value: jwt);
  }

  Future<void> setSavedRefresh(String refresh) async {
    await _storage.write(key: _refreshKeyName, value: refresh);
  }

  Future<void> removeSavedJwt() async {
    await _storage.delete(key: _jwtKeyName);
  }

  Future<void> removeSavedRefresh() async {
    await _storage.delete(key: _refreshKeyName);
  }

  static bool checkJwtValid(String jwtToken) {
    List<String> splittedJwt = jwtToken.split('.');
    if (splittedJwt.length != 3) {
      throw new FormatException();
    }
    String payload = splittedJwt[1];
    var encodedJwt =
        json.decode(ascii.decode(base64.decode(base64.normalize(payload))));
    var exp = (encodedJwt['exp'] ?? 0) * 1000;
    return DateTime.fromMillisecondsSinceEpoch(exp).isAfter(DateTime.now());
  }

}
