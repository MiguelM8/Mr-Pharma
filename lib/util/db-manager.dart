import 'package:mr_pharma/data/category.dart';
import 'package:mr_pharma/data/product.dart';
import 'package:mr_pharma/data/supplier.dart';
import 'package:postgres/postgres.dart';

class DBMan{
  ///xFREVPbXyt4Lnj$

  DBMan._();

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

    static Future<int> insertar_editar_producto(int id, String name, String? image, double price, int catid) async{
        var con=_getCon();
        await con.open();

        //llamado a procedimiento.
        var res = await con.query('call insertar_producto(@id, @nm, @img, @prc, @cid, @sal)', substitutionValues: {
            "id": id,
            "nm": name,
            "img": image,
            "prc": price,
            "cid": catid,
            "sal": 0,
        });
        await con.close();

        var salida = res[0][0];

        return salida;
    }

    static Future<int> insertar_editar_proveedor(int idprov, String proveedor, 
        String nit, String repNombre, String rep_apellidos, 
        String telefono, String correo) async{

        var con = _getCon();
        await con.open();

        var res = await con.query('call insertar_actualizar_proveedor(@id, @prov, @nit, @rep1, @rep2, @tel, @email, @sal)', 
        substitutionValues: {
            "id": idprov,
            "prov": proveedor,
            "nit": nit,
            "rep1": repNombre,
            "rep2": rep_apellidos,
            "tel": telefono,
            "email": correo,
            "sal": 0
        });
        await con.close();
        var salida = res[0][0];
        return salida;
    }

  static Future<int> insertar_actualizar_categoria(int id, String nombre) async{
      var con = _getCon();
      await con.open();

      var reponse = await con.query('call insertar_categoria(@cid, @cat, @sal)', 
      substitutionValues: {
          "cid": id,
          "cat": nombre,
          "sal": 0,
      });
    await con.close();
    var salida = reponse[0][0];
    return salida;
  }




  static Future<List<Product>> obtenerProductos() async{
        var con=_getCon();
        List<Product> lista = [];

        await con.open();
        var response = await con.query('select * from lista_productos');
        //lamado a la vista.
        for (var element in response) {
            var id = element[0];
            var prodName = element[1];
            var imgUrl = element[2];
            var price = element[3];
            var catid = element[4];
            var cat = element[5];
            lista.add(Product(id, prodName, imgUrl, double.parse(price), catid, cat));
        }

        await con.close();

        return lista;
    }

    static Future<List<Supplier>> obtenerSuppliers() async{

        List<Supplier> lista = [];
        var con=_getCon();
        await con.open();

        var response = await con.query('select * from proveedores');
        //lamado a la vista.
        for (var element in response) {
            var id = element[0];
            var sup = element[1];
            var nit = element[2];
            var name = element[3];
            var last = element[4];
            var phone = element[5];
            var email = element[6];
            lista.add(Supplier(id, sup, nit, name, last, phone, email));
        }

        await con.close();
        return lista;
    }


    static Future<List<PCategory>> obtenerCategorias() async{
    
      List<PCategory> cats = [];
      var con=_getCon();
      await con.open();
      var response = await con.query('select * from tb_category');
      for(var element in response){
        cats.add(PCategory(element[0], element[1]));
      }
      await con.close();
      return cats;
    }


}






