
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/dependencies/dependencies.dart';
import 'package:parse_with_mvvm/models/parse_user_model.dart';
import 'package:parse_with_mvvm/screens/viewmodel.dart';
import 'package:parse_with_mvvm/services/signup_services/signup_service.dart';

class SignUpViewModel extends Viewmodel{

  SignupService get _service => dependency();

  Future<ParseResponse> createUser(ParseUserModel user) async{
    turnBusy();
    ParseResponse response = await _service.signUp(user);
    turnIdle();
    return response;
  }
}