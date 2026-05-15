import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProductPublicationScreen extends StatefulWidget {
  const ProductPublicationScreen({super.key});

  @override
  State<ProductPublicationScreen> createState() => _ProductPublicationScreenState();
}

class _ProductPublicationScreenState extends State<ProductPublicationScreen> {
  int _currentStep = 1;
  final int _totalSteps = 7;

  // Form Data
  final List<String> _photos = [];
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _unit = 'kg';
  final TextEditingController _stockController = TextEditingController();

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Product',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryColor),
          onPressed: () => context.router.pop(),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Step $_currentStep of $_totalSteps',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            minHeight: 4,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(),
            ),
          ),
          
          // Bottom Navigation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 1) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(_currentStep == _totalSteps ? 'Submit' : 'Continue'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildPhotoStep();
      case 2:
        return _buildNameCategoryStep();
      case 3:
        return _buildDescriptionStep();
      case 4:
        return _buildPricingStep();
      case 5:
        return _buildLocationStep();
      case 6:
        return _buildOptionalDetailsStep();
      case 7:
        return _buildPreviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPhotoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload between 2 and 5 high-quality photos of your product.',
          style: TextStyle(color: Colors.grey, height: 1.4),
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            final hasPhoto = index < _photos.length;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasPhoto ? AppColors.primaryColor : Colors.grey.shade200,
                  width: hasPhoto ? 2 : 1,
                ),
              ),
              child: hasPhoto
                  ? const Center(child: Icon(Icons.image, size: 40, color: AppColors.primaryColor))
                  : const Center(child: Icon(Icons.add_a_photo_outlined, color: Colors.grey)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNameCategoryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name & Category',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 32),
        const Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'e.g. Organic NPK Fertilizer',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedCategory ?? 'Select category', style: TextStyle(color: _selectedCategory == null ? Colors.grey : Colors.black)),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _descriptionController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: 'Describe your product in detail...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: '${_descriptionController.text.length} / 2000',
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Minimum 500 characters required.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPricingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing & Stock',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 32),
        const Text('Price (FCFA)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryTint.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'FGT AGRO commission: 5%. You will receive 95,000 FCFA for a 100,000 FCFA sale.',
            style: TextStyle(fontSize: 12, color: AppColors.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Stock Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stock Location',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 8),
        const Text(
          'Where is this product currently stored?',
          style: TextStyle(color: Colors.grey, height: 1.4),
        ),
        const SizedBox(height: 32),
        _buildLocationOption(
          title: 'Existing Store',
          subtitle: 'Select from your registered warehouses',
          icon: Icons.storefront,
          isSelected: true,
        ),
        const SizedBox(height: 16),
        _buildLocationOption(
          title: 'Specific Address',
          subtitle: 'Enter a custom location for this batch',
          icon: Icons.location_on_outlined,
          isSelected: false,
        ),
      ],
    );
  }

  Widget _buildLocationOption({required String title, required String subtitle, required IconData icon, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryTint.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.grey.shade200, width: isSelected ? 2 : 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primaryColor : Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryColor),
        ],
      ),
    );
  }

  Widget _buildOptionalDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Optional Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 32),
        _buildFieldLabel('Variety / Type'),
        TextField(decoration: InputDecoration(hintText: 'e.g. Yellow Maize', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 24),
        _buildFieldLabel('Harvest Date'),
        TextField(decoration: InputDecoration(hintText: 'Select date', suffixIcon: const Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 24),
        _buildFieldLabel('Certifications'),
        Wrap(
          spacing: 8,
          children: ['Organic', 'ISO 9001', 'Fair Trade'].map((c) => Chip(label: Text(c))).toList(),
        ),
      ],
    );
  }

  Widget _buildPreviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preview',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.image, size: 48, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Text(_nameController.text.isEmpty ? 'Product Name' : _nameController.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('${_priceController.text} FCFA / $_unit', style: const TextStyle(fontSize: 18, color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        _buildPreviewItem('Category', _selectedCategory ?? 'Not selected'),
        _buildPreviewItem('Stock', '${_stockController.text} units'),
        _buildPreviewItem('Location', 'Main Warehouse, Douala'),
        const SizedBox(height: 24),
        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(_descriptionController.text, style: const TextStyle(color: Colors.grey, height: 1.4)),
      ],
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
