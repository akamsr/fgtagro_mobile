import 'package:fgtagro_mobile/services/conversation/conversation.services.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
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
    } catch (e, s) {
      emit(
        state.copyWith(
          genLoading: false,
          genError: ErrorMapper.map(e, s),
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
    } catch (e, s) {
      emit(
        state.copyWith(
          genLoading: false,
          genError: ErrorMapper.map(e, s),
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
    } catch (e, s) {
      emit(state.copyWith(genError: ErrorMapper.map(e, s), showError: true));
    }
  }

  void hideError() {
    emit(state.copyWith(showError: false));
  }
}
