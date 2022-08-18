
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifestep/src/models/general/gallery.dart';
import 'package:lifestep/src/tools/config/cache_image_key.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GeneralCarouselWidget extends StatefulWidget {
  final List<GalleryModel> imageList;
  final double? height;
  final double? indicatorBottomDistance;
  final List<Widget> extraWidgets;

  const GeneralCarouselWidget({Key? key, required this.imageList, this.height, this.indicatorBottomDistance, this.extraWidgets : const[]}) : super(key: key);

  @override
  State<GeneralCarouselWidget> createState() => _GeneralCarouselWidgetState();
}

class _GeneralCarouselWidgetState extends State<GeneralCarouselWidget> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
    super.initState();

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //////// print("CarouselWidget");
    return Container(
      child: Stack(
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.imageList.length ,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, ind){
                GalleryModel item = widget.imageList[ind];
                double generalWidth = size.width;
                return GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    width:  generalWidth,
                    height: widget.height ?? (generalWidth) / 1.85,
                    decoration: const BoxDecoration(
                    ),
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              width: generalWidth,
                              height: widget.height ?? (generalWidth) / 1.85,
                              child: item.image != null ? CachedNetworkImage(
                                placeholder: (context, key){
                                  return Container(
                                    width: size.width,
                                    height: widget.height ?? (generalWidth) / 1.85,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                                key: Key("${MainWidgetKey.SLIDER_ITEM}${item.id}"),
                                imageUrl: item.image != null ? item.image! : MainConfig.defaultImage,
                                width: size.width,
                                height: widget.height ?? (generalWidth) / 1.85,
                                fit: BoxFit.fill,
                              ):
                              Image.asset(
                                "assets/images/api/Banner.png",
                                width: size.width,
                                height: widget.height ?? (generalWidth) / 1.85,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            bottom: widget.indicatorBottomDistance ?? 32,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: _controller,  // PageController
                count:  widget.imageList.length,
                onDotClicked: (int index) async{
                  await _controller.nextPage(
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 300));
                },
                // forcing the indicator to use a specific direction
                // textDirection: TextDirection.RTL,
                effect:  WormEffect(

                  dotColor: MainColors.middleBlue150!,
                  activeDotColor: MainColors.white!,
                  dotHeight: 8,
                  dotWidth: 8,
                  strokeWidth: 24,
                ),
              ),
            ),
          ),

          ...widget.extraWidgets
        ],
      ),
    );
  }
}