import 'dart:convert' show json, base64, ascii;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtManager {
  static JwtManager get instance => _instance;

  FlutterSecureStorage _storage;

  static final JwtManager _instance = JwtManager.privateConstructor();
  JwtManager.privateConstructor() {
    this._storage = FlutterSecureStorage();
  }

  Future<String> getJwt() async {
    var jwt = await _storage.read(key: 'jwt');
    if (jwt == null) {
      throw new Exception();
    }
    return jwt;
  }

  Future<void> setJwt(String jwt) async {
    _storage.write(key: 'jwt', value: jwt);
  }

  Future<void> removeJwt() async {
    _storage.delete(key: 'jwt');
  }

  Future<bool> checkJwtValid() async {
    var jwt = await getJwt();

    List<String> splittedJwt = jwt.split('.');
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
