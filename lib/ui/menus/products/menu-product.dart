import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../../util/api-util.dart';
import '../../../util/util.dart';
import '../../../data/product.dart';
import '../../widgets/common.dart';


class ProdMenu extends StatefulWidget{
    final int prod;
    const ProdMenu(this.prod, {Key? key}) : super(key: key);

    @override
    ProdMenuState createState() => ProdMenuState();
}

class ProdMenuState extends State<ProdMenu>{

  int idProd = -1;
  File? img;
  Product? product;
  ImageProvider imgProv = const AssetImage('assets/add_img.png');
  String? category ;


  List<String> xd = List.generate(4, (i) => "xd: $i");
  List<TextEditingController> texts = List.generate(2,
          (i) => TextEditingController()
  );

  @override
  void initState() {
    idProd = widget.prod;
    product = null;
    img = null;
    //imgProv = product.url == null ?  img == null ? imgProv = const AssetImage('assets/add_img.png') : imgProv = FileImage(img) : imgProv = NetworkImage(product.url);
    if(product != null){
      texts[0].text = '${product?.name}';
      texts[1].text = '${product?.price}';
    }
    super.initState();
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
                        //fix: https://github.com/flutter/flutter/issues/42901#issuecomment-708050484
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
                                            img = File(value.path)
                                        );
                                    }
                                })
                              ),
                          ),
                        )),

                        InputData('ID: $idProd', null, false),
                        InputData("Nombre del producto:", texts[0], true),
                        InputDropdown(category, (val) => setState(() {
                                category = val;
                            }),
                            xd.map((String value) =>
                                DropdownMenuItem(
                                    value: value,
                                    child: Text(value)
                                )
                            ).toList()
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
      Util.showLoading(context, 'Eliminando producto...');
      Util.popDialog(context);
  }


  void saveProduct() async {

        String name = texts[0].text.trim();
        String cat = texts[1].text.trim(); //get numeric categories.
        String? imgUrl = product?.url;
        double price = double.tryParse(texts[2].text) ?? 0;

        if(name.isEmpty || cat.isEmpty || price < 0){
            Util.showAlert(context, 'Verifica los datos ingresados por favor');
            return;
        }
        Util.showLoading(context, 'Guardando producto...');
        imgUrl ??= await ApiUtil.uploadImage(img);
        Util.popDialog(context);
    }
}

