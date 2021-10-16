import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/provider/shop/shop_provider.dart';
import 'package:flutterrestaurant/repository/shop_repository.dart';
import 'package:flutterrestaurant/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterrestaurant/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_ui_widget.dart';
import 'package:flutterrestaurant/ui/reservation/item/reservation_shop_list_item.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/viewobject/holder/shop_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ReservationShopListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReservationShopViewState();
  }
}

class _ReservationShopViewState extends State<ReservationShopListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ShopProvider shopProvider;
  AnimationController animationController;
  Animation<double> animation;
  final ShopParameterHolder shopParameterHolder = ShopParameterHolder();

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        shopProvider.nextShopListByKey(shopParameterHolder);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  ShopRepository repo1;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    repo1 = Provider.of<ShopRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<ShopProvider>(
            appBarTitle:
                Utils.getString(context, 'reservation_shop_list') ?? '',
            initProvider: () {
              return ShopProvider(repo: repo1, psValueHolder: psValueHolder);
            },
            onProviderReady: (ShopProvider provider) {
              provider.loadShopListByKey(shopParameterHolder);
              shopProvider = provider;
              return shopProvider;
            },
            builder:
                (BuildContext context, ShopProvider provider, Widget child) {
              if (provider.shop == null ||
                  provider.shop.data == null ||
                  provider.shop.data.isEmpty) {
                return Container();
              }

              return Stack(children: <Widget>[
                Container(
                    child: RefreshIndicator(
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: provider.shop.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (provider.shop.status == PsStatus.BLOCK_LOADING) {
                          return Shimmer.fromColors(
                              baseColor: PsColors.grey,
                              highlightColor: PsColors.white,
                              child: Column(children: const <Widget>[
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                              ]));
                        } else {
                          final int count = provider.shop.data.length;
                          return FadeTransition(
                              opacity: animation,
                              child: ReservationShopListItem(
                                animationController: animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                shop: provider.shop.data[index],
                                onTap: () {
                                  Navigator.pop(
                                      context, provider.shop.data[index]);
                                },
                              ));
                        }
                      }),
                  onRefresh: () {
                    return provider.resetShopList(shopParameterHolder);
                  },
                )),
                PSProgressIndicator(provider.shop.status)
              ]);
            }));
  }
}
