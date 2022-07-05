
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/tools/components/dialog/loading.dart';
import 'package:lifestep/tools/components/error/general-widget.dart';
import 'package:lifestep/tools/components/form/textfield/general.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/tools/constants/enum.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:lifestep/logic/step/donation/all/cubit.dart';
import 'package:lifestep/logic/step/donation/month/cubit.dart';
import 'package:lifestep/logic/step/donation/week/cubit.dart';
import 'package:lifestep/model/donation/donors.dart';
import 'package:lifestep/model/donation/fond_donation.dart';
import 'package:lifestep/model/donation/fonds.dart';
import 'package:lifestep/pages/donations/details/fond/logic/deatil_cubit.dart';
import 'package:lifestep/pages/donations/details/fond/logic/details_state.dart';
import 'package:lifestep/pages/donations/details/fond/logic/donate/cubit.dart';
import 'package:lifestep/pages/donations/details/fond/logic/donate/state.dart';
import 'package:lifestep/pages/donations/details/fond/logic/donors/cubit.dart';
import 'package:lifestep/pages/donations/details/fond/logic/donors/state.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:lifestep/tools/components/shimmers/donations/donor.dart';
import 'package:lifestep/tools/components/shimmers/skeleton-list-no-scrolling.dart';



class DonationFondDetailView extends StatefulWidget {
  const DonationFondDetailView({Key? key}) : super(key: key);

  @override
  _DonationFondDetailViewState createState() => _DonationFondDetailViewState();
}

