import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchWidget extends StatelessWidget{

  final String hint;
  final ValueChanged<String> onChanged;

  SearchWidget(this.hint, this.onChanged);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.black54);
    return  Container(
        height: 45,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: style.color),
              hintText: hint,
              hintStyle: style,
              border: InputBorder.none,
            ),
            style: style,
            onChanged: onChanged
        ),
      );
  }
}




class CustomButton extends StatelessWidget{

  final String text;
  final Color color;
  final double width, height;
  final VoidCallback action;

  CustomButton(this.text, this.color, this.width, this.height, this.action);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          child: Text(text, style: const TextStyle(fontSize: 14)),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: color)
                  )
              )
          ),
          onPressed: action
      ),
    );
  }
}


class InputData extends StatelessWidget{

  final TextEditingController controller;
  final String hint;
  final bool enabled;

  InputData(this.hint, this.controller, this.enabled);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 350,
        padding: const EdgeInsets.only(left: 10),
       // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
        ),

        child:  Center(
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
                labelText: hint,
                border: InputBorder.none,
                filled: false,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                fillColor: Colors.white),
          ),
        )
    );
  }
}


class InputNumeric extends StatelessWidget{

  final TextEditingController controller;
  final String hint;
  final bool integers;


  InputNumeric(this.hint, this.controller, this.integers);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 350,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),

        child:  TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [integers ? FilteringTextInputFormatter.digitsOnly :
              FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.)?(\d+)?$'))],

          decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              labelText: hint,
              fillColor: Colors.white
          ),
        )
    );
  }
}

