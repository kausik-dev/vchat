import 'package:dio/dio.dart';
import 'package:vchat/providers/auth_provider.dart';

class VChatApi {

  static const _baseUrl = "https://vizdale-vchat.herokuapp.com/";
  static const _apiKey = "losingmymind";
  static final _dio = Dio();

  const VChatApi();

  Future<UsernameState> validateUserName(String username) async {
    UsernameState usernameState = UsernameState.idle;

    try {
      // final Response res;
      final res = await _dio.post(
        _baseUrl + "validate_username",
        queryParameters: {"username": username},
        options: Options(
          headers: {"apikey": _apiKey},
        ),
      );

      if (res.statusCode == 200) {
        final parsedState = res.data.toString();
        if (parsedState == "true") {
          print(parsedState);
          usernameState = UsernameState.validated;
        } else {
          print(parsedState);
          usernameState = UsernameState.failed;
        }
      }
      return usernameState;
    } catch (err) {
      print("Some error occured with the validateUserName");
      usernameState = UsernameState.idle;
      return usernameState;
    }
  }
}
