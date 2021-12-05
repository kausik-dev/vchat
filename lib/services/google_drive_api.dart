import 'dart:io';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:vchat/services/secure_storage.dart';

const _clientId = "882889655616-c4t69od5jakag68c0lq9frp40a67o8ul.apps.googleusercontent.com";
const _clientSecret = "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";
const _scopes = [ga.DriveApi.driveFileScope];

class GoogleDrive {
  final storage = SecureStorage();
  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
        ClientId(_clientId, _clientSecret),
        _scopes,
        (url) {
          //Open Url in Browser
          launch(url);
        },
      );
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken!);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return authenticatedClient(
        http.Client(),
        AccessCredentials(
            AccessToken(
              credentials["type"],
              credentials["data"],
              DateTime.tryParse(credentials["expiry"])!,
            ),
            credentials["refreshToken"],
            _scopes),
      );
    }
  }

  //Upload File
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    print("Uploading file");
    var response = await drive.files.create(
      ga.File()..name = p.basename(file.absolute.path),
      uploadMedia: ga.Media(
        file.openRead(),
        file.lengthSync(),
      ),
    );

    print("Result ${response.toJson()}");
  }
}
