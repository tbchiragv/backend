import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:get_it/get_it.dart';
import 'package:server_demo/services/users_service.dart';

Services get services => GetIt.instance.get<Services>();
const _JWTSECRET = 'QDSFQ%\$WBTVQWEVTQ\$ TvqweRQWRQWEFQWCFQW RQ';
const MONGODB_URL =
    'mongodb+srv://chexvegad:test123@cluster0.ixlfoq4.mongodb.net/demoDB?retryWrites=true&w=majority';

class Services {
  UsersService usersService = UsersService();
  final jwtSigner = JWTHmacSha256Signer(_JWTSECRET);
}
