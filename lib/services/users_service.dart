import 'package:server_demo/classes/user.dart';

class UsersService {
  final List _users = [
    User(email: 'test@gmail.com', firstName: 'test', lastName: 'last Name')
      ..setPassword('password'),
    User(email: 'test1@gmail.com', firstName: 'test1', lastName: 'last Name 1')
      ..setPassword('password1'),
    User(email: 'test2@gmail.com', firstName: 'test2', lastName: 'last Name 2')
      ..setPassword('password2')
  ];

  Future<User?> findUserByEmail({required email}) async {
    return await _users.firstWhere((user) => user.email == email,
        orElse: () => null);
  }
}
