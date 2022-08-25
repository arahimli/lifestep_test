import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;

class HtmlExpandableText extends StatefulWidget {
  const HtmlExpandableText({
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
  _HtmlExpandableTextState createState() => _HtmlExpandableTextState();
}

class _HtmlExpandableTextState extends State<HtmlExpandableText> {
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
            child: flutter_html.Html(
              data: widget.text,
              style: {
                "p": flutter_html.Style(
                  backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                  fontSize: widget.textStyle != null ? flutter_html.FontSize(widget.textStyle!.fontSize) : null,
                  fontFamily: widget.textStyle != null ? widget.textStyle!.fontFamily! : null
                  // fontWeight: widget.textStyle != null ? flutter_html.FontWeight(widget.textStyle!.fontWeight) : null,
                ),
              },
            ),
          ),
        ),
        isExpanded?
        Column(
          children: [
            const SizedBox(height: 4,),
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
            const SizedBox(height: 8,),
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
