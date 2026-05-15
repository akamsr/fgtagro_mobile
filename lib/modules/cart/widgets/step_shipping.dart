import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

enum ShippingMethod { homeDelivery, storePickup }

/// Step 2 – Delivery method selection
class StepShipping extends StatefulWidget {
  final ShippingMethod selected;
  final ValueChanged<ShippingMethod> onChanged;
  final double grandTotal;

  const StepShipping({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.grandTotal,
  });

  @override
  State<StepShipping> createState() => _StepShippingState();
}

class _StepShippingState extends State<StepShipping>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
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
              'Mode d\'expédition',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
            ),
            const SizedBox(height: 4),
            const Text('Comment souhaitez-vous recevoir votre commande ?',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),

            _MethodCard(
              icon: Icons.local_shipping_outlined,
              title: 'Livraison à domicile',
              subtitle: 'Livré en 24–72h à votre adresse',
              badge: '~2 500 FCFA',
              selected: widget.selected == ShippingMethod.homeDelivery,
              onTap: () => widget.onChanged(ShippingMethod.homeDelivery),
            ),
            const SizedBox(height: 12),
            _MethodCard(
              icon: Icons.store_outlined,
              title: 'Retrait en boutique',
              subtitle: 'Gratuit · Prêt dans 48h',
              badge: 'Gratuit',
              badgeColor: AppColors.successFg,
              selected: widget.selected == ShippingMethod.storePickup,
              onTap: () => widget.onChanged(ShippingMethod.storePickup),
            ),

            if (widget.selected == ShippingMethod.homeDelivery) ...[
              const SizedBox(height: 24),
              _DeliveryBreakdown(grandTotal: widget.grandTotal),
            ],

            if (widget.selected == ShippingMethod.storePickup) ...[
              const SizedBox(height: 24),
              _StoreInfo(),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color? badgeColor;
  final bool selected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    this.badgeColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryTint : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primaryColor : AppColors.borderDefault,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [BoxShadow(color: AppColors.primaryColor.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: selected ? Colors.white : Colors.grey, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? AppColors.secondaryColor : AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (badgeColor ?? AppColors.primaryColor).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(badge,
                    style: TextStyle(color: badgeColor ?? AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryBreakdown extends StatelessWidget {
  final double grandTotal;
  const _DeliveryBreakdown({required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Détail de livraison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondaryColor)),
          const SizedBox(height: 12),
          _Row(label: 'Frais de livraison estimés', value: '~2 500 FCFA'),
          const SizedBox(height: 6),
          _Row(label: 'Délai estimé', value: '24–72h'),
          const SizedBox(height: 6),
          _Row(label: 'Total produits', value: '${grandTotal.toStringAsFixed(0)} FCFA'),
          const Divider(height: 20),
          _Row(label: 'Total à payer', value: '${(grandTotal + 2500).toStringAsFixed(0)} FCFA', bold: true),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.bold, fontSize: 13, color: bold ? AppColors.primaryColor : AppColors.textPrimary)),
      ],
    );
  }
}

class _StoreInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.successFg.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.store, color: AppColors.successFg),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FGT AGRO – Boutique Principale', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.successFg)),
                SizedBox(height: 2),
                Text('Bastos, Yaoundé • Lun–Sam 8h–18h', style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(height: 2),
                Text('Retrait gratuit · Prêt dans 48h', style: TextStyle(color: AppColors.successFg, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
