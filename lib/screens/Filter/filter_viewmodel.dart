
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/dependencies/dependencies.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';
import 'package:parse_with_mvvm/screens/viewmodel.dart';
import 'package:parse_with_mvvm/services/filterServices/filter_service.dart';
import 'package:parse_with_mvvm/services/filterServices/parse_filter_service.dart';

class FilterViewModel extends Viewmodel{

  FilterService get _service => dependency();

  List<FavGamesModel> filteredList = [];

  getFilteredList(String startDate, String endDate) async{
    ParseUser currentUser = await _service.getUser();
    if(currentUser != null){
      turnBusy();
      filteredList = await _service.filterFavGameByDate(currentUser, startDate, endDate);
      debugPrint("____________________________ ALL _________________");
      debugPrint(filteredList.toString());
      debugPrint("____________________________ End _________________");
      turnIdle();
    }
  }
}