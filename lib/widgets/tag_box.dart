import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagBox extends StatelessWidget {
  String tag;
  double size = 12;
  TagBox({Key? key, required this.tag, required this.size}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFF9BE8B),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        child: Text(
          this.tag,
          style: TextStyle(fontFamily: 'Outfit', fontSize: this.size,fontWeight: FontWeight.w500),
        ),
        padding: EdgeInsets.all(5),
      ),
    );
  }
}
