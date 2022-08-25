import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'expanable_text.dart';

class CustomReadMoreLess extends StatelessWidget {
  const CustomReadMoreLess({
    Key? key,
    required this.text,
    this.readLessWidget,
    this.readMoreWidget,
    this.animationDuration = const Duration(milliseconds: 200),
    this.maxHeight = 70,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.iconCollapsed,
    this.iconExpanded,
    this.iconColor = Colors.black,
    this.buttonTextStyle,
  }) : super(key: key);

  /// The main text to be displayed.
  final String text;

  /// The text on the button when the text is expanded, in case the text overflows
  final Widget? readLessWidget;

  /// The text on the button when the text is collapsed, in case the text overflows
  final Widget? readMoreWidget;

  /// The duration of the animation when transitioning between read more and read less.
  final Duration animationDuration;

  /// The maximum height of container around the [text] in the collapsed state.
  final double maxHeight;

  /// The main textstyle used for [text]
  final TextStyle? textStyle;

  /// Whether and how to align [text] horizontally.
  final TextAlign textAlign;

  /// Allows a widget to replace the icon in the read more/less button in the collapsed state.
  final Widget? iconCollapsed;

  /// Allows a widget to replace the icon in the read more/less button in the expanded state.
  final Widget? iconExpanded;

  /// The color of the icon in the read more/less button. Does not work when [iconCollapsed] or [iconExpanded] are specified.
  final Color iconColor;

  /// The textstyle used for the read more/less button
  final TextStyle? buttonTextStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LayoutBuilder(
          builder: (context, size) {
            final span = TextSpan(
              text: text,
              style: textStyle ??
                  Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Theme.of(context).textTheme.bodyText2?.color),
            );

            final tp = TextPainter(
              maxLines: 4,
              textAlign: textAlign,
              textDirection: TextDirection.ltr,
              text: span,
            );

            tp.layout(maxWidth: size.maxWidth);

            final isExceeded = tp.didExceedMaxLines;

            return isExceeded
                ? ExpandableText(
                  text: text,
                  animationDuration: animationDuration,
                  maxHeight: maxHeight,
                  readLessWidget: readLessWidget ?? readLess,
                  readMoreWidget: readMoreWidget?? readMore,
                  textAlign: textAlign,
                  textStyle: textStyle,
                  iconCollapsed: iconCollapsed,
                  iconExpanded: iconExpanded,
                  iconColor: iconColor,
                  buttonTextStyle: buttonTextStyle,
            )
                : Text(text,
                softWrap: true,
                overflow: TextOverflow.fade,
                textAlign: textAlign,
                style: textStyle ?? Theme.of(context).textTheme.subtitle1);
          },
        ),
      ],
    );
  }
}


Widget readLess = Container(
  child: SvgPicture.asset("assets/svgs/general/less.svg"),
);
Widget readMore = Container(
  margin: const EdgeInsets.only(top: 8),
  child: SvgPicture.asset("assets/svgs/general/more.svg"),
);