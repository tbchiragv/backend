import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_demo/server.dart';
import 'package:server_demo/services/database.dart';
import 'package:server_demo/services/services.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  Server? server;
  int port = 6566;

  setUp(() async {
    final db = await Db.create(
        'mongodb+srv://chexvegad:test123@cluster0.ixlfoq4.mongodb.net/testDB?retryWrites=true&w=majority');
    GetIt.instance.registerSingleton(DatabaseService(db));
    GetIt.instance.registerSingleton(Services());

    await database.open();

    server = Server();

    await server?.start(port: port);
  });

  tearDown(() async {
    database.close();
    GetIt.instance.unregister<DatabaseService>();
    GetIt.instance.unregister<Services>();
    await server?.app.close(force: true);
    if (server != null) {
      await server!.app.close();
    }
  });

  test('it should login a user', () async {
    final response = await http.post(
        Uri.parse('http://localhost:$port/users/login'),
        body: {'email': 'test@gmail.com', 'password': 'password'});
    final data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    expect(data['token'] != null, true);
  });

  (
    'it should get current user',
    () async {
      final loginResponse = await http.post(
          Uri.parse('http://localhost:$port/users/login'),
          body: {'email': 'test@gmail.com', 'password': 'password'});
      final loginUser = jsonDecode(loginResponse.body);
      final token = loginUser['token'];

      final response = await http.get(
          Uri.parse('http://localhost:$port/users/currentUser'),
          headers: {'Authorization': 'Bearer $token'});
      print(response.body);
      expect(response.statusCode, 200);
    }
  );

  test('it should create an account', () async {
    final createResponse = await http
        .post(Uri.parse('http://localhost:$port/users/createAccount'), body: {
      "firstName": "Test 3",
      "lastName": "test 3 surname",
      "email": "test3@email.com",
      "password": "test3pass"
    });

    print(createResponse.body);
    expect(createResponse.statusCode, 200);
  });
}
