import 'package:alfred/alfred.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:server_demo/services/services.dart';

class Middleware {
  static isAuthenticated(HttpRequest request, HttpResponse response) {
    final authHeader = request.headers.value('Authorization');
    if (authHeader != null) {
      final token = authHeader.replaceAll('Bearer ', '');
      if (token.isNotEmpty) {
        final parsedToken = JWT.parse(token);
        final isValid = parsedToken.verify(services.jwtSigner);
        if (isValid) {
          request.store.set('token', parsedToken);
        } else {
          throw AlfredException(401, {'message': 'invalid token provided'});
        }
      } else {
        throw AlfredException(401, {'message': 'no token provided'});
      }
    } else {
      throw AlfredException(401, {'message': 'no auth header provided'});
    }
  }
}
