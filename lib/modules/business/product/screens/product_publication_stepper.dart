import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fgtagro_mobile/modules/business/product/widgets/publication_steps/photo_step.dart';
import 'package:fgtagro_mobile/modules/business/product/widgets/publication_steps/name_category_step.dart';
import 'package:fgtagro_mobile/modules/business/product/widgets/publication_steps/description_step.dart';
import 'package:fgtagro_mobile/modules/business/product/widgets/publication_steps/pricing_stock_step.dart';
import 'package:fgtagro_mobile/modules/business/product/widgets/publication_steps/stock_location_step.dart';
import 'package:fgtagro_mobile/modules/business/product/widgets/publication_steps/optional_details_step.dart';
import 'package:fgtagro_mobile/modules/business/product/widgets/publication_steps/preview_step.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

@RoutePage()
class ProductPublicationScreen extends StatefulWidget {
  const ProductPublicationScreen({super.key});

  @override
  State<ProductPublicationScreen> createState() =>
      _ProductPublicationScreenState();
}

class _ProductPublicationScreenState extends State<ProductPublicationScreen> {
  int _currentStep = 1;
  final int _totalSteps = 7;

  // Global State for the wizard
  final List<String> _photos = [];
  final TextEditingController _nameController = TextEditingController();
  final List<String> _categoryPath = [];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _unit = 'kg';
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _moqController = TextEditingController();
  String _locationOption = 'GIA_STORE'; // 'MY_ADDRESS'
  final Map<String, int> _storeQuantities = {};
  final Map<String, String> _optionalDetails = {};

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      if (_validateCurrentStep()) {
        setState(() => _currentStep++);
      }
    } else {
      _submitProduct();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        if (_photos.length < 2) {
          _showError('Please upload at least 2 photos.');
          return false;
        }
        return true;
      case 2:
        if (_nameController.text.isEmpty || _categoryPath.isEmpty) {
          _showError('Name and Category are required.');
          return false;
        }
        return true;
      case 3:
        if (_descriptionController.text.length < 500) {
          _showError('Description must be at least 500 characters.');
          return false;
        }
        return true;
      case 4:
        if (_priceController.text.isEmpty || _stockController.text.isEmpty) {
          _showError('Price and Stock are required.');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _submitProduct() {
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Product submitted for review ✓',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Our team will review your product within 24 hours. You will be notified by push notification and email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  CustomNavigate.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View my products'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).newProduct,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryColor),
          onPressed: () => CustomNavigate.back(),
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
          LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor,
            ),
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return PhotoStep(
          photos: _photos,
          onUpdate: (p) => setState(() => _photos.assignAll(p)),
        );
      case 2:
        return NameCategoryStep(
          nameController: _nameController,
          categoryPath: _categoryPath,
          onCategorySelect: (p) => setState(() => _categoryPath.assignAll(p)),
        );
      case 3:
        return DescriptionStep(controller: _descriptionController);
      case 4:
        return PricingStockStep(
          priceController: _priceController,
          stockController: _stockController,
          unit: _unit,
          moqController: _moqController,
          onUnitChange: (u) => setState(() => _unit = u),
        );
      case 5:
        return StockLocationStep(
          option: _locationOption,
          storeQuantities: _storeQuantities,
          targetTotal: int.tryParse(_stockController.text) ?? 0,
          onOptionChange: (o) => setState(() => _locationOption = o),
        );
      case 6:
        return OptionalDetailsStep(details: _optionalDetails);
      case 7:
        return PreviewStep(
          photos: _photos,
          name: _nameController.text,
          category: _categoryPath.join(' > '),
          price: _priceController.text,
          unit: _unit,
          stock: _stockController.text,
          description: _descriptionController.text,
          details: _optionalDetails,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomBar() {
    return Container(
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
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 1)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(S.of(context).back),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentStep == _totalSteps
                      ? S.of(context).submitForReview
                      : S.of(context).continueText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ListAssign<T> on List<T> {
  void assignAll(Iterable<T> iterable) {
    clear();
    addAll(iterable);
  }
}
