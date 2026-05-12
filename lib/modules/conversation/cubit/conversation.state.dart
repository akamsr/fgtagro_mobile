import 'package:fgtagro_mobile/models/conversation.dart';
import 'package:fgtagro_mobile/models/message.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/global_app_state.dart';

class ConversationState extends GlobalAppState {
  final bool genLoading;
  final GlobalErrorData? genError;
  final bool showError;
  final List<ConversationModel> conversations;
  final List<MessageModel> messages;

  ConversationState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.conversations = const [],
    this.messages = const [],
  });

  ConversationState copyWith({
    bool? genLoading,
    GlobalErrorData? genError,
    bool? showError,
    List<ConversationModel>? conversations,
    List<MessageModel>? messages,
  }) {
    return ConversationState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError,
      showError: showError ?? this.showError,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get extraprops => [genLoading, genError, showError, conversations, messages];
}
