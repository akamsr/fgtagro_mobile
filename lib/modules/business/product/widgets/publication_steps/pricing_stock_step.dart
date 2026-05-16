import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class PricingStockStep extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController stockController;
  final TextEditingController moqController;
  final String unit;
  final Function(String) onUnitChange;

  const PricingStockStep({
    super.key,
    required this.priceController,
    required this.stockController,
    required this.moqController,
    required this.unit,
    required this.onUnitChange,
  });

  @override
  State<PricingStockStep> createState() => _PricingStockStepState();
}

class _PricingStockStepState extends State<PricingStockStep> {
  bool _showAnomalyWarning = false;

  @override
  void initState() {
    super.initState();
    widget.priceController.addListener(_checkPriceAnomaly);
  }

  void _checkPriceAnomaly() {
    final price = double.tryParse(widget.priceController.text) ?? 0;
    // Mock anomaly detection: if price > 50,000 for this generic category
    setState(() => _showAnomalyWarning = price > 50000 || (price < 100 && price > 0));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing & Inventory',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 32),
        const Text('Unit Price (FCFA)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: widget.priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            prefixText: 'FCFA ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_showAnomalyWarning)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'This price seems unusual for this category. Please verify before submitting.',
              style: TextStyle(color: Colors.orange.shade800, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(height: 24),
        const Text('Sales Unit', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: widget.unit,
          items: ['kg', 'bag', 'tonne', 'litre', 'piece', 'bunch', 'crate', 'bottle'].map((u) {
            return DropdownMenuItem(value: u, child: Text(u));
          }).toList(),
          onChanged: (v) => widget.onUnitChange(v!),
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Stock', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: widget.stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: '0', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Min. Order (MOQ)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: widget.moqController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Optional', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
