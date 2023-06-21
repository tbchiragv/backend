import 'package:alfred/alfred.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:server_demo/services/services.dart';

import '../classes/user.dart';

class UsersRoute {
  static currentUser(HttpRequest request, HttpResponse response) async {
    final userToken = request.store.get('token') as JWT?;
    if (userToken != null) {
      final data = userToken.getClaim('data') as Map;
      final userEmail = data['email'];
      final foundUser =
          await services.usersService.findUserByEmail(email: userEmail);
      if (foundUser != null) {
        return foundUser;
      } else {
        throw AlfredException(401, {'message': 'user not found'});
      }
    }
  }

  static login(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final user =
        await services.usersService.findUserByEmail(email: body['email']);

    if (user == null || user.password == null) {
      throw AlfredException(401, {'message': 'Invalid user'});
    }

    try {
      // validate username & password
      final isCorrect = DBCrypt().checkpw(body['password'], user.password!);

      if (isCorrect == false) {
        throw AlfredException(401, {'message': 'Invalid password'});
      }

      //generate a jwt
      var token = JWTBuilder()
        ..issuer = 'https://api.test.com'
        ..expiresAt = DateTime.now().add(Duration(hours: 1))
        ..setClaim('data', {'email': user.email})
        ..getToken();

      var signedToken = token.getSignedToken(services.jwtSigner);

      return {'token': signedToken.toString()};
    } catch (e) {
      print(e.toString());
      throw AlfredException(500, {'message': 'Unknown error occurred'});
    }
  }

  static createAccount(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final newUser = User.fromJson(body)..setPassword(body['password']);

    if (await checkForAlreadyExistUser(newUser)) {
      await newUser.save();
      return newUser;
    } else {
      throw AlfredException(401, 'user already exist');
    }
  }

  static Future<bool> checkForAlreadyExistUser(User user) async {
    final isUserExist = await user.findOne({'email': user.email});
    return (isUserExist == null);
  }
}
