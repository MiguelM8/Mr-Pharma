import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_pharma/util/db-manager.dart';


import '../../../util/api-util.dart';
import '../../../util/util.dart';
import '../../../data/product.dart';
import '../../widgets/common.dart';
import '../../../data/category.dart';

//sin categoria.
final noCat =  PCategory(-1, "Selecciona una categoria");

class ProdMenu extends StatefulWidget{
    final int id;
    final Product? product;
    const ProdMenu(this.id, this.product, {Key? key}) : super(key: key);

    @override
    ProdMenuState createState() => ProdMenuState();
}

class ProdMenuState extends State<ProdMenu>{
    //product data;
    int idProd = -1;
    File? img;
    Product? product;
    PCategory category = noCat;
    ImageProvider? imgProv;
    //controller
    List<PCategory> categories = [noCat];
    List<TextEditingController> texts = List.generate(2, (i) => TextEditingController());

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
                                if(val != null){
                                    category = val;
                                }
                            }), 
                           categories.map((value) =>
                                 DropdownMenuItem(
                                    value: value,
                                    child: Text(value.category)
                            )).toList()
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

  void deleteProd() async{
      if(idProd == -1){
        texts.forEach((element) => element.clear());
        return;
      }
      Util.showLoading(context, 'Eliminando producto...');
      await DBMan.borrarProducto(idProd);
      Util.popDialog(context);
      Util.returnToMenu(context);
  }

    void llenarCampos() async {


      //cargar categorias.
      var cats = await DBMan.obtenerCategorias();
      categories.removeWhere((x) => x.id != -1);
      setState(() =>categories.addAll(cats));

      //poner los campos.
      var prod = product;
      imgProv = const AssetImage('assets/add_img.png');
    
      if(prod == null){
        return;
      }

      var url = prod.url;
      var idCat = prod.catId;
      texts[0].text = prod.name;
      texts[1].text = '${prod.price}';

      if(url != null){
          imgProv = NetworkImage(url);
      }
      //poner la categoria.
      if(idCat != null){
          var cat = categories.firstWhere((element) => element.id == idCat);
          setState(() => category = cat);
      }
    }

    void saveProduct() async {

        double price = double.tryParse(texts[1].text) ?? 0;
        String name = texts[0].text;
        String? imgUrl = product?.url;
 
  
        if(name.isEmpty || price < 0){
            Util.showAlert(context, 'Verifica los datos ingresados por favor');
            return;
        }
        Util.showLoading(context, 'Guardando producto...');
        
        if(img != null){
            imgUrl = await ApiUtil.uploadImage(img);
        }

        //guardar la categoria.
        var idGenerado = await DBMan.insertar_editar_producto(
            idProd, name, imgUrl, price, category.id
        );

        setState(()=>idProd = idGenerado);
        Util.popDialog(context);
        FocusManager.instance.primaryFocus?.unfocus();
  }
}

