import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/conversation/cubit/conversation.cubit.dart';
import 'package:fgtagro_mobile/modules/conversation/cubit/conversation.state.dart';
import 'package:fgtagro_mobile/modules/conversation/widgets/chat_input_bar.dart';
import 'package:fgtagro_mobile/modules/conversation/widgets/date_header.dart';
import 'package:fgtagro_mobile/modules/conversation/widgets/message_bubble.dart';
import 'package:fgtagro_mobile/modules/conversation/widgets/product_preview.dart';
import 'package:fgtagro_mobile/models/message.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ConversationDetailScreen extends StatefulWidget {
  final String id;

  const ConversationDetailScreen({Key? key, @PathParam('id') required this.id})
    : super(key: key);

  @override
  State<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ConversationCubit>().fetchMessages(widget.id);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_msgController.text.trim().isNotEmpty) {
      context.read<ConversationCubit>().sendMessage(widget.id, _msgController.text.trim());
      _msgController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationCubit, ConversationState>(
      listener: (context, state) {
        if (state.messages.isNotEmpty) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        final conversation = state.conversations.firstWhere(
          (c) => c.id == widget.id,
          orElse: () => state.conversations.isNotEmpty ? state.conversations.first : (null as dynamic),
        );

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color.fromRGBO(36, 44, 88, 0.08)),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.secondaryColor,
                      ),
                      onPressed: () => context.router.pop(),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: conversation?.avatar != null ? NetworkImage(conversation!.avatar!) : null,
                                backgroundColor: const Color.fromRGBO(36, 44, 88, 0.1),
                                child: conversation?.avatar == null ? Text(
                                  conversation?.name?[0] ?? '?',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.secondaryColor),
                                ) : null,
                              ),
                              if (conversation?.isOnline == true)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 11,
                                    height: 11,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                conversation?.name ?? 'Chargement...',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondaryColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              if (conversation?.isOnline == true)
                                const Text(
                                  'EN LIGNE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.call_outlined, color: AppColors.secondaryColor),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: state.genLoading && state.messages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final item = state.messages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildMsgItem(item),
                            );
                          },
                        ),
                ),
                ChatInputBar(
                  controller: _msgController,
                  onSend: _sendMessage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMsgItem(MessageModel item) {
    if (item.type == MessageType.date) {
      return DateHeader(label: item.label ?? '');
    }
    if (item.type == MessageType.product) {
      return ProductPreview(item: item);
    }
    return MessageBubble(item: item);
  }
}
