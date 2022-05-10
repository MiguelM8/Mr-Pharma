import 'package:flutter/material.dart';

import '../../../util/util.dart';
import '../../../data/product.dart';
import '../../widgets/common.dart';
import 'menu-product.dart';


bool productPicker = false;


class ProdList extends StatefulWidget{

  final bool picker;

  ProdList(this.picker, {Key? key}) : super(key: key){
      productPicker = picker;
  }

  @override
  ProdListState createState() => ProdListState();
}


class ProdListState extends State<ProdList>{

  List<Product> prodList = [], filtered = [];

  @override
  void initState() {
    for (var i=0; i < 1000; i ++){
        prodList.add(Product(i, "test $i", "test", "", 100));
    }
    filtered = prodList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green,
          bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: SearchWidget("Buscar proveedor", (text) =>
                      setState(() {
                          filtered = prodList
                              .where((element) => matchProd(text, element))
                              .toList();
                      })
                )),
        ),

        body: Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Product prod = filtered[index~/2];
                    return index.isOdd ? const Divider() :
                    buildListTile(context, Icons.shopping_cart_rounded, prod);
                  }, itemCount: filtered.length*2),
                )
            ],
        )
    );
  }

  ListTile buildListTile(context, leadingIcon, Product product) {

    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            //backgroundImage: img == null ? const NetworkImage('') : NetworkImage(img),
            backgroundImage: AssetImage('assets/add_img.png'),
            radius: 25
        ),
        title: Text(product.name),
        subtitle: const Text("Existencias: "),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => productPicker ? Navigator.pop(context, product) :  Navigator.push(context,
             MaterialPageRoute(builder: (context) =>
              ProdMenu(product.id))).then((value) => setState(() {
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