import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/viewobject/shop.dart';

class ReservationShopListItem extends StatelessWidget {
  const ReservationShopListItem(
      {Key key,
      @required this.shop,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Shop shop;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();

    return AnimatedBuilder(
      animation: animationController,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: PsColors.backgroundColor,
          height: PsDimens.space52,
          margin: const EdgeInsets.only(top: PsDimens.space4),
          child: Padding(
              padding: const EdgeInsets.all(PsDimens.space16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        shop.name,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
      builder: (BuildContext contenxt, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: child,
          ),
        );
      },
    );
  }
}
