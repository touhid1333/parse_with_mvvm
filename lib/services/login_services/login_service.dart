
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/parse_user_model.dart';

abstract class LoginService{
  //abstract login method
  Future<ParseResponse>  loginWithEmail(ParseUserModel userModel);
}