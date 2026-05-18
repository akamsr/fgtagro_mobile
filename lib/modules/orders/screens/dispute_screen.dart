import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class DisputeScreen extends StatefulWidget {
  final String orderId;
  const DisputeScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 - Reason
  String? _selectedReason;

  // Step 2 - Description
  final TextEditingController _descController = TextEditingController();

  // Step 3 - Photos
  final List<File> _photos = [];
  final ImagePicker _picker = ImagePicker();

  // Step 4 - Review
  bool _confirmedAccurate = false;
  bool _isLoading = false;

  final List<String> _reasons = [
    'Product not received',
    'Product damaged on arrival',
    'Product does not match description',
    'Wrong product delivered',
    'Missing items in order',
    'Product expired or spoiled',
    'Other',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _pickPhoto() async {
    if (_photos.length >= 5) return;
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80, maxWidth: 1200);
    if (picked != null) {
      setState(() => _photos.add(File(picked.path)));
    }
  }

  bool get _canProceedStep1 => _selectedReason != null;
  bool get _canProceedStep2 => _descController.text.trim().length >= 50;
  bool get _canProceedStep3 => _photos.isNotEmpty;
  bool get _canSubmit => _confirmedAccurate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSystemCubit, OrderSystemState>(
      builder: (context, state) {
        final order = state.orders.firstWhere(
          (o) => o.id == widget.orderId,
          orElse: () => state.orders.first,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF9F7FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                _currentStep > 0 ? Icons.arrow_back : Icons.close,
                color: AppColors.secondaryColor,
              ),
              onPressed:
                  _currentStep > 0 ? _prevStep : () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Open a Dispute',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Step ${_currentStep + 1} of 4',
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                    _buildStep4(context, order),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(4, (i) {
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: i <= _currentStep
                        ? AppColors.primaryColor
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: i < _currentStep
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              color:
                                  i == _currentStep ? Colors.white : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (i < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i < _currentStep
                          ? AppColors.primaryColor
                          : Colors.grey.shade200,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Step 1 — Select reason
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is the issue with your order?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ..._reasons.map((reason) => GestureDetector(
                onTap: () => setState(() => _selectedReason = reason),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _selectedReason == reason
                        ? AppColors.primaryColor.withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedReason == reason
                          ? AppColors.primaryColor
                          : Colors.grey.shade200,
                      width: _selectedReason == reason ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          reason,
                          style: TextStyle(
                            fontWeight: _selectedReason == reason
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedReason == reason
                                ? AppColors.primaryColor
                                : AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      if (_selectedReason == reason)
                        const Icon(Icons.check_circle,
                            color: AppColors.primaryColor, size: 20),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 24),
          _buildNextButton('Next: Describe the issue', _canProceedStep1),
        ],
      ),
    );
  }

  // Step 2 — Description
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedReason ?? 'Describe your issue',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The more detail you provide, the faster we can resolve it.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _descController,
            maxLines: 6,
            maxLength: 1000,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText:
                  'Please describe the issue in detail. The more information you provide, the faster we can resolve it.',
              hintStyle: const TextStyle(fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _descController.text.trim().length < 50
                    ? 'Minimum 50 characters required'
                    : '✓ Good',
                style: TextStyle(
                  color: _descController.text.trim().length < 50
                      ? Colors.orange
                      : Colors.green,
                  fontSize: 11,
                ),
              ),
              Text(
                '${_descController.text.length}/1000',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildNextButton('Next: Upload evidence', _canProceedStep2),
        ],
      ),
    );
  }

  // Step 3 — Photo upload
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload evidence',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Photos of the product, packaging, or delivery condition (minimum 1, maximum 5, JPG/PNG, max 5MB each)',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              ..._photos.map((file) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(file,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _photos.remove(file)),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 12),
                          ),
                        ),
                      ),
                    ],
                  )),
              if (_photos.length < 5)
                GestureDetector(
                  onTap: _pickPhoto,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            color: Colors.grey.shade400, size: 28),
                        const SizedBox(height: 4),
                        Text(
                          'Add photo',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _buildNextButton(
              'Next: Review & submit', _canProceedStep3),
        ],
      ),
    );
  }

  // Step 4 — Review & submit
  Widget _buildStep4(BuildContext context, OrderModel order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review your dispute',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildReviewItem('Reason', _selectedReason ?? '—'),
          const SizedBox(height: 12),
          _buildReviewItem('Description',
              '${_descController.text.trim().length} characters'),
          const SizedBox(height: 12),
          _buildReviewItem('Evidence', '${_photos.length} photo(s) uploaded'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Once submitted, your payout to the seller will be suspended until this dispute is resolved.',
                    style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 12,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _confirmedAccurate,
                onChanged: (v) =>
                    setState(() => _confirmedAccurate = v ?? false),
                activeColor: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'I confirm this information is accurate and I am opening this dispute in good faith.',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _canSubmit && !_isLoading
                  ? () async {
                      setState(() => _isLoading = true);
                      await Future.delayed(const Duration(milliseconds: 1000));
                      if (!mounted) return;
                      context.read<OrderSystemCubit>().updateOrderStatus(
                            widget.orderId,
                            OrderStatus.refundRequested,
                          );
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Dispute submitted. Our team will review it within 72 hours.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Submit dispute',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  color: AppColors.secondaryColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(String label, bool enabled) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: enabled ? _nextStep : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}

// Delivery Confirmation Bottom Sheet
class DeliveryConfirmationSheet extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onConfirm;
  final VoidCallback onDispute;

  const DeliveryConfirmationSheet({
    Key? key,
    required this.order,
    required this.onConfirm,
    required this.onDispute,
  }) : super(key: key);

  @override
  State<DeliveryConfirmationSheet> createState() =>
      _DeliveryConfirmationSheetState();
}

class _DeliveryConfirmationSheetState
    extends State<DeliveryConfirmationSheet> {
  late final List<bool> _itemChecks;
  double _driverRating = 0;

  @override
  void initState() {
    super.initState();
    _itemChecks =
        List.generate(widget.order.items.length, (_) => false);
  }

  bool get _allChecked => _itemChecks.every((c) => c);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirm you received all your products in good condition?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(widget.order.items.length, (i) {
              final item = widget.order.items[i];
              return CheckboxListTile(
                value: _itemChecks[i],
                onChanged: (v) => setState(() => _itemChecks[i] = v ?? false),
                activeColor: AppColors.primaryColor,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${item.productName ?? "Product"} (${item.qty}× ${item.unit ?? ""})',
                  style: const TextStyle(fontSize: 13),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            const Divider(height: 24),
            const Text(
              'Rate your delivery driver (optional)',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
            ),
            const SizedBox(height: 12),
            RatingBar.builder(
              initialRating: _driverRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 36,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (r) => setState(() => _driverRating = r),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _allChecked ? widget.onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.green.shade200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Yes, I received my order ✓',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: widget.onDispute,
                child: const Text(
                  'No, there is a problem → Open a dispute',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
