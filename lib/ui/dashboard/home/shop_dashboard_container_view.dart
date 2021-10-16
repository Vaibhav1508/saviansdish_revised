import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/constant/route_paths.dart';
import 'package:flutterrestaurant/provider/user/user_provider.dart';
import 'package:flutterrestaurant/repository/user_repository.dart';
import 'package:flutterrestaurant/ui/dashboard/home/shop_dashboard_view.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/viewobject/holder/intent_holder/blog_intent_holder.dart';
import 'package:provider/provider.dart';

class ShopDashboardContainerView extends StatefulWidget {
  const ShopDashboardContainerView(
      {@required this.shopId, @required this.shopName});
  final String shopId;
  final String shopName;

  @override
  _CityShopDashboardContainerViewState createState() =>
      _CityShopDashboardContainerViewState();
}

class _CityShopDashboardContainerViewState
    extends State<ShopDashboardContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  UserRepository userRepo;

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

    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);

    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: PsColors.mainColor,
              brightness: Utils.getBrightnessForAppBar(context),
              iconTheme:
                  Theme.of(context).iconTheme.copyWith(color: PsColors.white),
              title: Text(
                widget.shopName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, color: PsColors.white),
              ),
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Feather.book_open),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.blogList,
                        arguments: BlogIntentHolder(
                            noBlogListForShop: false, shopId: widget.shopId));
                  },
                )
              ],
            ),
            body: ShopDashboardView(
                shopId: widget.shopId, shopName: widget.shopName)));
  }
}
