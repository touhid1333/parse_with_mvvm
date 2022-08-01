
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/dependencies/dependencies.dart';
import 'package:parse_with_mvvm/models/parse_user_model.dart';
import 'package:parse_with_mvvm/screens/viewmodel.dart';
import 'package:parse_with_mvvm/services/login_services/login_service.dart';

class LoginViewmodel extends Viewmodel{

  LoginService get _service => dependency();

  Future<ParseResponse> userLogin(ParseUserModel userModel) async{
    turnIdle();
    ParseResponse response = await _service.loginWithEmail(userModel);
    turnBusy();
    return response;
  }
}