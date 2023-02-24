import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_borderd_button.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/main_app/presentation/widgets/form/select/selectable/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/widgets/form/select/selectable/logic/state.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SelectableField extends StatefulWidget {
  const SelectableField({
    Key? key,
    this.dataMap = const [],
    this.initialValue = '',
    required this.size,
    required this.hintText,
    this.iconAdress,
    required this.controller,
    required this.toDo, required this.validateFunction, this.label, this.hintColor, this.labelStyle, this.suffixIcon, this.padding, this.focusNode, this.prefix, this.prefixText, this.prefixStyle, this.keyboardType, this.mainStyle, this.hintStyle, required this.hasError, this.errorText, this.autofocus = false, this.enabled = true, this.requiredInput = true, this.format
  }) : super(key: key);
  final Size size;
  final List<Map<String, dynamic>> dataMap;
  final String initialValue;
  final String? label;
  final String? hintText;
  final Color? hintColor;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? mainStyle;
  final String? iconAdress;
  final TextEditingController controller;
  final Function toDo;
  final Function validateFunction;
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
  _SelectableFieldState createState() => _SelectableFieldState();
}

class _SelectableFieldState extends State<SelectableField> {

  @override
  void initState() {
    //////// print("initState____SelectableFieldState");
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
                  //////// print("showDatePickerDialog");
                  Utils.focusClose(context);

                  showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider<SelectableSelectCubit>(
                        create: (_) => SelectableSelectCubit(
                          dataMap: widget.dataMap,
                          initialValue: widget.initialValue,
                          inputController: widget.controller,
                          validateFunction: widget.validateFunction,
                          onTap: widget.toDo
                        ),
                        child: const SelectableSelectModal()
                    ),
                  );
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: FocusScope(
                    child: Focus(
                      child: TextFormField(
                        // enabled: widget.enabled,
                        maxLines: 1,
                        controller: widget.controller,
                        inputFormatters: widget.format ?? [],
                        onChanged: (value) {

                          if(widget.enabled) {
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




class SelectableSelectModal extends StatelessWidget {
  const SelectableSelectModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: BlocBuilder<SelectableSelectCubit, SelectableSelectState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Center(
                    child: Container(
                        width: 64,
                        height: 4,
                        decoration: BoxDecoration(
                            color: MainColors.middleGrey200,
                            borderRadius:
                            BorderRadius.circular(30))),
                  ),
                  // Text("${state.value!} ---- "),
                  const SizedBox(height: 12,),
                  for (int i=0; i< BlocProvider.of<SelectableSelectCubit>(context).dataMap.length; i++)
                  ListTile(
                    title: Text(BlocProvider.of<SelectableSelectCubit>(context).dataMap[i]['display'], style: MainStyles.semiBoldTextStyle,),
                    onTap: () async{
                      BlocProvider.of<SelectableSelectCubit>(context).setValue(BlocProvider.of<SelectableSelectCubit>(context).dataMap[i]['keyword'], i);
                      // BlocProvider.of<SelectableSelectCubit>(context).dataMap[i]['keyword']
                    },
                    trailing: SvgPicture.asset("assets/svgs/general/check.svg",
                      color: state.value == BlocProvider.of<SelectableSelectCubit>(context).dataMap[i]['keyword'] ? Colors.green : Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: BigUnBorderedButton(
                            buttonColor: state.changed ? null : MainColors.middleBlue100 ,
                            text: Utils.getString(context, "general__selectable_select_save"),
                            onTap: ()async{
                              if(state.changed) {
                                await context.read<SelectableSelectCubit>().applyValue();
                                Navigator.of(context).pop();
                              }
                            },
                          )
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                          flex: 1,
                          child: BigBorderedButton(
                            text: Utils.getString(context, "general__selectable_select_cancel"),
                            onTap: () => Navigator.of(context).pop(),
                          )
                      ),
                    ],
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}




class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}