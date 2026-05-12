import 'package:fgtagro_mobile/services/conversation/conversation.services.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/global_app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'conversation.state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ConversationService _conversationService = ConversationService();

  ConversationCubit() : super(ConversationState());

  Future<void> fetchConversations() async {
    emit(state.copyWith(genLoading: true, genError: null, showError: false));
    try {
      final conversations = await _conversationService.getConversations();
      emit(state.copyWith(genLoading: false, conversations: conversations));
    } catch (e) {
      emit(
        state.copyWith(
          genLoading: false,
          genError: GlobalErrorData(e),
          showError: true,
        ),
      );
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    emit(state.copyWith(genLoading: true, genError: null, showError: false));
    try {
      final messages = await _conversationService.getMessages(conversationId);
      emit(state.copyWith(genLoading: false, messages: messages));
    } catch (e) {
      emit(
        state.copyWith(
          genLoading: false,
          genError: GlobalErrorData(e),
          showError: true,
        ),
      );
    }
  }

  Future<void> sendMessage(String conversationId, String content) async {
    try {
      final newMessage = await _conversationService.sendMessage(
        conversationId,
        content,
      );
      emit(state.copyWith(messages: [...state.messages, newMessage]));
    } catch (e) {
      emit(state.copyWith(genError: GlobalErrorData(e), showError: true));
    }
  }

  void hideError() {
    emit(state.copyWith(showError: false));
  }
}
