import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/presentation/pages/onboard/item.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/logic/navigator.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardPageView extends StatefulWidget {
  const OnboardPageView({Key? key}) : super(key: key);

  @override
  _OnboardPageViewState createState() => _OnboardPageViewState();
}

class _OnboardPageViewState extends State<OnboardPageView> {
  PageController controller = PageController(initialPage: 0);
  List pages = [
    const Item0(),
    const Item1(),
    const Item2(),
    const Item3(),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          extendBody: true,
          backgroundColor: MainColors.backgroundColor,
          body: SafeArea(
              child: Container(
                height: size.height,
                color: MainColors.backgroundColor,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ScrollConfiguration(
                        behavior: MainScrollBehavior(),
                        child: ConcentricPageView(
                          colors: [MainColors.backgroundColor!, MainColors.backgroundColor!, MainColors.backgroundColor!, MainColors.backgroundColor!, MainColors.backgroundColor!, ],
                          // opacityFactor: 1.0,
                          // scaleFactor: 0.0,
                          radius: 30,
                          curve: Curves.ease,
                          duration: const Duration(seconds: 2),

                          onChange: (value){
                            Utils.focusClose(context);
                          },
                          itemCount: pages.length,
                          pageController: controller,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (index, value) {
                            return pages[index];
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SmoothPageIndicator(
                                controller: controller,  // PageController
                                count:  pages.length,

                                // forcing the indicator to use a specific direction
                                textDirection: TextDirection.ltr,
                                effect:  WormEffect(

                                  dotColor: MainColors.middleBlue150!,
                                  activeDotColor: MainColors.middleBlue500!,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  strokeWidth: 24,
                                ),
                            ),
                          ),
                          BigUnBorderedButton(
                            onTap: ()async{
                              //////// print(controller.page);
                              //////// print(controller.page! < 3);
                              if(controller.page! < 3){
                                await controller.nextPage(
                                    curve: Curves.linear,
                                    duration: const Duration(milliseconds: 500));

                              }else{
                                // model.setOnboard(true);

                                SharedPreferences pref = await SharedPreferences.getInstance();
                                await pref.setBool('onboard', true);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RepositoryProvider(
                                  create: (context) => GetIt.instance<UserRepository>(),
                                  child: BlocProvider(
                                    create: (context) =>
                                        AuthCubit(),
                                    child: const AuthNavigator(),
                                  ),
                                )));
                              }
                              //////// print(controller.page);
                            },
                            text: Utils.getString(context, "general_next"),
                            vertical: 0,
                            horizontal: 16,
                            textStyle: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14),
                            buttonColor: MainColors.transparent,
                            textColor: MainColors.darkBlue500,
                          ),
                        ],
                      ),
                    )
                ],
                ),
              ),
          ),
        ));
  }
}
