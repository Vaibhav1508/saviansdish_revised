import 'dart:async';
import 'package:flutterrestaurant/repository/create_reservation_repository.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';

import '../../viewobject/common/ps_value_holder.dart';

class CreateReservationProvider extends PsProvider {
  CreateReservationProvider(
      {@required ReservationRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Reservation Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ReservationRepository _repo;
  PsValueHolder psValueHolder;
  String reservationDate;
  String reservationTime;
  String selectedShopId;
  String selectedShopName;
  PsResource<ApiStatus> _reservation =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _reservation;

  @override
  void dispose() {
    isDispose = true;
    print('Reservation Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postReservation(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _reservation = await _repo.postReservation(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _reservation;
  }
}
