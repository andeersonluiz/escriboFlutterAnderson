import 'package:escribo_flutter_anderson/src/core/constants/Strings.dart';
import 'package:escribo_flutter_anderson/src/core/exceptions/no_connection_exception.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionVerifyer implements Exception {
  static Future<bool> verify() async {
    bool connectionStatus = await InternetConnectionChecker().hasConnection;
    if (!connectionStatus) {
      return throw NoConnectionException(message: Strings.noConnection);
    }
    return true;
  }
}
