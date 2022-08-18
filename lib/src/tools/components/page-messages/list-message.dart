

// child: Image.asset("assets/images/error/went-wrong.png"),

import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class ListMessageWidget extends StatefulWidget {
  final String text;
  final Function refresh;
  const ListMessageWidget({Key? key, required this.text, required this.refresh}) : super(key: key);

  @override
  _ListMessageWidgetState createState() => _ListMessageWidgetState();
}

class _ListMessageWidgetState extends State<ListMessageWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraint) {
        return RefreshIndicator(
          onRefresh: ()async{
            await widget.refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 1.5 / 10),
                      child: Image.asset("assets/images/error/list-warning message.png"),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 1.2 / 10, vertical: 32),
                      child: Text(widget.text, style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


class ListErrorMessageWidget extends StatefulWidget {
  final String text;
  final Function() refresh;
  final WEB_SERVICE_ENUM? errorCode;
  const ListErrorMessageWidget({Key? key, required this.text, required this.refresh, this.errorCode}) : super(key: key);

  @override
  _ListErrorMessageWidgetState createState() => _ListErrorMessageWidgetState();
}

class _ListErrorMessageWidgetState extends State<ListErrorMessageWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraint) {
        return RefreshIndicator(
          onRefresh: ()async{
            await widget.refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 1.5 / 10),
                    child: Image.asset(widget.errorCode == null ? "assets/images/error/went-wrong.png" : widget.errorCode == WEB_SERVICE_ENUM.INTERNET_ERROR ? "assets/images/error/internet.png" : widget.errorCode == WEB_SERVICE_ENUM.UNEXCEPTED_ERROR ? "assets/images/error/server.png" : "assets/images/error/went-wrong.png"),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 1.2 / 10, vertical: 32),
                    child: Text(widget.text, style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
