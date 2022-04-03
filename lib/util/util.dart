import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class Util {

  static void showSnack(BuildContext ctx, String txt) => ScaffoldMessenger.of(ctx)
      .showSnackBar(SnackBar(
      content: Text(txt),
      duration: const Duration(milliseconds: 1000)
  ));


  static void popDialog(BuildContext cx) => Navigator.of(cx, rootNavigator: true).pop();


  static void showLoading(BuildContext ctx, String msg){
    showDialog(barrierDismissible: false,
      context: ctx,
      builder:(BuildContext context){
        return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Text(msg)
              ],
            )
        );
      },
    );
  }


  static Future<void> showAlert(BuildContext ctx, String msg) async{
    await showDialog(
        context:  ctx,
        builder: (context){
          return AlertDialog(
            title: Text('Alerta'),
            content: Text(msg),
            actions: [
              TextButton(onPressed: () => popDialog(ctx), child: Text('Ok'))
            ],
          );
        });
  }

  static Future<bool> showNoYesDialog(BuildContext ctx, String msg) async{
    bool val = await showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmacion'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
              child: Text('Si'),
            ),
          ],
        );
      },
    );
    return val;
  }

  static Future<int?> showInputDialog(BuildContext ctx) async{
    String data = await showDialog(context: ctx, builder: (context){
        TextEditingController controller = TextEditingController();
        return AlertDialog(
            title: Text('Ingrese los datos'),
            content: TextFormField(
              autofocus: true,
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context, rootNavigator: true)
                    .pop(''),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context, rootNavigator: true)
                    .pop(controller.text),
                child: Text('Confirmar'),
              ),
            ],
        );
    });
    return int.tryParse(data);
  }
}






