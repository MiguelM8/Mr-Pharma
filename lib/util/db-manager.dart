import 'package:mr_pharma/data/product.dart';
import 'package:postgres/postgres.dart';

class DBMan{
  ///xFREVPbXyt4Lnj$

  //parte de codigo en la cual hicimos la conexion con BD Postgre
    static PostgreSQLConnection _getCon(){
      return PostgreSQLConnection(
          "ec2-52-21-136-176.compute-1.amazonaws.com",
          5432,
          "d3s6se88ethanu",
          username: "mfwosllolivvyz",
          password: "d838c744d7ea18ad6e0884e571ecf0f385c595bca12e9291f3699991525b4020",
          useSSL: true
      );
    }

    //metodo para verificar si existe usaurio
    static Future<bool> doLogin(String user, String password) async{
        var con = _getCon();
        bool puede = false;
        //en caso existe el usaurio se accede a la aplicacion
        try{
          await con.open();
          var response = await con.query('select * from llamar_login(@usuario, @pass)', substitutionValues: {
            "usuario": user,
            "pass": password
          });
          puede = (response[0][0] != null);//si es diferente de vacio entonces se cierra
        }catch(err){
          print(err);
        }finally{
          if(!con.isClosed){
            await con.close();
          }
        }
        return puede;
    }

    static Future<int> insertar_editar_producto(int id, String name, String? image, double price) async{
        var con=_getCon();
        await con.open();


        var res = await con.query('call insertar_producto(@id, @nm, @img, @prc, @sal)', substitutionValues: {
            "id": id,
            "nm": name,
            "img": image,
            "prc": price,
            "sal": 0,
        });
        await con.close();

        var salida = res[0][0];

        return salida;
    }

    static Future<List<Product>> obtenerProductos() async{
        var con=_getCon();
        List<Product> lista = [];

        await con.open();
        var response = await con.query('select * from lista_productos');

        for (var element in response) {
            var id = element[0];
            var prodName = element[1];
            var cat = element[5];
            var imgUrl = element[2];
            var price = element[3];
            lista.add(Product(id, prodName, cat, imgUrl, double.parse(price)));
        }

        await con.close();

        return lista;
    }
}






