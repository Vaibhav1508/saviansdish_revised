import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/provider/rating/shop_rating_provider.dart';
import 'package:flutterrestaurant/provider/shop_info/shop_info_provider.dart';
import 'package:flutterrestaurant/repository/shop_rating_repository.dart';
import 'package:flutterrestaurant/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterrestaurant/ui/common/ps_button_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_textfield_widget.dart';
import 'package:flutterrestaurant/ui/common/smooth_star_rating_widget.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/viewobject/holder/shop_rating_holder.dart';
import 'package:provider/provider.dart';

class ShopRatingInputDialog extends StatefulWidget {
  const ShopRatingInputDialog({
    Key key,
    @required this.shopInfoProvider,
  }) : super(key: key);

  final ShopInfoProvider shopInfoProvider;
  @override
  _ShopRatingInputDialogState createState() => _ShopRatingInputDialogState();
}

class _ShopRatingInputDialogState extends State<ShopRatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShopRatingRepository shopRatingRepo =
        Provider.of<ShopRatingRepository>(context);

    final Widget _headerWidget = Container(
        height: PsDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: PsColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: PsDimens.space12),
            Icon(
              Icons.rate_review,
              color: PsColors.white,
            ),
            const SizedBox(width: PsDimens.space8),
            Text(
              Utils.getString(context, 'rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PsColors.white,
              ),
            ),
          ],
        ));
    return ChangeNotifierProvider<ShopRatingProvider>(
        lazy: false,
        create: (BuildContext context) {
          final ShopRatingProvider provider =
              ShopRatingProvider(repo: shopRatingRepo);

          provider
              .loadShopRatingList(widget.shopInfoProvider.psValueHolder.shopId);

          return provider;
        },
        child: Consumer<ShopRatingProvider>(builder:
            (BuildContext context, ShopRatingProvider provider, Widget child) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _headerWidget,
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        Utils.getString(context, 'rating_entry__your_rating'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(),
                      ),
                      if (rating == null)
                        SmoothStarRating(
                            allowHalfRating: false,
                            rating: 0.0,
                            starCount: 5,
                            size: PsDimens.space24,
                            color: PsColors.ratingColor,
                            onRated: (double rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0)
                      else
                        SmoothStarRating(
                            allowHalfRating: false,
                            rating: rating,
                            starCount: 5,
                            size: PsDimens.space24,
                            color: PsColors.ratingColor,
                            onRated: (double rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0),
                      PsTextFieldWidget(
                          titleText:
                              Utils.getString(context, 'rating_entry__title'),
                          hintText:
                              Utils.getString(context, 'rating_entry__title'),
                          textEditingController: titleController),
                      PsTextFieldWidget(
                          height: PsDimens.space120,
                          titleText:
                              Utils.getString(context, 'rating_entry__message'),
                          hintText:
                              Utils.getString(context, 'rating_entry__message'),
                          textEditingController: descriptionController),
                      const Divider(
                        height: 0.5,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      _ButtonWidget(
                        descriptionController: descriptionController,
                        provider: provider,
                        productProvider: widget.shopInfoProvider,
                        titleController: titleController,
                        rating: rating,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget({
    Key key,
    @required this.titleController,
    @required this.descriptionController,
    @required this.provider,
    @required this.productProvider,
    @required this.rating,
  }) : super(key: key);

  final TextEditingController titleController, descriptionController;
  final ShopRatingProvider provider;
  final ShopInfoProvider productProvider;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: false,
                colorData: PsColors.grey,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__submit'),
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      rating != null &&
                      rating.toString() != '0.0') {
                    // if(flag == PsConst.PRODUCT_RATING){
                    //   final RatingParameterHolder productRatingParameterHolder =
                    //     RatingParameterHolder(
                    //   userId: productProvider.psValueHolder.loginUserId,
                    //   productId: productProvider.productDetail.data.id,
                    //   title: titleController.text,
                    //   description: descriptionController.text,
                    //   rating: rating.toString(),
                    //   shopId: productProvider.psValueHolder.shopId
                    //   );
                    //   await provider
                    //     .postRating(productRatingParameterHolder.toMap());
                    // }else{
                    final ShopRatingParameterHolder shopRatingParameterHolder =
                        ShopRatingParameterHolder(
                            userId: productProvider.psValueHolder.loginUserId,
                            title: titleController.text,
                            description: descriptionController.text,
                            rating: rating.toString(),
                            shopId: productProvider.psValueHolder.shopId);
                    await provider
                        .postShopRating(shopRatingParameterHolder.toMap());

                    Navigator.pop(context);
                  } else {
                    print('There is no comment');

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message:
                                Utils.getString(context, 'rating_entry__error'),
                            onPressed: () {},
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
