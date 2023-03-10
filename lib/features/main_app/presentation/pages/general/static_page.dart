import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lifestep/features/main_app/presentation/widgets/appbar/general.dart';



class StaticPageView extends StatefulWidget {
  final String htmlData;
  final String title;
  const StaticPageView({Key? key, required this.title, required this.htmlData, }) : super(key: key);

  @override
  _StaticPageViewState createState() => _StaticPageViewState();
}

class _StaticPageViewState extends State<StaticPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8, ),
          child: Column(
            children: [
              if(widget.title != '')
              GeneralAppBar(title: widget.title),
              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: widget.htmlData,
                    style: {
                      "table": Style(
                        backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                      ),
                      "tr": Style(
                        border: const Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      "th": Style(
                        padding: const EdgeInsets.all(6),
                        backgroundColor: Colors.grey,
                      ),
                      "td": Style(
                        padding: const EdgeInsets.all(6),
                        alignment: Alignment.topLeft,
                      ),
                      'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
                    },
                    onLinkTap: (url, _, __, ___) {
                      //////// print("Opening $url...");
                    },
                    onImageTap: (src, _, __, ___) {
                      //////// print(src);
                    },
                    onImageError: (exception, stackTrace) {
                      //////// print(exception);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}