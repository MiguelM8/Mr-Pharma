import 'package:flutter/material.dart';
import 'package:mr_pharma/ui/widgets/common.dart';



class Home extends StatefulWidget{

  final String user;

  const Home(this.user, {Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(backgroundColor: Colors.orangeAccent, toolbarHeight: 70),
        body: Wrap(
          alignment: WrapAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 60),
              child: Container(
                  height: 70,
                  width: 300,
                  color: Colors.orangeAccent,
                  child: Center(
                    child: Text("Bienvenido @${widget.user}",
                        style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                  )
              ),
            ),
            Center(
              child: Wrap(
                spacing: 150,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton("Inventario", Colors.blueGrey, 350, 65, ()=>{}),
                  CustomButton("Usuarios", Colors.blueGrey, 350, 65, ()=>{}),
                  CustomButton("Proveedores", Colors.blueGrey, 350, 65, ()=>{}),
                  CustomButton("Acerca de", Colors.blueGrey, 350, 65, ()=>{}),
                ],
              ),

            )
          ]
        )
    );
  }


  void redirect(StatefulWidget page) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => page))
        .then((value)=> setState((){
    }));
}


