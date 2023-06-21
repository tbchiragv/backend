import 'dart:developer';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_demo/server.dart';
import 'package:server_demo/services/database.dart';

main() async {
  final db = await Db.create(
      'mongodb+srv://chexvegad:test123@cluster0.ixlfoq4.mongodb.net/demoDB?retryWrites=true&w=majority');

  GetIt.instance.registerSingleton(DatabaseService(db));
  GetIt.instance.registerSingleton(Service());

  await database.open();

  final server = Server();

  final envPort = Platform.environment['PORT'];
  await server.start(port: int.tryParse(envPort ?? '3000') ?? 3000);
}
