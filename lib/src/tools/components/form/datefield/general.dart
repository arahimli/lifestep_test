import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';

class GeneralDateField extends StatefulWidget {
  GeneralDateField({
    Key? key,
    required this.size,
    required this.hintText,
    this.iconAdress,
    required this.controller,
    required this.toDo, this.label, this.hintColor, this.labelStyle, this.suffixIcon, this.padding, this.focusNode, this.prefix, this.prefixText, this.prefixStyle, this.keyboardType, this.mainStyle, this.hintStyle, required this.hasError, this.errorText, this.autofocus = false, this.enabled : true, this.requiredInput : true, this.format, this.firstDate, this.lastDate, this.initialDate, this.valueDate,
  }) : super(key: key);
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final DateTime? valueDate;
  final Size size;
  final String? label;
  final String? hintText;
  final Color? hintColor;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? mainStyle;
  final String? iconAdress;
  final TextEditingController controller;
  final Function toDo;
  final Widget? suffixIcon;
  final EdgeInsets? padding;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget? prefix;
  final String? prefixText;
  final bool hasError;
  final String? errorText;
  final TextStyle? prefixStyle;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool requiredInput;
  final List<TextInputFormatter>? format;


  @override
  _GeneralDateFieldState createState() => _GeneralDateFieldState();
}

class _GeneralDateFieldState extends State<GeneralDateField> {


  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    // selectedDate = widget.valueDate ?? widget.initialDate ?? DateTime.now();

