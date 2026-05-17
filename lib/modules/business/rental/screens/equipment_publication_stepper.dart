import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/availability_step.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/conditions_step.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/documents_step.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/general_info_step.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/geographic_area_step.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/photos_step.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/pricing_step.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

@RoutePage()
class EquipmentPublicationScreen extends StatefulWidget {
  const EquipmentPublicationScreen({super.key});

  @override
  State<EquipmentPublicationScreen> createState() =>
      _EquipmentPublicationScreenState();
}

class _EquipmentPublicationScreenState
    extends State<EquipmentPublicationScreen> {
  int _currentStep = 1;
  final int _totalSteps = 7;
  final Map<String, dynamic> _formData = {
    'photoSlots': {},
    'additionalPhotos': [],
    'documents': {},
    'permittedUses': [],
    'unavailableDates': [],
  };

  void _updateData(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  void _submitForm() {
    // Implement submission logic
    CustomNavigate.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'List Equipment',
          style: TextStyle(
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
              padding: const EdgeInsets.all(24),
              child: _buildStepContent(),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return GeneralInfoStep(data: _formData, onUpdate: _updateData);
      case 2:
        return PhotosStep(data: _formData, onUpdate: _updateData);
      case 3:
        return DocumentsStep(data: _formData, onUpdate: _updateData);
      case 4:
        return PricingStep(data: _formData, onUpdate: _updateData);
      case 5:
        return AvailabilityStep(data: _formData, onUpdate: _updateData);
      case 6:
        return GeographicAreaStep(data: _formData, onUpdate: _updateData);
      case 7:
        return ConditionsStep(data: _formData, onUpdate: _updateData);
      default:
        return const Center(child: Text('Step Implementation Missing'));
    }
  }

  Widget _buildBottomNav() {
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
      child: Row(
        children: [
          if (_currentStep > 1)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(_currentStep == _totalSteps ? 'Submit' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
