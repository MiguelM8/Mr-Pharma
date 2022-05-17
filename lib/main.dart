import 'package:flutter/material.dart';
import 'package:mr_pharma/config-reader.dart';
import 'package:mr_pharma/ui/home/login.dart';
import 'package:mr_pharma/util/db-manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConfigReader.initialize().whenComplete((){
      runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Login()
        ));
  });
}