class _DonationFondDetailViewState extends State<DonationFondDetailView> {

  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<FondDetailsBloc, FondDetailsState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: ()async{
            if(context.read<FondDetailsBloc>().fondChanged)
              Navigator.pop(context, state.fondModel);
            else
              Navigator.pop(context);
            return Future(() => false);
          },
          child: Scaffold(
            body: GestureDetector(
              onTap: () {
                Utils.focusClose(context);
              },
              child: Stack(
                children: [

                  Container(
                    width: size.width,
                    height: size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                state.fondModel.image ?? MainConfig.defaultImage
                            )
//                              AssetImage(
//                                "assets/images/api-service/doctor-page.png",
//                              )
                        )
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: SlidingUpPanel(
                          backdropEnabled: true,
                          maxHeight: size.height - 120,
                          minHeight: size.height - size.width + 24,
                          parallaxEnabled: true,
                          parallaxOffset: .5,
                          // collapsed: Container(
                          //   height: 30,
                          //   color: Colors.red,
                          // ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.0),
                              topRight: Radius.circular(24.0)
                          ),
                          boxShadow: [

                            // BoxShadow(
                            //     color: Color.fromRGBO(0, 0, 0, 0.25),
                            //     blurRadius: 4.0,
                            //     offset: Offset(0.0, -4.0)
                            // ),
                          ],

                          // borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(18.0),
                          //     topRight: Radius.circular(18.0)),
                          // body: Container(),
                          panelBuilder: (sc) => MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MainColors.white,

                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.0),
                                        topRight: Radius.circular(24.0))
                                ),
                                padding: EdgeInsets.only(
                                  // left: 16,
                                  // right: 16,
                                    top: 8,
                                    bottom: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    SizedBox(
                                      height: 8,
                                    ),

                                    Center(
                                      child: Container(
                                          width: 64,
                                          height: 4,
                                          decoration: BoxDecoration(
                                              color: MainColors.middleGrey200,
                                              borderRadius:
                                              BorderRadius.circular(30))),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: ScrollConfiguration(
                                        behavior: MainScrollBehavior(),
                                        child: SingleChildScrollView(
                                          controller: sc,
                                          // physics: ScrollPhysics(),
                                          // physics: AlwaysScrollableScrollPhysics(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: MainColors.white,
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 0,
                                                bottom: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                AutoSizeText(
                                                  state.fondModel.name ?? '-',
                                                  style: MainStyles.semiBoldTextStyle.copyWith(height: 1.5, fontSize: 24),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                AutoSizeText(
                                                  state.fondModel.description ?? '-',
                                                  style: MainStyles.semiBoldTextStyle.copyWith(height: 1.5, ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),

                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      border: Border.all(color: MainColors.darkPink500!, width: 2)
                                                  ),
                                                  child: Column(
                                                    children: [

                                                      Text(
                                                        "${state.fondModel.totalSteps != null ? state.fondModel.totalSteps.toString().length < 6 ? state.fondModel.totalSteps : Utils.humanizeInteger(state.fondModel.totalSteps!) : 0}",
                                                        style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 40, color: MainColors.darkPink500),
                                                        textAlign: TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(height: 8,),
                                                      Text(
                                                        Utils.getString(context, "donation_fond_detail__view__steps_donated"),
                                                        style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.middleGrey400),
                                                        textAlign: TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: 24,
                                                ),

                                                SizedBox(
                                                  height: 24,
                                                ),
                                                Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        AutoSizeText(Utils.getString(context, "general__donations"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                                                        BlocBuilder<FondDonorListCubit, FondDonorListState>(
                                                            builder: (context, stateDonor) {
                                                              return stateDonor is FondDonorListSuccess ?
                                                              AutoSizeText("${Utils.humanizeInteger(stateDonor.dataCount)} ${Utils.getString(context, "general__person__count")}", style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),)
                                                                  : Container(child: Text(" "),);
                                                            }
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                SizedBox(height: 4,),
                                                BlocBuilder<FondDonorListCubit, FondDonorListState>(
                                                    builder: (context, stateDonor) {
                                                      return stateDonor is FondDonorListSuccess ? ListView.separated(
                                                        separatorBuilder: (BuildContext context, int index) {
                                                          return SizedBox(height: 4,);
                                                        },
                                                        padding: EdgeInsets.symmetric(horizontal: 0),
                                                        itemCount: stateDonor.dataList.length,
                                                        physics: ScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return _DonorWidget(index: index, donorModel: stateDonor.dataList[index]);
                                                        },
                                                      ) : stateDonor is FondDonorListError ?
                                                      GeneralErrorLoadAgainWidget(
                                                        onTap: (){
                                                          context.read<FondDonorListCubit>().search();
                                                        },
                                                      )
                                                          : SkeletonNoScrollingListWidget(
                                                        child: DonorListItemShimmerWidget(),
                                                      );
                                                    }
                                                ),

                                                SizedBox(height: 20),
                                                BigUnBorderedButton(
                                                  buttonColor: MainColors.generalColor,
                                                  onTap: (){

                                                    showCupertinoModalBottomSheet(
                                                      expand: false,
                                                      context: context,

                                                      backgroundColor: Colors.transparent,

                                                      builder: (_) => BlocProvider<FondDonateCubit>(create: (_) => FondDonateCubit(
                                                        donationRepository: DonationRepository(),
                                                        fondModel: state.fondModel,
                                                      ),
                                                          child: _DonationModal(
                                                            controllerTopCenter: _controllerTopCenter,
                                                            setFond: (FondModel value){
                                                              BlocProvider.of<FondDetailsBloc>(context).setFond(value);
                                                            },
                                                            setDonors: (List<DonorModel> value, int count) {
                                                              BlocProvider.of<FondDonorListCubit>(context).setDonors(value, count);
                                                            },
                                                          )
                                                      ),
                                                    );

                                                  },
                                                  // borderRadius: 100,
                                                  text: Utils.getString(context, "general__donation_button"),
                                                ),
                                                // SizedBox(
                                                //   height: 24,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          onPanelSlide: (double pos) {
                            // context.read<SlidingUpCubit>().changePosition(pos);
                            // setState(() {
                            //   _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                            //       _initFabHeight;
                            // });
                          },
                        ),
                      ),

                    ],
                  ),

                  Positioned(
                    left: 10.0,
                    top: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        if(context.read<FondDetailsBloc>().fondChanged)
                          Navigator.pop(context, state.fondModel);
                        else
                          Navigator.pop(context);

                      },
                      child: Container(

                        padding: EdgeInsets.fromLTRB(
                          14,
                          14,
                          14,
                          14,
                          // 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              100),
                          color: MainColors.white,

                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          "assets/svgs/menu/back.svg",
                          color: MainColors.black,
                          height: 20,
                        ),
                      ),

                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}




class _DonorWidget extends StatelessWidget {
  final int index;
  final DonorModel donorModel;
  const _DonorWidget({Key? key, required this.index, required this.donorModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
      ),
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: MainColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: Image.asset(donorModel.genderType == GENDER_TYPE.MAN ? MainConfig.defaultMan : MainConfig.defaultWoman,
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  )
                  // CachedNetworkImage(
                  //   placeholder: (context, key){
                  //     return Container(
                  //       width: size.width * 0.6 / 6,
                  //       height: size.width * 0.6 / 6,
                  //       decoration: BoxDecoration(
                  //         // color: Colors.blue,
                  //         image: DecorationImage(
                  //           image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                  //           fit: BoxFit.fill,
                  //         ),
                  //         borderRadius:
                  //         BorderRadius.all(
                  //           Radius.circular(500.0),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   // key: Key("${"vvvvv"}${1}"),
                  //   // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                  //   imageUrl: MainConfig.defaultImage,
                  //   width: size.width * 0.6 / 6,
                  //   height: size.width * 0.6 / 6,
                  // )
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      AutoSizeText(
                        donorModel.fullName ?? "-",
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      AutoSizeText(
                        "${donorModel.steps != null ? donorModel.steps.toString().length > 6 ? Utils.humanizeInteger(donorModel.steps!) : donorModel.steps : 0}  ${Utils.getString(context, "general__steps__count")}",
                        // "${Utils.humanizeInteger(donorModel.steps ?? 0)} ${Utils.getString(context, "general__steps__count")}",
                        style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 14, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              Text("${(index + 1).toString()}",
                style: MainStyles.extraBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 14, height: 1.1),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class _DonationModal extends StatelessWidget {
  final Function setFond;
  final Function(List<DonorModel>, int) setDonors;
  final ConfettiController controllerTopCenter;

  const _DonationModal({Key? key, required this.setFond, required this.setDonors, required this.controllerTopCenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SessionCubit sessionCubit = BlocProvider.of<SessionCubit>(context);
    return Material(
      child: BlocBuilder<FondDonateCubit, FondDonateState>(
          builder: (context, state) {
            return BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  return
                    SafeArea(
                      top: false,
                      child: Container(
                        // padding:
                        // EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16, top: 16),
                        child:
                        settingsState is  SettingsStateLoaded ?
                        Column(
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

                            SizedBox(height: 12,),
                            GeneralTextField(
                              size: size,
                              label: Utils.getString(context, "general__donation_modal__donated_field_step_label"),
                              hintText: Utils.getString(context, "general__donation_modal__donated_field_step_hint"),
                              hasError: !state.isValidAmount,
                              errorText: Utils.getString(context, "general__donation_modal__donated_field_step_error_text"),
                              controller: BlocProvider.of<FondDonateCubit>(context).inputController,
                              keyboardType: TextInputType.number,
                              format: [
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                LengthLimitingTextInputFormatter(12),
                              ],
                              toDo: (value){
                                BlocProvider.of<FondDonateCubit>(context).inputChanged(
                                    value
                                );
                              },
                            ),
                            SizedBox(height: 12,),

                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                // border: Border.all(color: MainColors.darkPink500!, width: 2),
                                color: MainColors.middleGrey100,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color: MainColors.middleGrey200!
                                                    )
                                                )
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${state.isValidAmount ? Utils.humanizeDouble(Utils.stringToDouble(value: state.amount) * (settingsState.settingsModel!.step)) : 0 }",
                                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.darkPink500),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      " ${Utils.getString(context, "general__money_text").toUpperCase()}",
                                                      style: MainStyles.boldTextStyle.copyWith(fontSize: 14, color: MainColors.darkPink500),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8,),
                                                AutoSizeText(
                                                  Utils.getString(context, "general__donation_modal__you_spend"),
                                                  style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.middleGrey400),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          child: Column(
                                            children: [

                                              Text(
                                                "${Utils.humanizeInteger(BlocProvider.of<SessionCubit>(context).currentUser!.balanceSteps ?? 0)}",
                                                style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24),
                                                textAlign: TextAlign.left,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8,),
                                              AutoSizeText(
                                                Utils.getString(context, "general__donation_modal__available_steps"),
                                                style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.middleGrey400),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),

                                  SizedBox(height: 8)
                                ],
                              ),
                            ),
                            SizedBox(height: 12,),

                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              decoration: BoxDecoration(
                                // color: MainColors.white,
                                // borderRadius: BorderRadius.circular(16)
                              ),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  CupertinoSwitch(
                                    value:state.checked,
                                    onChanged: (value) async{
                                      // state = value;
                                      //////// print("DynamicTheme.of(context)!.setTheme(");
                                      BlocProvider.of<FondDonateCubit>(context).checkboxChanged(
                                          value
                                      );
                                    },

                                    activeColor: MainColors.darkPink100,
                                    thumbColor: state.checked ? MainColors.darkPink500 : MainColors.middleGrey300,
                                    trackColor: MainColors.middleGrey100,
                                  ),
                                  SizedBox(width: 16,),
                                  Text(Utils.getString(context, "general__donation_modal__add_my_name_to_rating"),
                                    style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1),
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),

                            SizedBox(height: 12,),
                            Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: BigUnBorderedButton(
                                      buttonColor: state.isValidAmount && Utils.stringToDouble(value: state.amount) > 0 && Utils.stringToDouble(value: state.amount) <= (BlocProvider.of<SessionCubit>(context).currentUser!.balanceSteps ?? 0) ? null : MainColors.middleBlue100 ,
                                      text: Utils.getString(context, "health_detail_view___tab_today__donate_button"),
                                      onTap: ()async{
                                        if(state.isValidAmount && Utils.stringToDouble(value: state.amount) > 0 && Utils.stringToDouble(value: state.amount) <= (sessionCubit.currentUser!.balanceSteps ?? 0)) {
                                          showLoading(context, Utils.getString(context,"general__loading_text"));
                                          List listData = await context.read<FondDonateCubit>().submitDonation();
                                          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
                                            FondDonationResponse donationResponse = FondDonationResponse.fromJson(listData[1]);
                                            setFond(donationResponse.data!.fond!);
                                            setDonors(donationResponse.data!.donates!, donationResponse.data!.donateCount!);
                                            sessionCubit.setUser(donationResponse.data!.user!);
                                            closeLoading(context);
                                            closeLoading(context);
                                            // Navigator.pop(context);

                                            BlocProvider.of<GeneralUserLeaderBoardWeekDonationCubit>(context).refresh();
                                            BlocProvider.of<GeneralUserLeaderBoardMonthDonationCubit>(context).refresh();
                                            BlocProvider.of<GeneralUserLeaderBoardAllDonationCubit>(context).refresh();
                                            Utils.showSuccessModal(context, size, title: Utils.getString(context, "page_donation_list___donation_success_mesage"), image: "assets/svgs/donations/success-dialog.svg");

                                            for(var item in donationResponse.data!.userAchievementsModels!){
                                              controllerTopCenter.duration = Duration(seconds: 5);
                                              controllerTopCenter.play();
                                              await Utils.showAchievementModal(context, size, controllerTopCenter, title: item.description, image: item.imageUnlocked);
                                              controllerTopCenter.stop();
                                            }
                                          }
                                          else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH) {
                                            closeLoading(context);
                                            BlocProvider.of<SessionCubit>(context).setUser(null);
                                            Navigator.pushReplacementNamed(context, "/apploading");
                                          } else {
                                            closeLoading(context);
                                            Utils.showErrorModal(context, size, errorCode: listData[2], title: Utils.getString(context, "error_went_wrong"));
                                          }
                                        }else{

                                        }
                                      },
                                    )
                                )
                              ],
                            )
                          ],
                        ) : settingsState is  SettingsError ? Container(child: Text("Error"),) : Container(child: Text("loading"),),
                      ),
                    );
                }
            );
          }
      ),
    );
  }
}