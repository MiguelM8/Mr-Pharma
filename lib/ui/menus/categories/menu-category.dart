import 'package:flutter/material.dart';
import 'package:mr_pharma/data/category.dart';
import 'package:mr_pharma/util/db-manager.dart';

import '../../../ui/widgets/common.dart';
import '../../../util/util.dart';


class CatMenu extends StatefulWidget{
  final int catId;
  final PCategory? category;
  const CatMenu(this.catId, this.category, {Key? key}) : super(key: key);

  @override
  CatMenuState createState() => CatMenuState();
}

class CatMenuState extends State<CatMenu>{
  int catId = -1;
  List<TextEditingController> texts = List.generate(2, (i) => TextEditingController());

  @override
  void initState() {
    catId = widget.catId;
    super.initState();
    llenarCampos();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green, actions: [
        IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: deleteCat
        )
      ]),
      body: SingleChildScrollView(
        reverse: true,
        primary: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 25,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                InputData('ID: $catId', texts[0], false),
                InputData("Nombre de la categoria:", texts[1], true),
                CustomButton("Guardar", Colors.green, 300, 50, saveCat)
              ],
            ),
          ),
        ),
      ),
    );
  }


  void deleteCat() async{
    if(catId == -1){
      cleanText();
      Util.showSnack(context, 'Campos limpiados');
      return;
    }
    Util.showLoading(context, 'Eliminando producto...');
    await DBMan.borrarCategoria(catId);
    Util.popDialog(context);
    Util.returnToMenu(context);
  }


  void saveCat() async {
    String nombre = texts[1].text;
    if(nombre.isEmpty){
        Util.showAlert(context, "Porfavor verifica los campos");
        return;
    }
    Util.showLoading(context, 'Guardando producto...');
    var idResp = await DBMan.insertar_actualizar_categoria(catId, nombre);
    setState(()=> catId = idResp);
    Util.popDialog(context);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void llenarCampos(){
     var cat = widget.category;
     if(cat != null){
        texts[1].text = cat.category;
     }
  }


  void cleanText(){
      for(var element in texts){
          element.clear();
      }
  }
}
