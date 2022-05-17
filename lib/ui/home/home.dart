import 'package:flutter/material.dart';


import 'login.dart';
//menu
import '../menus/products/menu-product.dart';
import '../menus/products/product-list.dart';

//categorias
import '../menus/categories/menu-category.dart';
import '../menus/categories/category-list.dart';


//proveedores
import '../menus/suppliers/menu-suppliers.dart';
import '../menus/suppliers/supplier-list.dart';


import '../../util/util.dart';


class Home extends StatefulWidget{

  final String user;
  const Home(this.user, {Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.green,
          toolbarHeight: 70,
          actions: [
            IconButton(icon: const Icon(Icons.logout),
                onPressed: () => Util.redirect(context, Login())),
          ]),


        body: SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.vertical,
          child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 50),
                      child: Container(
                          height: 75,
                          width: 325,
                          color: Colors.green,
                          child: Center(
                            child: Text(
                                "Bienvenido @${widget.user.toUpperCase()}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                )),
                          )
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 25,
                      runSpacing: 30,
                      children: [
                        TileMain("Crear Producto", Icons.add_box,
                            () => Util.redirect(context, const ProdMenu(-1, null))),

                        TileMain("Crear Proveedores", Icons.group_add,
                                () => Util.redirect(context, const SupMenu(-1))),

                        TileMain("Crear categorias", Icons.add_to_photos,
                                () => Util.redirect(context, const CatMenu(-1))),

                        TileMain("Ver inventario", Icons.wysiwyg,
                                ()=>Util.redirect(context, const ProdList())),

                        TileMain("Ver categorias", Icons.category,
                                ()=> Util.redirect(context, const CatList())),

                        TileMain("Ver proveedores", Icons.group,
                                () => Util.redirect(context, const SupList())),


                        TileMain("Acerca de", Icons.help,
                                ()=> Util.showAlert(context,

                                    "INTEGRANTES:\n"
                                    "\nManuel Miguel Miguel (4090-19-9063)"
                                    "\nRaúl Botzoc Mérida (4090-19-7994)"
                                    "\n\nCURSO:\n"
                                    "\nProgramación III"
                                )),
                      ]),
                )
            ]),
        )
    );
  }

}

//widgets
class TileMain extends StatelessWidget{

  final String text;
  final IconData icon;
  final VoidCallback action;

  const TileMain(this.text, this.icon, this.action, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Ink(
        height: 160,
        width: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Icon(icon,
                color: Colors.green, size: 50),
            Text(text, style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold
            )),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: const Offset(0, 3)
              )
            ]
        ),
      ),
    );
  }
}
