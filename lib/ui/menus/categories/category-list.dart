import 'package:flutter/material.dart';
import 'package:mr_pharma/util/db-manager.dart';


import '../../widgets/common.dart';
import '../../../data/category.dart';
import 'menu-category.dart';




class CatList extends StatefulWidget{


  const CatList({Key? key}) : super(key: key);


  @override
  CatListState createState() => CatListState();
}

class CatListState extends State<CatList>{

  List<PCategory> catList = [], filtered = [];
  bool loaded = false;

  Future<void> cargarCategorias() async{
    var cats = await DBMan.obtenerCategorias();
    catList.clear();
    filtered.clear();
    setState(() {
        catList.addAll(cats);
        filtered.addAll(cats);
        catList.sort((a, b)=> a.id.compareTo(b.id));
        filtered.sort((a, b)=> a.id.compareTo(b.id));
        loaded = true;
    });
  }



  @override
  void initState() {
    super.initState();
    cargarCategorias();
  }

  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green, bottom:
        PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: SearchWidget("Buscar categoría", (text) =>
              setState(() => filtered = catList
              .where((e) => matchCat(text, e))
              .toList())

            )
        )
        ),
        body: loaded ? Column(
          children: [
            Expanded(
              child: ListView.builder(itemBuilder: (context, index){
                PCategory prod = filtered[index~/2];
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
                )]
          ))
    );
  }

  ListTile buildListTile(context, leadingIcon, PCategory cat) {



    return ListTile(
        leading: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/category.png'),
            radius: 25
        ),
        title: Text(cat.category),
        subtitle: Text("ID: ${cat.id}"),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
          CatMenu(cat.id, cat))).then((value) => setState(() {
              setState(() => loaded = false);
              cargarCategorias();
         }))
    );
  }


  bool matchCat(String search, PCategory cat){
    return cat.category.toLowerCase().contains(search.toLowerCase());
  }
}