import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/parse_user_model.dart';
import 'package:parse_with_mvvm/services/signup_services/signup_service.dart';

class ParseSignupService implements SignupService {
  @override
  Future<ParseResponse> signUp(ParseUserModel user) async {
    final ParseResponse response = await user.signUp();
    return response;
  }
}
