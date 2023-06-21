import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:server_demo/middleware.dart';
import 'package:server_demo/routes/users_route.dart';

void main() async {
  final app = Alfred();

  app.get('users/currentUser', UsersRoute.currentUser,
      middleware: [Middleware.isAuthenticated]);
  app.post('/users/login', UsersRoute.login);
  app.post('/users/createAccount', UsersRoute.createAccount);
  app.get('/status', (req, res) => 'Server Online');

  final envPort = Platform.environment['PORT'];

  final server = await app.listen(envPort != null ? int.parse(envPort) : 8080);

  print("Listening on ${server.port}");
}
