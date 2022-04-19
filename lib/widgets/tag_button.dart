import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagButton extends StatelessWidget {
  String tag;
  Function function;
  bool pressed;
  TagButton({Key? key, required this.tag, required this.function, required this.pressed}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){function();},
      child : Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        color: pressed?null:Colors.deepOrange,
          border: Border.all(
            color: const Color(0xFFF9BE8B),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        child: Text(
          this.tag,
          style: TextStyle(fontFamily: 'Outfit', fontSize: 18,fontWeight: FontWeight.w500),
        ),
        padding: EdgeInsets.all(5),
      ),),
    );
  }
}
