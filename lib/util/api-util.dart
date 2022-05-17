import 'dart:io';
//http
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config-reader.dart';


class ApiUtil {

    static Future<String?> uploadImage(File? img) async{
        if(img == null){
            return null;
        }
        var url = Uri.parse('https://api.imgur.com/3/image/');
        var image = base64.encode(await img.readAsBytes());
        var response = await http.post(url,
            headers: {
              'Authorization': 'Client-ID ${ConfigReader.getImgurApiKey()}'
            }, body: {
                'image': image
            }
        );

        var json = response.statusCode == 200 ?
                    jsonDecode(response.body) as Map<String, dynamic> : null;


        return json?['data']?['link'];
    }
}