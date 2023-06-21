import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:server_demo/server.dart';
import 'package:server_demo/services/database.dart';
import 'package:server_demo/services/services.dart';

main() async {
  final db = await Db.create(MONGODB_URL);

  GetIt.instance.registerSingleton(DatabaseService(db));
  GetIt.instance.registerSingleton(Services());

  await database.open();

  final server = Server();

  final envPort = Platform.environment['PORT'];
  await server.start(port: int.tryParse(envPort ?? '3000') ?? 3000);
}
