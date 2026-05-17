import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

/// Step 1 – Delivery address form
class StepDelivery extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController quarterController;
  final TextEditingController noteController;
  final String? selectedCity;
  final ValueChanged<String?> onCityChanged;

  const StepDelivery({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.quarterController,
    required this.noteController,
    required this.selectedCity,
    required this.onCityChanged,
  });

  @override
  State<StepDelivery> createState() => _StepDeliveryState();
}

class _StepDeliveryState extends State<StepDelivery>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  static const _cities = [
    'Yaoundé',
    'Douala',
    'Bafoussam',
    'Bamenda',
    'Garoua',
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Adresse de livraison',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Où souhaitez-vous recevoir votre commande ?',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            _Field(
              label: 'Destinataire',
              controller: widget.nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 14),
            _Field(
              label: 'Téléphone',
              controller: widget.phoneController,
              icon: Icons.phone_outlined,
              type: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            // City dropdown
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.selectedCity,
                  hint: const Text(
                    'Ville',
                    style: TextStyle(color: Colors.grey),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _cities
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: widget.onCityChanged,
                ),
              ),
            ),
            const SizedBox(height: 14),

            _Field(
              label: 'Quartier',
              controller: widget.quarterController,
              icon: Icons.location_city_outlined,
            ),
            const SizedBox(height: 14),
            _Field(
              label: 'Adresse complète',
              controller: widget.addressController,
              icon: Icons.home_outlined,
            ),
            const SizedBox(height: 14),

            // Optional note
            TextField(
              controller: widget.noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Note pour le livreur (Optionnel)...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFF8F7F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderDefault),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType type;

  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: Colors.grey),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: const Color(0xFFF8F7F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
