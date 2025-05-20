import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
String token = dotenv.env['main_token']!;

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse(dotenv.env['Api_Url']!),
    headers: {'Authorization': token},
  );

  //Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}

Future<void> createfeed_id(String roomId) async {
  await FirebaseFirestore.instance
      .collection("active_feeds")
      .doc('current_feed')
      .set({"roomId": roomId});
}

Future<void> deleteFeed() async {
  await FirebaseFirestore.instance
      .collection("active_feeds")
      .doc('current_feed')
      .delete();
}
