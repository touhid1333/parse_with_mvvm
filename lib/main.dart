import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/dependencies/dependencies.dart' as di;
import 'package:parse_with_mvvm/screens/Filter/filter_view.dart';
import 'package:parse_with_mvvm/screens/dashboard/dashboard.dart';
import 'package:parse_with_mvvm/screens/login/login_view.dart';
import 'package:parse_with_mvvm/screens/not_found/not_found.dart';
import 'package:parse_with_mvvm/screens/signup/signup_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  di.initDev();

  final keyApplicationId = dotenv.env['PARSE_APPLICATION_ID'] ?? '';
  final keyClientKey = dotenv.env['PARSE_CLIENT_KEY'] ?? '';
  final keyParseServerUrl = dotenv.env['PARSE_SERVER_URL'] ?? '';
  final liveQueryUrl = dotenv.env['PARSE_LIVE_QUERY_URL'] ?? '';

  if (keyApplicationId.isNotEmpty &&
      keyClientKey.isNotEmpty &&
      keyParseServerUrl.isNotEmpty) {
    await Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      clientKey: keyClientKey,
      debug: true,
      autoSendSessionId: true,
      liveQueryUrl: liveQueryUrl.isNotEmpty ? liveQueryUrl : keyParseServerUrl,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Graphik',
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          onPrimary: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            // Home route
            if (routeSettings.name == LoginView.routeName) {
              return const LoginView();
            } else if (routeSettings.name == SignUpView.routeName) {
              return const SignUpView();
            } else if (routeSettings.name == Dashboard.routeName) {
              return const Dashboard();
            } else if(routeSettings.name == FilterView.routeName){
              return const FilterView();
            } else {
              return const NotFound();
            }
          },
        );
      },
    );
  }
}
