import 'package:flutter/material.dart';
import '../../util/db-manager.dart';
import '../../util/util.dart';
import '../widgets/common.dart';
import 'home.dart';

TextEditingController 
  user = TextEditingController(),
  pass = TextEditingController();


class Login extends StatefulWidget{

  LoginState createState() => LoginState();
}

class LoginState extends State<Login>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          primary: false,
          reverse: true,
          child: Wrap(
              alignment: WrapAlignment.center,
              //direction: Axis.vertical,
              runSpacing: 15,
              children: [
                const Center(
                  child: CircleAvatar(
                      radius: 75.0,
                      //backgroundImage: AssetImage('assets/logo.png'),
                      backgroundImage: NetworkImage("https://i.imgur.com/2j9TuAu.png"),
                  ),
                ),
                const SizedBox(width: 300, height: 10),
                const Text("Iniciar Sesion", style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                )),
                InputData("Ingresa tu usuario", user, false),
                InputData("Ingresa tu clave", pass, true),
                CustomButton("Acceder", Colors.orangeAccent, 300, 50, doLogin),
              ],
          ),
        ),
      )
    );
  }

  //funcs

  void doLogin(){
    FocusManager.instance.primaryFocus?.unfocus();
    Util.showLoading(context, "Iniciando sesion...");
    DBMan.doLogin(user.text.trim(), pass.text.trim()).then((value) {
      Util.popDialog(context);
      if(!value){
        Util.showSnack(context, "Usuario o clave incorrecta");
         return;
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
          (context) => Home(user.text)), (route) => false);
    });
  }
}



class InputData extends StatelessWidget{

  final TextEditingController controller;
  final String hint;
  final bool pass;

  InputData(this.hint, this.controller, this.pass);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        width: 350,
        child:  TextField(
          obscureText: pass,
          controller: controller,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey.shade400),
            hintText: hint,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          )
        )
    );
  }
}








