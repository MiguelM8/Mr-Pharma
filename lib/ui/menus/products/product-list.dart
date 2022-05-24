import 'package:flutter/material.dart';
import 'package:mr_pharma/util/db-manager.dart';

import '../../../data/product.dart';
import '../../widgets/common.dart';
import 'menu-product.dart';


class ProdList extends StatefulWidget{

  const ProdList({Key? key}) : super(key: key);

  @override
  ProdListState createState() => ProdListState();
}


class ProdListState extends State<ProdList>{

  List<Product> prodList = [], filtered = [];
  bool loaded = false;

  Future<void> cargarProductos() async{
      var productos = await DBMan.obtenerProductos();
      prodList.clear(); filtered.clear();
      setState(() {
        prodList.addAll(productos);
        filtered.addAll(productos);
        loaded = true;
      });
  }


  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green,
          bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: SearchWidget("Buscar producto", (text) =>
                      setState(() {
                          filtered = prodList
                              .where((element) => matchProd(text, element))
                              .toList();
                      })
                )),
        ),

        body: loaded ? Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Product prod = filtered[index~/2];
                    return index.isOdd ? const Divider() :
                    buildListTile(context, Icons.shopping_cart_rounded, prod);
                  }, itemCount: filtered.length*2),
                )
            ],
        ) : Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(color: Colors.green,)
                ),
              ],
          ),
        )
    );
  }

  ListTile buildListTile(context, leadingIcon, Product product) {

    var category = product.category ?? 'Sin categoria';

    return ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: getImage(product),
            radius: 25
        ),
        title: Text(product.name),
        subtitle: Text(category),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context){
              return ProdMenu(product.id, product);
          })).then((value){
              //retornamos de editar producto.
            setState(() => loaded = false);
            cargarProductos();
          })
    );
  }

  ImageProvider getImage(Product prod){
    String? img = prod.url;
    ImageProvider prov = const AssetImage('assets/add_img.png');
    if(img != null){
        prov = NetworkImage(img);
    }
    return prov;
  }

  bool matchProd(String search, Product prod){
      search = search.toLowerCase();
      return prod.name.toLowerCase().contains(search);
  }
}