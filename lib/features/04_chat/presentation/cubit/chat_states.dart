

abstract class ChatStates{}

class ChatAddMessage extends ChatStates{}
class ChatBaseState extends ChatStates{}
class ChatLoadedState extends ChatStates{}

class ChatLoadingState extends ChatStates{}

class BaseModelStates extends ChatStates{}
class SetModelState extends ChatStates{}