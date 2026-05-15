import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EquipmentPublicationScreen extends StatefulWidget {
  const EquipmentPublicationScreen({super.key});

  @override
  State<EquipmentPublicationScreen> createState() => _EquipmentPublicationScreenState();
}

class _EquipmentPublicationScreenState extends State<EquipmentPublicationScreen> {
  int _currentStep = 1;
  final int _totalSteps = 7;

  void _nextStep() => setState(() => _currentStep < _totalSteps ? _currentStep++ : null);
  void _prevStep() => setState(() => _currentStep > 1 ? _currentStep-- : null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Equipment', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: AppColors.secondaryColor), onPressed: () => context.router.pop()),
        actions: [Center(child: Padding(padding: const EdgeInsets.only(right: 16), child: Text('Step $_currentStep of $_totalSteps', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))))],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: _currentStep / _totalSteps, backgroundColor: Colors.grey.shade100, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor), minHeight: 4),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _buildStepContent())),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1: return _buildPhotoStep();
      case 2: return _buildBasicInfoStep();
      case 3: return _buildDocumentStep();
      case 4: return _buildPricingStep();
      case 5: return _buildLocationStep();
      case 6: return _buildAvailabilityStep();
      case 7: return _buildReviewStep();
      default: return Center(child: Text('Step $_currentStep Implementation'));
    }
  }

  Widget _buildAvailabilityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Availability & Rules', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Set when your equipment is available and who can rent it.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 32),
        const Text('Working Days', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) => FilterChip(
            label: Text(day),
            selected: true,
            onSelected: (v) {},
            selectedColor: AppColors.primaryTint.withOpacity(0.2),
            labelStyle: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          )).toList(),
        ),
        const SizedBox(height: 32),
        const Text('Operational Rules', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildCheckbox('Operator included in rental'),
        _buildCheckbox('Fuel provided by owner'),
        _buildCheckbox('Daily maintenance included'),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review & Publish', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Review your equipment details before submitting.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildReviewRow('Manufacturer', 'John Deere'),
              _buildReviewRow('Model', '5050E'),
              _buildReviewRow('Daily Rate', '45,000 FCFA'),
              _buildReviewRow('Radius', '50 km'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildCheckbox('I agree to the FGT AGRO Rental Terms & Conditions'),
        _buildCheckbox('I confirm that all documents are valid and genuine'),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(value: true, onChanged: (v) {}, activeColor: AppColors.primaryColor),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildPhotoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Vehicle Photos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Upload clear photos of all sides, dashboard, and engine.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 32),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(4, (i) => Container(
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: const Center(child: Icon(Icons.add_a_photo_outlined, color: Colors.grey)),
          )),
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Basic Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        _buildTextField('Manufacturer', 'e.g. John Deere'),
        const SizedBox(height: 16),
        _buildTextField('Model', 'e.g. 5050E'),
        const SizedBox(height: 16),
        _buildTextField('Year', 'e.g. 2023'),
      ],
    );
  }

  Widget _buildDocumentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Required Documents', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        _buildDocUploadTile('Insurance Policy', 'Upload PDF or JPG'),
        const SizedBox(height: 16),
        _buildDocUploadTile('Registration Document', 'Upload PDF or JPG'),
      ],
    );
  }

  Widget _buildPricingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rental Pricing', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(child: _buildTextField('Hourly Rate', 'FCFA')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Daily Rate', 'FCFA')),
          ],
        ),
        const SizedBox(height: 24),
        _buildTextField('Security Deposit', 'FCFA'),
        const SizedBox(height: 12),
        const Text('Note: Deposit is held by FGT AGRO and released after inspection.', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Base Location', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: const Center(child: Text('Map Integration Placeholder')),
        ),
        const SizedBox(height: 24),
        _buildTextField('Operation Radius', 'e.g. 50 km'),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
    ]);
  }

  Widget _buildDocUploadTile(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        const Icon(Icons.description_outlined, color: AppColors.primaryColor),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ])),
        const Icon(Icons.upload_file_outlined, color: Colors.grey),
      ]),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
      child: Row(children: [
        if (_currentStep > 1) Expanded(child: OutlinedButton(onPressed: _prevStep, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Back'))),
        if (_currentStep > 1) const SizedBox(width: 16),
        Expanded(child: ElevatedButton(onPressed: _nextStep, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: Text(_currentStep == _totalSteps ? 'Submit' : 'Continue'))),
      ]),
    );
  }
}
