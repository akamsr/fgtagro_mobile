import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class DescriptionStep extends StatefulWidget {
  final TextEditingController controller;

  const DescriptionStep({super.key, required this.controller});

  @override
  State<DescriptionStep> createState() => _DescriptionStepState();
}

class _DescriptionStepState extends State<DescriptionStep> {
  bool _hasRestrictedInfo = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateContent);
  }

  void _validateContent() {
    final text = widget.controller.text;
    final phoneRegex = RegExp(r'\b\d{8,}\b');
    final emailRegex = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,}\b');
    final urlRegex = RegExp(r'\b(?:http|https|www)\b');

    setState(() {
      _hasRestrictedInfo = phoneRegex.hasMatch(text) || emailRegex.hasMatch(text) || urlRegex.hasMatch(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.controller.text.length;
    final bool isTooShort = length < 500 && length > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Description',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: widget.controller,
          maxLines: 12,
          maxLength: 2000,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Describe your product in detail — variety, quality, origin, how it was produced, recommended use, storage conditions...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: '',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _hasRestrictedInfo ? Colors.red : AppColors.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isTooShort ? 'Minimum 500 characters required' : 'Maximum 2000 characters',
              style: TextStyle(fontSize: 11, color: isTooShort ? Colors.red : Colors.grey),
            ),
            Text('$length / 2000', style: TextStyle(fontSize: 11, color: isTooShort ? Colors.red : Colors.grey)),
          ],
        ),
        if (_hasRestrictedInfo)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Direct contact information (phone, email, URLs) is not allowed in descriptions.',
                    style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
