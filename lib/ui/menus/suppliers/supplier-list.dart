import 'package:flutter/material.dart';
import 'package:mr_pharma/util/db-manager.dart';



import '../../../data/product.dart';
import '../../../data/supplier.dart';
import '../../widgets/common.dart';
import 'menu-suppliers.dart';


class SupList extends StatefulWidget{
  const SupList({Key? key}) : super(key: key);
  @override
  SupListState createState() => SupListState();
}

class SupListState extends State<SupList>{

  List<Supplier> provList = [], filtered = [];
  bool loaded = false;

  Future<void> cargarProveedores() async{
    var prov = await DBMan.obtenerSuppliers();
    provList.clear(); 
    filtered.clear();
    
    setState(() {
        provList.addAll(prov);
        filtered.addAll(prov);
        provList.sort((a, b)=> a.id.compareTo(b.id));
        filtered.sort((a, b)=> a.id.compareTo(b.id));
        loaded = true;
    });
  }


  @override
  void initState() {
    super.initState();
    cargarProveedores();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green, bottom:
        PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: SearchWidget("Buscar proveedor", (text){
                    setState(() {
                      filtered = provList
                      .where((prov) => matchProd(text, prov)).toList();
                  });
                }
              )
          )
        ),
        body: loaded ? Column(
            children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index){
                    Supplier sup = filtered[index~/2];
                    return index.isOdd ? const Divider() :
                    buildListTile(context, Icons.shopping_cart_rounded, sup);
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
                )]
          ))
    );
  }

  ListTile buildListTile(ctx, leadIcon, Supplier sup) {
    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/supplier.png'),
            radius: 25
        ),
        title: Text(sup.provider),
        subtitle: Text("ID: ${sup.id}"),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(ctx, MaterialPageRoute(
                builder: (context) => SupMenu(sup.id, sup)
              ))
            .then((value) => setState(() {
                  setState(()=>loaded = false);
                  cargarProveedores();
          }))
    );
  }


  bool matchProd(String search, Supplier prod){
      search = search.toLowerCase();
      return prod.provider.toLowerCase().contains(search);
  }
}