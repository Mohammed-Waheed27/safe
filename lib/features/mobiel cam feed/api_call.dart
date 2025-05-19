import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJiZDRmZWViNi1kYTg3LTQ0OGEtYTIxMi1kNTI0OWU0MWYwNWUiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc0NzYxNDYyMSwiZXhwIjoxNzQ4MjE5NDIxfQ.UrOamzG17VJV_OI0zRsNxIRe1nr1KN8_mKoMmQO6Smg";

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

  //Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}
