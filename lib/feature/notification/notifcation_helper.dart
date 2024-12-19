// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// // import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

// class NotificationService {
//   static Future<String> getAccessToken() async {
//     final Map<String, String> serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "news-app-478cb",
//       "private_key_id": "ac9f3c7932d976118e04ef30710b733a86b0011e",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCzfk6UASNGHgF9\nWJsRa3mwPnVQIYFiklYtoAfzbmpkhRUjBhUQwp3ZAtQ19NM3g/bWEz4epA2pRUzd\nuPutO/4q2kSYU4oaQtkjsZDcv1eIE7pK0V/c/ODWED1LJRBUQih/Evxm119wXp1i\n7TsjA6sBnvItTLMCJS36wG05nAvqoru2SV390hoaV9dFLH28kv5BjPM4RiRgRv3y\nI3aVAjxCJAfpx23XP5wxz5cW+O8au/E0XDc4ZjOcFOBDkTd5SJlm+MouedlwqLBP\nxhtoyh98n3syn0kIIcZVuzk7BS9ZERb6ifRGBJMe1WtliXRZADWg0F4hU83jlt9f\nBWk7DUP3AgMBAAECggEAEncN8l/jlxUDJjf1S+d4j079lo671r4jK3JpHvve6hRe\nxkmb5SuAPZDy79IN4Ios3H0CSPirhxxf+fdLvNiNHy9xGxKNBIKX//oGYw80HAWb\nhpLff8ZsAtmM1Kwtb92WeOwlFxdU9CRnoIOzL7jy4KnPVCWtzKyyfDdLhT+uYibL\nSTHLN9OQVgoLkr8wp7fZ0wHtXzYWVg8JcI/GirwEXrDViu1zbB3DLZPK6qsTIEs2\nGBt24oEyZ/JGcRUq26RrdNcUUmBQEPGc5DUzPXPMj2L0H6J6ekDNzA8w5xCGsUoO\n3dk/I/ZyIZtE/TB9E+nMRfMeepzpRBnuk7jdx3WoAQKBgQDrPqx25f/rywI2gvt6\nB303LZormiAfll4ihFhNoBdJ8xyG9+Rb1bmg6paSBhRcdKjGymFx3LVGdfc6Jkd8\nUFr61g3woWPzNaZwS64LBv2V0WlZAmokYC/0PIyzbAO18YdgON4DxD4Vf4bAVo7E\nLGUBENM/W3w/0aZ7GXpHm42t9wKBgQDDVGkrrtb1hT0dC5knSiPEsO37I5lQzQwJ\ninQWthe11QVeUw4KRrzDLqganbB8CsLN8VMhLEzgWOUiJt8caSBh/hn3MGmSCgnZ\nuqeddQx6940ud/MlPFy+s05huf3Wl5SkwwjHYGBr2ZPUICl1TdXmu0x2kmBoIvr/\nbxrVD6+aAQKBgHdIVU0IvOcEDkAz1G4BBCYJcoYvZaB+r4bTEq9xwL1Xj5yEb/98\n9N46dVTfzk0/PiFml1iT8DslL9IFfPP1Dtzn0zOzsimth5KjXUHsLoNcJw3iIo4F\nU+uFFFcaKxuDuAA7dZ/1TwG5o0s92LByTljm/ia/LdZyaPc8aPuMTZ/rAoGAIRwc\n27e+Xk3ghxzhMCTEHWI0ZN6q7WRkhvV+Kh9hs4PRbiS7+4f0FU3CVwil0tDsJoai\npbvhqCHJbVmTdjhnsdSlyB3ft06WTt7x7KHbpLhzqQ3SHFy4B+dTAQPLAGYfXzJk\nOY+fqIhwI4P0Ixs3h+31zx+O0fgj/cpyjO0kwgECgYEAlkTjvlsQNer3Yn4LtquB\nod+b3hIhoo8caeMxaNTSHDHBa54Mw7coBtRUfHr78NP6GmQwcoprhVF8g07NGd3i\ndf51qvgqo1DzExvBFZfVZfDMb/M4f2S2OD4CjIWH8E/DD/vfd1YJab3k06L+cG4w\nSoUdoyghN15BhdJHTUKFuQk=\n-----END PRIVATE KEY-----\n",
//       "client_email":
//           "blood-bank-notification@news-app-478cb.iam.gserviceaccount.com",
//       "client_id": "112409818638431778271",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/blood-bank-notification%40news-app-478cb.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };

//     List<String> scopes = [
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];
//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );
//     auth.AccessCredentials credentials =
//         await auth.obtainAccessCredentialsViaServiceAccount(
//             auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//             scopes,
//             client);
//     client.close();
//     return credentials.accessToken.data;
//   }

//   static Future<void> sendNotification(
//       String deviceToken, String title, String body) async {
//     final String accessToken = await getAccessToken();
//     String endpointFCM =
//         'https://fcm.googleapis.com/v1/projects/news-app-Blood-bank/messages:send';
//     final Map<String, dynamic> message = {
//       "message": {
//         "token": deviceToken,
//         "notification": {"title": title, "body": body},
//         "data": {
//           "route": "serviceScreen",
//         }
//       }
//     };

//     final http.Response response = await http.post(
//       Uri.parse(endpointFCM),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken'
//       },
//       body: jsonEncode(message),
//     );

//     if (response.statusCode == 200) {
//       log('Notification sent successfully');
//     } else {
//       log('Failed to send notification');
//     }
//   }
// }
