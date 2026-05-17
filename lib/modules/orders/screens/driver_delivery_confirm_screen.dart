import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class DriverDeliveryConfirmScreen extends StatefulWidget {
  final String orderId;
  const DriverDeliveryConfirmScreen({Key? key, required this.orderId})
    : super(key: key);

  @override
  State<DriverDeliveryConfirmScreen> createState() =>
      _DriverDeliveryConfirmScreenState();
}

class _DriverDeliveryConfirmScreenState
    extends State<DriverDeliveryConfirmScreen> {
  int _step = 0;

  final TextEditingController _qrController = TextEditingController();
  bool _qrScanned = false;
  bool _showManualEntry = false;

  final List<Offset?> _signaturePoints = [];
  bool _signatureConfirmed = false;

  File? _deliveryPhoto;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  bool get _canSubmit =>
      (_qrScanned || _qrController.text.length >= 4) &&
      _signatureConfirmed &&
      _deliveryPhoto != null;

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  void _simulateQrScan() {
    setState(() {
      _qrScanned = true;
      _step = 1;
    });
  }

  Future<void> _pickDeliveryPhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _deliveryPhoto = File(picked.path));
    }
  }

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
                _step > 0 ? Icons.arrow_back : Icons.close,
                color: AppColors.secondaryColor,
              ),
              onPressed: _step > 0
                  ? () => setState(() => _step--)
                  : () => Navigator.pop(context),
            ),
            title: Text(
              [
                'Scan Customer QR',
                'Capture Signature',
                'Proof of Delivery',
              ][_step],
              style: const TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: _step == 0
                    ? _buildQrStep()
                    : _step == 1
                    ? _buildSignatureStep()
                    : _buildPhotoStep(context, order),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['QR Scan', 'Signature', 'Photo'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(3, (i) {
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: i <= _step
                        ? AppColors.primaryColor
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: i < _step
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: i == _step ? Colors.white : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 4),
                if (i < 2)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 2,
                          color: i < _step
                              ? AppColors.primaryColor
                              : Colors.grey.shade200,
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    steps[i],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─── Step 1: QR Scan ───────────────────────────────────────────
  Widget _buildQrStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 80,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _buildCorner(Alignment.topLeft),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _buildCorner(Alignment.topRight),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: _buildCorner(Alignment.bottomLeft),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: _buildCorner(Alignment.bottomRight),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text(
                'Scan QR Code',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              onPressed: _simulateQrScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                setState(() => _showManualEntry = !_showManualEntry),
            child: Text(
              _showManualEntry ? 'Hide manual entry' : 'Enter code manually',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          if (_showManualEntry) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _qrController,
              maxLength: 8,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
              decoration: InputDecoration(
                hintText: 'FGT-XXXX',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                counterText: '',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _qrController.text.length >= 4
                    ? () => setState(() => _step = 1)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          if (_qrScanned)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    'QR code verified ✓',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: alignment == Alignment.topLeft || alignment == Alignment.topRight
              ? const BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
          bottom:
              alignment == Alignment.bottomLeft ||
                  alignment == Alignment.bottomRight
              ? const BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
          left:
              alignment == Alignment.topLeft ||
                  alignment == Alignment.bottomLeft
              ? const BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
          right:
              alignment == Alignment.topRight ||
                  alignment == Alignment.bottomRight
              ? const BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }

  // ─── Step 2: Signature Canvas ───────────────────────────────────
  Widget _buildSignatureStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ask the customer to sign below',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The customer should draw their signature with their finger.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _signaturePoints.isEmpty
                    ? Colors.grey.shade300
                    : AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onPanUpdate: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  setState(() => _signaturePoints.add(details.localPosition));
                },
                onPanEnd: (_) => setState(() => _signaturePoints.add(null)),
                child: CustomPaint(
                  painter: _SignaturePainter(_signaturePoints),
                  child: _signaturePoints.isEmpty
                      ? const Center(
                          child: Text(
                            'Draw signature here',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _signaturePoints.clear();
                    _signatureConfirmed = false;
                  }),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _signaturePoints.isNotEmpty && !_signatureConfirmed
                      ? () => setState(() {
                          _signatureConfirmed = true;
                          _step = 2;
                        })
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirm signature',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Step 3: Proof-of-delivery photo ───────────────────────────
  Widget _buildPhotoStep(BuildContext context, OrderModel order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Take proof-of-delivery photo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a photo of the delivered package at the buyer\'s door.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickDeliveryPhoto,
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _deliveryPhoto != null
                      ? Colors.green
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: _deliveryPhoto != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _deliveryPhoto!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => setState(() => _deliveryPhoto = null),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                'Retake',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey.shade400,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap to take photo',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.my_location, color: Colors.blue, size: 16),
              const SizedBox(width: 6),
              Text(
                'GPS: 4.051056, 9.767890 (captured)',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _deliveryPhoto != null && !_isLoading
                  ? () async {
                      setState(() => _isLoading = true);
                      await Future.delayed(const Duration(milliseconds: 1200));
                      if (!mounted) return;
                      context.read<OrderSystemCubit>().updateOrderStatus(
                        widget.orderId,
                        OrderStatus.delivered,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Order ${order.orderNumber} marked DELIVERED! Payout scheduled.',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.green.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    )
                  : const Text(
                      'Confirm Delivery ✓',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom signature painter
class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondaryColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}
