import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    Key? key,
    this.readLessWidget,
    this.readMoreWidget,
    this.animationDuration = const Duration(milliseconds: 200),
    this.maxHeight = 70,
    this.textStyle,
    this.iconCollapsed,
    this.iconExpanded,
    this.textAlign = TextAlign.center,
    this.iconColor = Colors.black,
    this.buttonTextStyle,
  }) : super(key: key);

  final String text;
  final Widget? readLessWidget;
  final Widget? readMoreWidget;
  final Duration animationDuration;
  final double maxHeight;
  final TextStyle? textStyle;
  final Widget? iconExpanded;
  final Widget? iconCollapsed;
  final TextAlign textAlign;
  final Color iconColor;
  final TextStyle? buttonTextStyle;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedSize(
          duration: widget.animationDuration,
          child: ConstrainedBox(
            constraints: isExpanded
                ? const BoxConstraints()
                : BoxConstraints(maxHeight: widget.maxHeight),
            child: Text(
              widget.text,
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: widget.textAlign,
              style: widget.textStyle ?? Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        isExpanded?
        Column(
          children: [
            SizedBox(height: 4,),
            GestureDetector(
              onTap: () => setState(() => isExpanded = false),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: widget.readLessWidget,
              ),
            ),
          ],
        ):Column(
          children: [
            SizedBox(height: 8,),
            Container(
              child: InkWell(
                onTap: () => setState(() => isExpanded = true),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: widget.readMoreWidget
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
