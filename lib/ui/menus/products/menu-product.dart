import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_pharma/util/db-manager.dart';


import '../../../util/api-util.dart';
import '../../../util/util.dart';
import '../../../data/product.dart';
import '../../widgets/common.dart';


class ProdMenu extends StatefulWidget{
    final int id;
    final Product? product;

    const ProdMenu(this.id, this.product, {Key? key}) : super(key: key);

    @override
    ProdMenuState createState() => ProdMenuState();
}

class ProdMenuState extends State<ProdMenu>{
    //product data.
    int idProd = -1;
    File? img;
    String? category;
    Product? product;
    ImageProvider? imgProv;
    //controller
    List<TextEditingController> texts =
    List.generate(2, (i) => TextEditingController());



    void llenarCampos(){
      var url = product?.url;
      var name = product?.name;
      var pr = product?.price;

      imgProv = const AssetImage('assets/add_img.png');

      if(url != null){
        imgProv = NetworkImage(url);
      }
      if(name != null){
          texts[0].text = name;
      }
      if(pr != null){
          texts[1].text = '$pr';
      }
    }


    @override
    void initState() {
      idProd = widget.id;
      product = widget.product;
      super.initState();
      llenarCampos();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(backgroundColor: Colors.green, actions: [
                IconButton(icon: const Icon(
                    Icons.delete, color: Colors.white
                ), onPressed: deleteProd)
          ]),
          body: SingleChildScrollView(
            reverse: true,
            primary: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 16),
              child: Center(
                child: Wrap(
                      direction: Axis.vertical,
                      spacing: 25,
                      crossAxisAlignment: WrapCrossAlignment.center,

                      children: [
                        CircleAvatar(
                        radius: 60,
                        backgroundImage:  imgProv,
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => ImagePicker()
                                .pickImage(source: ImageSource.gallery)
                                .then((value) => setState(() {
                                    if(value != null){
                                        imgProv = FileImage(
                                            img = File(value.path
                                        ));
                                    }
                                })
                              ),
                          ),
                        )),

                        InputData('ID: $idProd', null, false),
                        InputData("Nombre del producto:", texts[0], true),
                        InputDropdown(category, (val) => setState(() {
                                category = val;
                            }), []
                        /*    xd.map((String value) =>
                                DropdownMenuItem(
                                    value: value,
                                    child: Text(value)
                                )
                            ).toList()*/

                        ),
                        InputNumeric("Precio de venta:", texts[1], false),
                        CustomButton("Guardar", Colors.green, 300, 50, saveProduct)
                      ],
                ),
              ),
            ),
          ),
      );
  }

  void deleteProd(){
      if(idProd == -1){
          for (var element in texts) { element.clear(); }
          Util.showSnack(context, 'Campos limpiados');
          return;
      }
  }


  void saveProduct() async {

        String name = texts[0].text.trim();
        String? imgUrl = product?.url;
        double price = double.tryParse(texts[1].text) ?? 0;

        if(name.isEmpty || price < 0){
            Util.showAlert(context, 'Verifica los datos ingresados por favor');
            return;
        }
        Util.showLoading(context, 'Guardando producto...');
        if(img != null){
            imgUrl = await ApiUtil.uploadImage(img);
        }
        var idGenerado = await DBMan.insertar_editar_producto(
            idProd, name, imgUrl, price
        );
        setState(() { idProd = idGenerado;});
        Util.popDialog(context);
    }
}