    if(widget.valueDate != null){
      if(widget.firstDate == null && widget.lastDate == null){
        selectedDate = widget.valueDate;
      }else if(widget.firstDate != null && widget.lastDate != null){
        selectedDate = widget.valueDate;
      }else if(widget.lastDate != null){
        if (widget.valueDate == widget.lastDate || widget.lastDate!.isAfter(widget.valueDate!))
          selectedDate = widget.valueDate;
        else
          selectedDate = widget.lastDate;
      }
      else if(widget.firstDate != null){
        if (widget.firstDate == widget.valueDate || widget.firstDate!.isBefore(widget.valueDate!))
          selectedDate = widget.valueDate;
        else
          selectedDate = widget.firstDate;
      }
      else selectedDate = widget.valueDate;
    }else if(widget.initialDate != null){
      if(widget.firstDate == null && widget.lastDate == null){
        selectedDate = widget.initialDate;
      }else if(widget.firstDate != null && widget.lastDate != null){
        selectedDate = widget.initialDate;
      }else if(widget.lastDate != null){
        if (widget.initialDate == widget.lastDate || widget.lastDate!.isAfter(widget.initialDate!))
          selectedDate = widget.initialDate;
        else
          selectedDate = widget.lastDate;
      }
      else if(widget.firstDate != null){
        if (widget.firstDate == widget.initialDate || widget.firstDate!.isBefore(widget.initialDate!))
          selectedDate = widget.initialDate;
        else
          selectedDate = widget.firstDate;
      }
      else selectedDate = widget.initialDate;
    }else{
      if(widget.lastDate != null)
        selectedDate = widget.lastDate;
      else if(widget.firstDate != null)
        selectedDate = widget.firstDate;
      else
        selectedDate = DateTime.now();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AutoSizeText(widget.label ?? "Name", style: widget.labelStyle ?? MainStyles.grayTextStyle.copyWith(fontSize: 14),),
              GestureDetector(
                onTap: (){
                  Utils.focusClose(context);
                  showDatePickerDialog(context, widget.size);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    // height: 32,
                    child: FocusScope(
                      child: Focus(
                        child: TextFormField(
                          // enabled: widget.enabled,
                          maxLines: 1,
                          controller: widget.controller,
                          inputFormatters: widget.format ?? [],
                          onChanged: (value) {

                            if(widget.toDo != null && widget.enabled) {
                              widget.toDo(value);
                            }
                          },


                          focusNode: widget.focusNode,
                          autofocus: widget.autofocus,
                          style: widget.mainStyle ?? MainStyles.semiBoldTextStyle,
                          keyboardType: widget.keyboardType,
                          decoration: InputDecoration(
                            hintText: '${widget.hintText}',
                            isCollapsed: false,
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                              top: 10, //widget.size.height / (812 / 18),
                              bottom: 10,
                            ),
                            hintStyle: widget.hintStyle ?? MainStyles.semiBoldTextStyle.copyWith(color: MainColors.grey),
                            // enabledBorder: InputBorder.none,
                            // filled: true,
                            labelStyle: widget.labelStyle ?? MainStyles.regularTextStyle.copyWith(fontSize: 16),
                            label: widget.label != null ? RichText(
                              text: TextSpan(
                                text: widget.label ?? "Name",
                                style: widget.labelStyle ?? MainStyles.semiBoldTextStyle.copyWith(fontSize: 16, color: MainColors.middleGrey500),
                                children: <TextSpan>[
                                  if(widget.requiredInput)
                                    TextSpan(
                                      text:
                                      " *",
                                      style: widget.labelStyle ?? MainStyles.semiBoldTextStyle.copyWith(fontSize: 16, color: MainColors.red),
                                    ),
                                ],
                              ),
                            ):null,
                            // suffix: SvgPicture.asset("assets/svgs/form/filter.svg", height: 20,),
                            suffixIcon: widget.suffixIcon ?? null,
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 20,
                            ),

                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            disabledBorder: InputBorder.none,
                            // focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: MainColors.generalSubtitleColor!)
                            ),
                            prefixText: widget.prefixText,
                            prefixStyle: widget.prefixStyle ?? MainStyles.semiBoldTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
        if(widget.hasError && widget.errorText != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8, ),
            child: Text(widget.errorText!, style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.red, fontSize: 14),),
          ),
      ],
    );
  }




  Future<void> showDatePickerDialog(BuildContext context, Size size) async{

    DateTime? inDate;
    if(widget.valueDate != null){
      if(widget.firstDate == null && widget.lastDate == null){
        inDate = widget.valueDate;
      }else if(widget.firstDate != null && widget.lastDate != null){
        inDate = widget.valueDate;
      }else if(widget.lastDate != null){
        if (widget.valueDate == widget.lastDate || widget.lastDate!.isAfter(widget.valueDate!))
          inDate = widget.valueDate;
        else
          inDate = widget.lastDate;
      }
      else if(widget.firstDate != null){
        if (widget.firstDate == widget.valueDate || widget.firstDate!.isBefore(widget.valueDate!))
          inDate = widget.valueDate;
        else
          inDate = widget.firstDate;
      }
      else inDate = widget.valueDate;
    }else if(widget.initialDate != null){
      if(widget.firstDate == null && widget.lastDate == null){
        inDate = widget.initialDate;
      }else if(widget.firstDate != null && widget.lastDate != null){
        inDate = widget.initialDate;
      }else if(widget.lastDate != null){
        if (widget.initialDate == widget.lastDate || widget.lastDate!.isAfter(widget.initialDate!))
          inDate = widget.initialDate;
        else
          inDate = widget.lastDate;
      }
      else if(widget.firstDate != null){
        if (widget.firstDate == widget.initialDate || widget.firstDate!.isBefore(widget.initialDate!))
          inDate = widget.initialDate;
        else
          inDate = widget.firstDate;
      }
      else inDate = widget.initialDate;
    }else{
      if(widget.lastDate != null)
        inDate = widget.lastDate;
      else if(widget.firstDate != null)
        inDate = widget.firstDate;
      else
        inDate = DateTime.now();
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => Future.value(true),
            child: Material(
              type: MaterialType.transparency,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding: EdgeInsets.only(top: 0),
                content:
                SizedBox(
                  height: size.height * 4.5 / 10,
                  width: size.width,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 0, left: 16, right: 16,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(Utils.getString(context, "general__cupertino_picker_cancel"), style: MainStyles.extraBoldTextStyle,),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                if( selectedDate != null ){

                                  DateFormat formatter = DateFormat('dd.MM.yyyy');
                                  widget.controller.text = formatter.format(selectedDate!);
                                  widget.toDo(formatter.format(selectedDate!));
                                }
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(Utils.getString(context, "general__cupertino_picker_select"), style: MainStyles.extraBoldTextStyle,),
                              ),
                            ),
                            // MainAdvancedButton(
                            //   text: 'Cancel',
                            //   onTap: () {
                            //     Navigator.of(context).pop();
                            //   },
                            // ),
                            // MainAdvancedButton(
                            //   text: 'Done',
                            //   onTap: () {
                            //     // Navigator.of(context).pop(tempPickedDate);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 1,
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: widget.firstDate ??  DateTime(1900),
                          initialDateTime: inDate,
                          maximumDate: widget.lastDate ?? null,
                          onDateTimeChanged: (DateTime dateTime) {

                            setState(() {
                              selectedDate = dateTime;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}