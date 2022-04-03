import 'package:postgres/postgres.dart';

class DBMan{
  ///xFREVPbXyt4Lnj$

    static PostgreSQLConnection _getCon(){
      return PostgreSQLConnection(
          "host",
          30000,
          "database",
          username: "username",
          password: "password",
          useSSL: true
      );

    }

    static Future<bool> doLogin(String user, String password) async{
        var nombre = 'Miguel';
        var pass = '123';
        return user == nombre && pass == password;
    }
}






