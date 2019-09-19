import 'package:flutter/material.dart';
import 'package:osctest/util/ThemeUtils.dart';

class CommonButton extends StatefulWidget {
  final String text;
  final GestureTapCallback onTap;

  CommonButton({@required this.text,@required this.onTap});
  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {


  Color color = ThemeUtils.currentColorTheme;
  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 17);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        this.widget.onTap();
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Color(0xffcccccc))
        ),
        child: Center(
          child: Text(this.widget.text,style:textStyle),
        ),
      ),
    );
  }
}