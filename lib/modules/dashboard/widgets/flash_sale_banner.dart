import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class FlashSaleBanner extends StatelessWidget {
  const FlashSaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 176,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFf97316), Color(0xFFeb6909)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), shape: BoxShape.circle),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), shape: BoxShape.circle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.flash_on, size: 10, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Vente Flash',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Promotion -20%\nRiz 25% Brisures',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.2),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Savourez vos repas avec un bon\nriz indien.',
                    style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Acheter', style: TextStyle(color: AppColors.secondaryColor, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                        child: const Text('-20%', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
