import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/chat_model.dart';
import '../../data/model/models_model.dart';
import 'api_services.dart';
import 'chat_states.dart';

// class ChatProvider with ChangeNotifier {
//   List<ChatModel> chatList = [];
//   List<ChatModel> get getChatList {
//     return chatList;
//   }

//   void addUserMessage({required String msg}) {
//     chatList.add(ChatModel(msg: msg, chatIndex: 0));
//     notifyListeners();
//   }

//   Future<void> sendMessageAndGetAnswers(
//       {required String msg, required String chosenModelId}) async {
//     chatList.addAll(await ApiService.sendMessage(
//       message: msg,
//       modelId: chosenModelId,
//     ));
//     notifyListeners();
//   }
// }
class ChatCubit extends Cubit<ChatStates>{


 ChatCubit():super(ChatBaseState());
  static ChatCubit get(context) => BlocProvider.of(context);

 List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

 void addUserMessage({required String msg}){

  chatList.add(ChatModel(msg: msg, chatIndex: 0));

  emit(ChatAddMessage());

 }


   Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
        emit(ChatLoadingState());
    chatList.addAll(await ApiService.sendMessage(
      message: msg,
      modelId: chosenModelId,
    ));
    emit(ChatLoadedState());
  }

    String currentModel = "text-davinci-003";
  String get getCurrentModel {
    return currentModel;
  }

  
  void setCurrentModel(String newModel) {
    currentModel = newModel;
    emit(SetModelState());
  }
List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }

}