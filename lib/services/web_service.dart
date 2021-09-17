import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_app/models/Content.dart';
class WebService {

  Future<Content> fetchPost() async {
    Content content = new Content();
    Config config = new Config();
    Lessons lessons = new Lessons();
    Categories categories = new Categories();
    try {
      final response =
      await http.get('http://surgalt.gov.mn/json');
      print(response);
      if (response.statusCode == 200) {
        // print(' fetchpost success--${response}' );
        Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
        // print('map---${map}');
        content.fromJson(map);
        // print('content.from-- ${content}');
        return content;
      } else {
        // print(' fetchpost status-error--${response}' );
        return null;
      }
    }
    catch (e) {
      // print(' fetchpost error--${e}' );
      return null;
    }
  }


}