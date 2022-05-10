import 'package:flutter/material.dart';



import '../../../data/product.dart';
import '../../../data/supplier.dart';
import '../../widgets/common.dart';
import 'menu-suppliers.dart';


bool productPicker = false;


class SupList extends StatefulWidget{

  final bool picker;

  SupList(this.picker, {Key? key}) : super(key: key){
      productPicker = picker;
  }


  @override
  SupListState createState() => SupListState();
}

class SupListState extends State<SupList>{

  List<Supplier> prodList = [], filtered = [];

  @override
  void initState() {
    /*asignamos los productos cargados
    a la lista filtrada*/
    filtered = prodList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green, bottom:
        PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: SearchWidget("Buscar proveedor", (text){
                    setState(() {
                      //filtrar
                  });
                }
              )
          )
        ),
        body: Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Supplier sup = filtered[index~/2];
                    return index.isOdd ? const Divider() :
                    buildListTile(context, Icons.shopping_cart_rounded, sup);
                  }, itemCount: filtered.length*2),
                )
            ],
        )
    );
  }

  ListTile buildListTile(ctx, leadIcon, Supplier sup) {

    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/add_img.png'),
            radius: 25
        ),
        title: Text(sup.provider),
        subtitle: Text("ID: ${sup.id}"),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => productPicker ?
            Navigator.pop(ctx, sup) :
            Navigator.push(ctx, MaterialPageRoute(
                builder: (context) => SupMenu(sup.id)
              ))
            .then((value) => setState(() {
                  //prodList = PData.getProducts().values.toList();
                  filtered = prodList;
          }))
    );
  }


  bool matchProd(String search, Product prod){
      search = search.toLowerCase();
      return prod.name.toLowerCase().contains(search) ||
            prod.category.toLowerCase().contains(search);
  }
}