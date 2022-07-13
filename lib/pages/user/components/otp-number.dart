import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/pages/user/otp/logic/cubit.dart';
import 'package:lifestep/pages/user/otp/logic/state.dart';
import 'package:lifestep/tools/general/padding/page-padding.dart';

// class OtpNumpadLayer extends StatelessWidget {
//
//   final double height;
//   final int? length;
//   final Function? onChange;
//   final List<Widget> extraData;
//   final bool completed;
//   final String buttonText;
//   final String? initalValue;
//   OtpNumpadLayer({Key? key, this.length, this.onChange, required this.extraData, this.completed = false, required this.buttonText, this.initalValue, required this.height}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return OtpNumpad(
//       height: height,
//       length: length,
//       onChange: onChange,
//       extraData: extraData,
//       completed: completed,
//       buttonText: buttonText,
//       initalValue: initalValue,
//     );
//   }
// }


class OtpNumpad extends StatefulWidget {
  final double height;
  final int? length;
  final Function? onChange;
  final List<Widget> extraData;
  final bool completed;
  final String buttonText;
  final String? initalValue;
  OtpNumpad({Key? key, this.length, this.onChange, required this.extraData, this.completed = false, required this.buttonText, this.initalValue, required this.height}) : super(key: key);

  @override
  _OtpNumpadState createState() => _OtpNumpadState();
}

class _OtpNumpadState extends State<OtpNumpad> {
  String number = '';

  setValue(String val){
    if(number.length < widget.length!)
      setState(() {
        number += val;
        widget.onChange!(number);
      });
  }

  backspace(String text){
    if(text.length > 0){
      setState(() {
        number = text.split('').sublist(0,text.length-1).join('');
        widget.onChange!(number);
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
      child: BlocConsumer<OtpNumpadCubit, OtpNumpadState>(
        listener: (_, otpNumpadState){
          setState(() {
            number = otpNumpadState.otp;
            widget.onChange!(otpNumpadState.otp);
          });
        },
          builder: (_, otpNumpadState) {
          // print(otpNumpadState.otp);
          return Container(
            padding: PagePadding.leftRight16(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // SizedBox(height: (size.height * 25 / 100 - 10) / 4,),
                Preview(text: number, length: widget.length, extraData: widget.extraData,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OtpNumpadButton(
                      height: widget.height,
                      text: '1',
                      onPressed: ()=>setValue('1'),
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      text: '2',
                      onPressed: ()=>setValue('2'),
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      text: '3',
                      onPressed: ()=>setValue('3'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OtpNumpadButton(
                      height: widget.height,
                      text: '4',
                      onPressed: ()=>setValue('4'),
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      text: '5',
                      onPressed: ()=>setValue('5'),
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      text: '6',
                      onPressed: ()=>setValue('6'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OtpNumpadButton(
                      height: widget.height,
                      text: '7',
                      onPressed: ()=>setValue('7'),
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      text: '8',
                      onPressed: ()=>setValue('8'),
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      text: '9',
                      onPressed: ()=>setValue('9'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OtpNumpadButton(
                      height: widget.height,
                      text: '',
                      haveBorder: false,
                      onPressed: null,
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      text: '0',
                      onPressed: ()=>setValue('0'),
                    ),
                    OtpNumpadButton(
                      height: widget.height,
                      haveBorder: false,
                      icon: Icons.backspace,
                      onPressed: ()=>backspace(number),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
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
      previewLength.add( Dot(isActive: text.length >= i+1, value: text.length >= i+1 ? text[i] : null, space: [100].contains(i) ? ' ': '',));
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
  final String? space;
  const Dot({Key? key, this.isActive = false, this.value, this.space}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.0),
      child: value == null ? Container(
        width: 18 ,
        child: Center(
          child: Text("·", style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.textGreyColor, fontSize: 28),),
        ),
      ):Container(
        // width: 10.0,
        // height: 15.0,
        width: 18 ,
        child: Center(
          child: Text("${value!}", style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 28, color: this.isActive ? null : MainColors.textGreyColor),),
        ),
      ),
    );
  }
}

class OtpNumpadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final bool haveBorder;
  final Function()? onPressed;
  final double height;
  const OtpNumpadButton({Key? key, this.text, this.icon, this.haveBorder=true, this.onPressed, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget label = icon != null ? SvgPicture.asset("assets/svgs/keyboard/delete.svg")
        : Text(this.text ?? '', style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 22));

    return Expanded(
      child: InkWell(
        onTap: onPressed ?? null,
        child: Container(height: (height - 120) / 4 ,child: Center(child: label)),
      ),
    );
  }
}