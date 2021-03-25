import 'dart:convert' show json, base64, ascii;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtManager {
  static JwtManager get instance => _instance;

  FlutterSecureStorage _storage;

  static final JwtManager _instance = JwtManager._();
  JwtManager._() {
    this._storage = FlutterSecureStorage();
  }

  Future<bool> hasSavedJwt() async {
    return await _storage.containsKey(key: 'jwt');
  }

  Future<String> getSavedJwt() async {
    String jwt = await _storage.read(key: 'jwt');
    return jwt;
  }

  Future<void> setSavedJwt(String jwt) async {
    await _storage.write(key: 'jwt', value: jwt);
  }

  Future<void> removeSavedJwt() async {
    await _storage.delete(key: 'jwt');
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
