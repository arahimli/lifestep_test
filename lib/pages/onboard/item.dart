
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/config/styles.dart';

class Item0 extends StatelessWidget {
  const Item0({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).viewPadding.top;
    var heightMain = size.height - 270 - height;
    bool extra = size.height > 680;
    // bool extra = size.width + 48 > (size.height / 2 - 270 - height);

    return Stack(
      children: [
        Container(
          height: heightMain - 100,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.elliptical(size.width * 3 / 10, size.width * 7 / 10),
              bottomLeft: Radius.elliptical(size.width * 7 / 10, size.width * 4 / 10),
              bottomRight: Radius.elliptical(size.width * 3 / 10, size.width * 2 / 10),
            )
          ),
        ),
        Container(
          // color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color: Colors.red,
                height: heightMain - 100 - 32,
                padding: EdgeInsets.only(top: (extra ? 28 : 10)),
                child: Image(image: AssetImage(
                    "assets/images/onboard/sc-0.png"
                )),
              ),
              Container(
                // color: Colors.red,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      // padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: AutoSizeText(
                        Utils.getString(context, "onboard__title_0"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: extra ? 40 : 34),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: size.width * 1 / 6 - 16),
                      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: size.width * 1 / 6 - 16),
                      child: AutoSizeText(
                        Utils.getString(context, "onboard__subtitle_0"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).viewPadding.top;
    var heightMain = size.height - 270 - height;
    bool extra = size.height > 680;
    return Stack(
      children: [
        Container(
          height: heightMain - 100,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(size.width * 7 / 10, size.width * 3 / 10),
                bottomLeft: Radius.elliptical(size.width * 7 / 10, size.width * 5 / 10),
                bottomRight: Radius.elliptical(size.width * 3 / 10, size.width * 2 / 10),
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: heightMain - 100 - 32,
                padding: EdgeInsets.only(top: (extra ? 28 : 10)),
                child: Image(image: AssetImage(
                    "assets/images/onboard/sc-1.png"
                )),
              ),
              Container(
                // color: Colors.red,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      // padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: AutoSizeText(
                        // (size.height - 270 - height).toString(),
                        // (size.width + 48).toString(),
                        Utils.getString(context, "onboard__title_1"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: extra ? 40 : 34),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: size.width * 1 / 6 - 16),
                      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: size.width * 1 / 6 - 16),
                      child: AutoSizeText(
                        Utils.getString(context, "onboard__subtitle_1"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).viewPadding.top;
    var heightMain = size.height - 270 - height;
    bool extra = size.height > 680;
    return Stack(
      children: [
        Container(
          height: heightMain - 100,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.elliptical(size.width * 7 / 10, size.width * 3 / 10),
              bottomRight: Radius.elliptical(size.width * 7 / 10, size.width * 5 / 10),
              bottomLeft: Radius.elliptical(size.width * 3 / 10, size.width * 2 / 10),
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: heightMain - 100 - 32,
                padding: EdgeInsets.only(top: (extra ? 28 : 10)),
                child: Image(image: AssetImage(
                    "assets/images/onboard/sc-2.png"
                )),
              ),
              Container(
                // color: Colors.red,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      // padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: AutoSizeText(
                        // (size.height - 270 - height).toString(),
                        // (size.width + 48).toString(),
                        Utils.getString(context, "onboard__title_2"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: extra ? 40 : 34),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: size.width * 1 / 6 - 16),
                      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: size.width * 1 / 6 - 16),
                      child: AutoSizeText(
                        Utils.getString(context, "onboard__subtitle_2"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).viewPadding.top;
    var heightMain = size.height - 270 - height;
    bool extra = size.height > 680;
    return Stack(
      children: [
        Container(
          height: heightMain - 100,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(size.width * 7 / 10, size.width * 5 / 10),
              bottomRight: Radius.elliptical(size.width * 6 / 10, size.width * 5 / 10),
              bottomLeft: Radius.elliptical(size.width * 4 / 10, size.width * 2 / 10),
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: heightMain - 100 - 32,
                padding: EdgeInsets.only(top: (extra ? 28 : 0)),
                child: Image(image: AssetImage(
                    "assets/images/onboard/sc-3.png"
                )),
              ),
              Container(
                // color: Colors.red,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      // padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: AutoSizeText(
                        // (size.height - 270 - height).toString(),
                        // (size.width + 48).toString(),
                        Utils.getString(context, "onboard__title_3"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: extra ? 40 : 34),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: size.width * 1 / 6 - 16),
                      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: size.width * 1 / 6 - 16),
                      child: AutoSizeText(
                        Utils.getString(context, "onboard__subtitle_3"),
                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}



