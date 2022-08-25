import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/appbar/auth_notification.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lifestep/src/tools/components/page_messages/list-message.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-list.dart';
import 'package:lifestep/src/tools/components/shimmers/user/history.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/models/donation/donation_history.dart';
import 'package:lifestep/src/ui/user/history/logic/cubit.dart';
import 'package:lifestep/src/ui/user/history/logic/state.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class DonationHistoryView extends StatefulWidget {
  const DonationHistoryView({Key? key}) : super(key: key);
  static const routeName = '/donation-history';

  @override
  _DonationHistoryViewState createState() => _DonationHistoryViewState();
}

class _DonationHistoryViewState extends State<DonationHistoryView> with TickerProviderStateMixin {


  @override
  void initState() {

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MainColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AuthNotificationAppbar(
              title: Utils.getString(context, "history_view___title"),
              hideNotificationIcon: true,
              // textStyle: MainStyles.boldTextStyle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 4,),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: CupertinoSearchTextField(
            //     // controller: shopViewModel.searchTextController,
            //     // backgroundColor: MainColors.backgroundColor,
            //     controller: context.read<DonationHistoryListBloc>().searchTextController,
            //     decoration: BoxDecoration(
            //       color: MainColors.backgroundColor,
            //       border: Border.all(
            //         color: Color(0xFFE2E6EE),
            //         width: 1,
            //       ),
            //       borderRadius: BorderRadius.circular(36),
            //     ),
            //     onChanged: (value){},
            //     onSubmitted: (value){
            //       Utils.focusClose(context);
            //       context.read<DonationHistoryListBloc>().search(value, reset: true);
            //     },
            //     onSuffixTap: (){
            //       context.read<DonationHistoryListBloc>().search('', reset: true);
            //       context.read<DonationHistoryListBloc>().searchTextController.text = '';
            //     },
            //     // style: MainStyles.normalTextStyle,
            //     // placeholderStyle: MainStyles.grayTextStyle,
            //     itemSize: size.height / (836 / 24),
            //     itemColor: Color(0xFFC3C5D4),
            //     placeholder: Utils.getString(context, "history_view__search_hint"),
            //     padding: const EdgeInsets.symmetric(vertical: size.height / (836 / 12), horizontal: size.width / (375 / 16)),
            //     prefixInsets: EdgeInsets.only(left: size.width / (375 / 16)),
            //     suffixInsets: EdgeInsets.only(right: size.width / (375 / 16)),
            //     suffixMode: OverlayVisibilityMode.editing,
            //   ),
            // ),
            Flexible(
              flex: 1,
              child: BlocConsumer<DonationHistoryListBloc, DonationHistoryListState>(
                  listener: (context, state){
                    if(state is DonationHistoryListError && state.errorCode == WEB_SERVICE_ENUM.UN_AUTH){
                      Navigator.pushReplacementNamed(context, "/apploading");
                    }
                  },
                  builder: (BuildContext context, state){
                    if(state is DonationHistoryListSuccess)
                      return state.dataList != null && state.dataList!.isNotEmpty ?
                        NotificationListener(
                          onNotification: (t) {
                            if (t is ScrollEndNotification) {
                              context.read<DonationHistoryListBloc>().search(null);
                              return true;
                            }else{
                              return false;
                            }
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return RefreshIndicator(
                                onRefresh: ()async{
                                  await context.read<DonationHistoryListBloc>().refresh();
                                },
                                child: ScrollConfiguration(
                                  behavior: MainScrollBehavior(),
                                  child: SingleChildScrollView(
                                      controller: context.read<DonationHistoryListBloc>().scrollController,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight
                                        ),
                                        // padding: PagePadding.leftRight16(),
                                        child: Column(
                                          children: [
                                            for(int i = 0; i<state.dataList!.length; i++)
                                              _DataItemWidget(dataItem: state.dataList![i],),
                                            if(!state.hasReachedMax)
                                              Container(child: Text("Loading"))
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              );
                            }
                          ),
                        ) :
                        ListMessageWidget(
                          refresh: () {
                            context.read<DonationHistoryListBloc>().refresh();
                          },
                          text: Utils.getString(context, "general__list__empty_message"),
                        );
                    else if(state is DonationHistoryListError) {
                      return ListErrorMessageWidget(
                        errorCode: state.errorCode,
                        refresh: () {
                          context.read<DonationHistoryListBloc>().refresh();
                        },
                        text: Utils.getString(context, state.errorText),
                      );
                    }
                    else {
                      return SkeletonListWidget(
                        itemCount: ((size.height - 200) / (size.width * 0.8 /
                            6 + 16)).round(),
                        child: const HistoryListItemShimmerWidget(),
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _DataItemWidget extends StatelessWidget {
  final DonationHistoryModel dataItem;
  const _DataItemWidget({Key? key, required this.dataItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);;
//          focusNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: dataItem.donatable!.image == null ? Image.asset(MainConfig.defaultDonor,
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  ):
                  CachedNetworkImage(
                    placeholder: (context, key){
                      return Container(

                        // child:
                        // CircularProgressIndicator(
                        //   valueColor:
                        //   AlwaysStoppedAnimation<Color>(
                        //       Colors.orange),
                        // ),
                        width: size.width * 0.8 / 6,
                        height: size.width * 0.8 / 6,
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          image: const DecorationImage(
                            image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                          const BorderRadius.all(
                            Radius.circular(500.0),
                          ),
                        ),
                      );
                    },
                    // key: Key("${"vvvvv"}${1}"),
                    // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                    imageUrl: dataItem.donatable!.image!,
                    width: size.width * 0.8 / 6,
                    height: size.width * 0.8 / 6,
                    fit: BoxFit.cover,
                  )
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        dataItem.donatable!.name ?? '',
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              "${Utils.humanizeInteger(context, dataItem.steps ?? 0)} ${Utils.getString(context, "general__steps__count")}",
                              style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 14, height: 1.1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              dataItem.date != null ? Utils.stringToDatetoString(value: dataItem.date!, formatFrom: "dd-MM-yyyy", formatTo: "dd.MM.yyyy"): '-',
                              style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 14, height: 1.1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              // SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.black,)
            ],
          ),
        ),
      ),
    );
  }
}



