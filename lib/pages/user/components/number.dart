import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/tools/general/padding/page-padding.dart';

class Numpad extends StatefulWidget {
  final int? length;
  final double height;
  final Function onChange;
  final List<Widget> extraData;
  final bool completed;
  final String buttonText;
  final String? initalValue;
  Numpad({Key? key, this.length, required this.onChange, required this.extraData, this.completed = false, required this.buttonText, this.initalValue, required this.height}) : super(key: key);

  @override
  _NumpadState createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  String number = '';

  setValue(String val){
    if(number.length < widget.length!)
      setState(() {
        number += val;
        widget.onChange(number);
      });
  }

  backspace(String text){
    if(text.length > 0){
      setState(() {
        number = text.split('').sublist(0,text.length-1).join('');
        widget.onChange(number);
      });
    }
  }
  @override
  void initState() {
    number = widget.initalValue ?? '';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Flexible(
      flex: 1,
      child: Container(
        // height: widget.height,
        // color: Colors.black12,
        padding: PagePadding.leftRight16(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // 40
            // SizedBox(height: 40),
            Preview(text: number, length: widget.length, extraData: widget.extraData,),
            // Text((widget.height).toString()),
            // Text(((size.height * 5 / 100 - 10) / 2).toString()),
            // SizedBox(height: (size.height * 5 / 100 - 10) / 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumpadButton(
                  height: widget.height,
                  text: '1',
                  onPressed: ()=>setValue('1'),
                ),
                NumpadButton(
                  height: widget.height,
                  text: '2',
                  onPressed: ()=>setValue('2'),
                ),
                NumpadButton(
                  height: widget.height,
                  text: '3',
                  onPressed: ()=>setValue('3'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumpadButton(
                  height: widget.height,
                  text: '4',
                  onPressed: ()=>setValue('4'),
                ),
                NumpadButton(
                  height: widget.height,
                  text: '5',
                  onPressed: ()=>setValue('5'),
                ),
                NumpadButton(
                  height: widget.height,
                  text: '6',
                  onPressed: ()=>setValue('6'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumpadButton(
                  height: widget.height,
                  text: '7',
                  onPressed: ()=>setValue('7'),
                ),
                NumpadButton(
                  height: widget.height,
                  text: '8',
                  onPressed: ()=>setValue('8'),
                ),
                NumpadButton(
                  height: widget.height,
                  text: '9',
                  onPressed: ()=>setValue('9'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NumpadButton(
                  height: widget.height,
                    text: '',
                    haveBorder: false,
                  onPressed: null,
                ),
                NumpadButton(
                  height: widget.height,
                  text: '0',
                  onPressed: ()=>setValue('0'),
                ),
                NumpadButton(
                  height: widget.height,
                  haveBorder: false,
                  icon: Icons.backspace,
                  onPressed: ()=>backspace(number),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Preview extends StatelessWidget {
  final int? length;
  final String text;
  final List<Widget> extraData;

  const Preview({Key? key, required this.length, required this.text, required this.extraData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> previewLength = extraData.map((e) => e).toList();
    for (var i = 0; i < length!; i++) {
      //////// print("${i} - ${text.length >= i+1 ? text[i] : null}");
      previewLength.add( Dot(isActive: text.length >= i+1, value: text.length >= i+1 ? text[i] : null, isSpace: [1,4, 6].contains(i)));
    }
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: previewLength
        )
    );
  }
}

class Dot extends StatelessWidget {
  final bool isActive;
  final String? value;
  final bool isSpace;
  const Dot({Key? key, this.isActive = false, this.value, this.isSpace : false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
      child: value == null ? Container(
        margin: EdgeInsets.only(right: isSpace ? 8 : 0 ),
        width: 16 ,
        child: Center(
          child: Text("·", style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.textGreyColor, fontSize: 28),),
        ),
      ):Container(
        // width: 10.0,
        // height: 15.0,
        margin: EdgeInsets.only(right: isSpace ? 8 : 0 ),
        width: 16 ,
        child: Center(
          child: Text("${value!}", style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 28, color: this.isActive ? null : MainColors.textGreyColor),),
        ),
      ),
    );
  }
}

class NumpadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final bool haveBorder;
  final Function()? onPressed;
  final double height;
  const NumpadButton({Key? key, this.text, this.icon, this.haveBorder=true, this.onPressed, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget label = icon != null ? SvgPicture.asset("assets/svgs/keyboard/delete.svg")
        : Text(text ?? '', style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 22));

    return Expanded(
      child: InkWell(
        onTap: onPressed ?? null,
        child: Container(height: (height - 120) / 4 ,child: Center(child: label)),
      ),
    );
  }
}