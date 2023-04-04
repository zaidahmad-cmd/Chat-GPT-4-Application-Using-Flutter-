
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../app/constants.dart';
import '../../data/model/chat_model.dart';
import '../../data/model/models_model.dart';
class ApiService {
  
  static Future<List<ModelsModel>> getModels() async {

    
    try {
      var response = await http.get(
        Uri.parse("${Constants.baseUrl}/models"),
        headers: {'Authorization': 'Bearer ${Constants.OPEN_AI_KEY}'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      print(temp[0]);
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      Map jsonResponse;
            List<ChatModel> chatList = [];

      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("${Constants.baseUrl}/completions"),
        headers: {
          'Authorization': 'Bearer ${Constants.OPEN_AI_KEY}',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
            'top_p': 1,
      'frequency_penalty': 0.6,
      'presence_penalty': 0.6,
          },
        ),
      ).then((value) async{
          jsonResponse = await jsonDecode(value.body);
      print(jsonResponse);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][0]["text"],
            chatIndex: 1,
          ),
        );

        if(message =='Hello' || message=='Hi'){
         chatList.clear();
         chatList.add((ChatModel(msg: 'Hello, How may I help you today', chatIndex: 1)));
        }
      }
      });
      return chatList;


    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
