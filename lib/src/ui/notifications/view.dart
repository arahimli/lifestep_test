import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/appbar/auth-notification.dart';
import 'package:lifestep/src/tools/components/page-messages/list-message.dart';
import 'package:lifestep/src/tools/components/shimmers/notification_list_item.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-list.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/models/common/notifications.dart';
import 'package:lifestep/src/tools/constants/page_key.dart';
import 'package:lifestep/src/tools/use_cases/logger/logger_mixin.dart';
import 'package:lifestep/src/ui/notifications/logic/cubit.dart';
import 'package:lifestep/src/ui/notifications/logic/state.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({Key? key}) : super(key: key);

  @override
  _NotificationListViewState createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> with TickerProviderStateMixin, LoggerMixin {
  late TabController tabController;


  @override
  void init() {

    tabController = TabController(length: 2,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: MainColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  AuthNotificationAppbar(
                    title: Utils.getString(context, "notifications_view___title"),
                    hideNotificationIcon: true,
                    // textStyle: MainStyles.boldTextStyle.copyWith(fontSize: 24),
                  ),
                  // TabBar(
                  //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  //   indicatorWeight: 4,
                  //   indicatorPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  //   labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  //   indicatorColor: MainColors.darkPink500,
                  //   unselectedLabelColor: MainColors.middleGrey400,
                  //   labelColor: MainColors.middleGrey900,
                  //   labelStyle: MainStyles.boldTextStyle,
                  //   controller: tabController,
                  //   tabs: [
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //       child: Text(Utils.getString(context, "notifications_view___tab_information")),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //       child: Text(Utils.getString(context, "notifications_view___tab_achievements")),
                  //     ),
                  //   ],
                  // ),

                  Divider(),
                  Expanded(
                      // flex: 1,
                      child: _NotificationListWidget(),
                  ),
                  // Flexible(
                  //     flex: 1,
                  //     child:
                  //     ScrollConfiguration(
                  //       behavior: MainScrollBehavior(),
                  //       child: Container(
                  //         child: TabBarView(
                  //           controller: tabController,
                  //           children: [
                  //             _NotificationListWidget(),
                  //             _NotificationListWidget(),
                  //           ],
                  //         ),
                  //       ),
                  //     )
                  // ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  // TODO: implement pageKey
  PageKeyModel get pageKey => PageKeyConstant.notifications;

  // @override
  // void disp() {
  // }
}



class _NotificationListWidget extends StatefulWidget {
  const _NotificationListWidget({Key? key}) : super(key: key);

  @override
  _NotificationListWidgetState createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<_NotificationListWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<NotificationListCubit, NotificationListState>(
        listener: (context, state){
          if(state is NotificationListError && state.errorCode == WEB_SERVICE_ENUM.UN_AUTH){
            Navigator.pushReplacementNamed(context, "/apploading");
          }
        },
        builder: (BuildContext context, state){
          return state is NotificationListSuccess ?
          state.dataList != null && state.dataList!.isNotEmpty ?
            NotificationListener(
              onNotification: (t) {
                if (t is ScrollEndNotification) {
                  context.read<NotificationListCubit>().search(null);
                  return true;
                }else{
                  return false;
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: ()async{
                      await context.read<NotificationListCubit>().refresh();
                    },
                    child: ScrollConfiguration(
                      behavior: MainScrollBehavior(),
                      child: SingleChildScrollView(
                          controller: context.read<NotificationListCubit>().scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight
                            ),
                            // padding: PagePadding.leftRight16(),
                            child: Column(
                              children: [
                                for(int i = 0; i<state.dataList!.length; i++)
                                  _NotifWidget(dataItem: state.dataList![i],),
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
                context.read<NotificationListCubit>().refresh();
              },
              text: Utils.getString(context, "general__list__empty_message"),
            ) :
          state is NotificationListError ?
            ListErrorMessageWidget(
              errorCode: state.errorCode,
              refresh: () {
                context.read<NotificationListCubit>().refresh();
              },
              text: Utils.getString(context, state.errorText),
            ):
          SkeletonListWidget(
            itemCount: ((size.height - 200)  / 100).round(),
            child: NotificationListItemShimmerWidget(),
          );
        }
    );
  }
}


class _NotifWidget extends StatelessWidget {
  final NotificationModel dataItem;
  const _NotifWidget({Key? key, required this.dataItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Utils.showInfoByDateModal(context, size, title: dataItem.header, text: dataItem.content, buttonText: Utils.getString(context, "general__close_button_text"), dateText: "${dataItem.sendDate != null ? Utils.stringToDatetoString(value: dataItem.sendDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): ''} ${dataItem.sendTime ?? ''}", onTap: (ctx){Navigator.pop(ctx);});
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom:0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: MainColors.middleGrey150!
                )
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "${dataItem.sendDate != null ? Utils.stringToDatetoString(value: dataItem.sendDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-'}",
                style: MainStyles.extraBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 12, height: 1.1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if(dataItem.header != null && dataItem.header != '')
              const SizedBox(height: 8),
              if(dataItem.header != null && dataItem.header != '')
              Text(
                  dataItem.header ?? "-",
                style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleGrey750, fontSize: 16, height: 1.1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                  dataItem.content ?? "-",
                style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.middleGrey750, fontSize: 14, height: 1.1),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }
}


