import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';

class GeneralTextField extends StatefulWidget {
  GeneralTextField({
    Key? key,
    required this.size,
    required this.hintText,
    this.iconAdress,
    required this.controller,
    required this.toDo, this.label, this.hintColor, this.labelStyle, this.suffixIcon, this.padding, this.focusNode, this.prefix, this.prefixText, this.prefixStyle, this.keyboardType, this.mainStyle, this.hintStyle, required this.hasError, this.errorText, this.autofocus: false, this.enabled : true, this.requiredInput : true, this.format,
  }) : super(key: key);

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
  _GeneralTextFieldState createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
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
                  if(widget.focusNode != null)
                    widget.focusNode!.requestFocus();
                },
                child: IgnorePointer(
                  ignoring: !widget.enabled,
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
                            contentPadding: const EdgeInsets.only(
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
                            suffixIcon: widget.suffixIcon,
                            suffixIconConstraints: const BoxConstraints(
                                maxHeight: 20,
                            ),

                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            disabledBorder: InputBorder.none,
                            // focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: const UnderlineInputBorder(
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8, ),
            child: Text(widget.errorText!, style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.red, fontSize: 14),),
          ),
      ],
    );
  }
}