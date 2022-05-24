import 'package:flutter/material.dart';
import 'package:mr_pharma/util/db-manager.dart';

import '../../../data/supplier.dart';
import '../../../util/util.dart';
import '../../widgets/common.dart';




class SupMenu extends StatefulWidget{
  final int provId;
  final Supplier? supplier;

  const SupMenu(this.provId, this.supplier, {Key? key}) : super(key: key);

  @override
  SupMenuState createState() => SupMenuState();
}

class SupMenuState extends State<SupMenu>{
  int idProv = -1;
  List<TextEditingController> texts = List.generate(6, (i) => TextEditingController());

  @override
  void initState() {
    idProv = widget.provId;
    super.initState();
    llenarCampos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green, actions: [
        IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: deleteSupplier
        )
      ]),
      body: SingleChildScrollView(
        reverse: true,
        primary: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 25,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const SizedBox(width: 300, height: 10),
                InputData('ID: $idProv', null, false),
                InputData("Nombre del proveedor:", texts[0], true),
                InputData("NIT del proveedor:", texts[1], true),
                InputData("Nombre del representante:", texts[2], true),
                InputData("Apellidos del representante:", texts[3], true),
                InputData("Teléfono:", texts[4], true),
                InputData("Correo electrónico:", texts[5], true),
                CustomButton("Guardar", Colors.green, 300, 50, saveSupplier)
              ],
            ),
          ),
        ),
      ),
    );
  }


  void deleteSupplier(){
    if(idProv == -1){
      cleanText();
      Util.showSnack(context, 'Campos limpiados');
      return;
    }
    Util.showLoading(context, 'Eliminando producto...');
  }


  void saveSupplier() async {

    Util.showLoading(context, 'Guardando producto...');
    Util.popDialog(context);
    
    if(!validFields()){
      Util.showAlert(context, 'Verifica los datos ingresados por favor');
      return;
    }
    Util.showLoading(context, "Guardando proveedor");
    var idGen = await DBMan.insertar_editar_proveedor(
      idProv, texts[0].text, texts[1].text, 
      texts[2].text, texts[3].text, 
      texts[4].text,  texts[5].text
    );
    setState(() =>idProv = idGen);
    Util.popDialog(context);
    FocusManager.instance.primaryFocus?.unfocus();
  }
  

  void llenarCampos(){
    var supp = widget.supplier;
    if(supp != null){
        texts[0].text = supp.provider;
        texts[1].text = supp.nit;
        texts[2].text = supp.name;
        texts[3].text = supp.lastname;
        texts[4].text = supp.phone;
        texts[5].text = supp.email;
    }
  }

  bool validFields(){
    bool valid = true;
    for(int i = 1; i <=5; i++){
      if(texts[i].text.isEmpty){
        valid = false;
        break;
      }
    }
    return true;
  }


  void cleanText(){
      for(var element in texts){element.clear();}
  }
}
