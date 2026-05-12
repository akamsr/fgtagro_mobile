import 'package:fgtagro_mobile/models/message.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel item;

  const MessageBubble({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isBuyer = item.role == MessageRole.buyer;
    return Align(
      alignment: isBuyer ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: isBuyer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isBuyer ? AppColors.secondaryColor : Colors.white,
                border: isBuyer ? null : Border.all(color: const Color.fromRGBO(36, 44, 88, 0.07)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isBuyer ? 20 : 4),
                  bottomRight: Radius.circular(isBuyer ? 4 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.image != null && item.type == MessageType.msg)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(item.image!, width: 220, height: 220, fit: BoxFit.cover),
                      ),
                    ),
                  Text(
                    item.content ?? '',
                    style: TextStyle(fontSize: 14, height: 1.4, color: isBuyer ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.time ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                if (isBuyer && (item.isRead == true)) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 14, color: AppColors.primaryColor),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
