import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/equipment.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BuyerBookingFlowScreen extends StatefulWidget {
  final EquipmentModel equipment;

  const BuyerBookingFlowScreen({super.key, required this.equipment});

  @override
  State<BuyerBookingFlowScreen> createState() => _BuyerBookingFlowScreenState();
}

class _BuyerBookingFlowScreenState extends State<BuyerBookingFlowScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of 4', style: const TextStyle(color: AppColors.secondaryColor, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondaryColor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            backgroundColor: Colors.grey.shade200,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        elevation: 0,
        margin: EdgeInsets.zero,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_currentStep == 3 ? 'Send booking request' : 'Continue to Step ${_currentStep + 2}'),
                  ),
                ),
              ],
            ),
          );
        },
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep++);
          } else {
            // Submit booking
            context.router.popUntilRoot();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking request sent successfully!')),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            context.router.maybePop();
          }
        },
        steps: [
          Step(
            title: const SizedBox.shrink(),
            content: _buildStep1Dates(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const SizedBox.shrink(),
            content: _buildStep2Place(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const SizedBox.shrink(),
            content: _buildStep3Info(),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const SizedBox.shrink(),
            content: _buildStep4Review(),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Dates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dates & Duration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 300,
          color: Colors.grey.shade200,
          child: const Center(child: Text('Calendar Picker Placeholder')),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pricing Summary', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rental amount'),
                  Text('---'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Security deposit'),
                  Text('---'),
                ],
              ),
              Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total to pay now', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('---', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor)),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStep2Place() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Place of Use', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Full address',
            hintText: 'Farm on the road to Bafia, after the bridge',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          color: Colors.grey.shade200,
          child: const Center(child: Text('Mapbox Pin Picker Placeholder')),
        ),
      ],
    );
  }

  Widget _buildStep3Info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Additional Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Planned work type',
            hintText: 'Describe what you plan to use the equipment for',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Experience level',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'none', child: Text('No experience')),
            DropdownMenuItem(value: 'basic', child: Text('Basic agricultural knowledge')),
            DropdownMenuItem(value: 'certified', child: Text('Certified operator')),
          ],
          onChanged: (val) {},
        ),
      ],
    );
  }

  Widget _buildStep4Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review & Payment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text('Equipment: John Deere 5075E'),
              Text('Dates: 12 Nov 2026 - 15 Nov 2026 (3 days)'),
              Text('Place: Bafia Farm Road'),
              Divider(height: 24),
              Text('Total to pay: 375,000 FCFA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Card(
          child: RadioListTile(
            value: 1,
            groupValue: 1,
            onChanged: (val) {},
            title: const Text('Bank Card'),
            subtitle: const Text('Secured by Flutterwave'),
            secondary: const Icon(Icons.credit_card, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
