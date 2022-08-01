
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/services/login_services/login_service.dart';

class ParseLoginService extends LoginService{
  @override
  Future<ParseResponse> loginWithEmail(userModel) async{
    ParseResponse response = await userModel.login();
    return response;
  }
}