import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

const List<String> cameroonCities = [
  'Douala',
  'Yaoundé',
  'Bafoussam',
  'Bamenda',
  'Garoua',
  'Maroua',
  'Ngaoundéré',
  'Bertoua',
  'Ebolowa',
  'Kribi',
];

@RoutePage()
class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  String name = '';
  String city = '';
  String district = '';
  String address = '';
  String lat = '';
  String lng = '';
  String phoneCode = '+237';
  String phoneNumber = '';
  String email = '';
  String managerName = '';

  bool showCities = false;

  bool get canSubmit =>
      name.trim().length >= 2 &&
      city.trim().length >= 2 &&
      address.trim().length >= 5 &&
      phoneNumber.trim().length >= 7 &&
      lat.trim() != '' &&
      lng.trim() != '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FD),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.secondaryColor,
                    ),
                    onPressed: () => CustomNavigate.back(),
                  ),
                  const Text(
                    'Nouvelle boutique',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 48), // balance back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      'Informations principales',
                      Icons.storefront_outlined,
                    ),
                    _buildField(
                      'Nom de la boutique *',
                      name,
                      (v) => setState(() => name = v),
                      'ex: Agro Distrib Bafoussam',
                    ),

                    // City Dropdown Mock
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'VILLE *',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () =>
                                setState(() => showCities = !showCities),
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color.fromRGBO(
                                    228,
                                    226,
                                    230,
                                    0.4,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    city.isEmpty
                                        ? 'Sélectionner une ville'
                                        : city,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: city.isEmpty
                                          ? Colors.grey
                                          : AppColors.secondaryColor,
                                    ),
                                  ),
                                  Icon(
                                    showCities
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (showCities)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: cameroonCities
                                    .map(
                                      (c) => InkWell(
                                        onTap: () => setState(() {
                                          city = c;
                                          showCities = false;
                                        }),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          color: city == c
                                              ? const Color(0xFFFFF5EE)
                                              : Colors.transparent,
                                          child: Text(
                                            c,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: city == c
                                                  ? AppColors.primaryColor
                                                  : AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        ],
                      ),
                    ),

                    _buildField(
                      'Quartier / District',
                      district,
                      (v) => setState(() => district = v),
                      'ex: Akwa, Bastos, Biyem-Assi',
                    ),
                    _buildField(
                      'Adresse complète *',
                      address,
                      (v) => setState(() => address = v),
                      'ex: Rue de la Cité, face Marché Central',
                      multiline: true,
                    ),

                    _buildSectionHeader(
                      'Coordonnées GPS',
                      Icons.location_on_outlined,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Ouvrez Google Maps, maintenez appuyé sur votre position pour copier les coordonnées.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            'Latitude *',
                            lat,
                            (v) => setState(() => lat = v),
                            'ex: 4.0511',
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            'Longitude *',
                            lng,
                            (v) => setState(() => lng = v),
                            'ex: 9.7679',
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),

                    _buildSectionHeader('Contact', Icons.call_outlined),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 80,
                          child: _buildField(
                            'IND.',
                            phoneCode,
                            (v) => setState(() => phoneCode = v),
                            '+237',
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            'Téléphone *',
                            phoneNumber,
                            (v) => setState(() => phoneNumber = v),
                            'ex: 690123456',
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    _buildField(
                      'Email de la boutique',
                      email,
                      (v) => setState(() => email = v),
                      'ex: boutique@agroDistrib.cm',
                    ),

                    _buildSectionHeader(
                      'Responsable (optionnel)',
                      Icons.person_outline,
                    ),
                    _buildField(
                      'Nom du responsable',
                      managerName,
                      (v) => setState(() => managerName = v),
                      'ex: Jean-Pierre Mbala',
                    ),
                  ],
                ),
              ),
            ),

            // CTA
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                max(16.0, MediaQuery.of(context).padding.bottom),
              ),
              child: Opacity(
                opacity: canSubmit ? 1.0 : 0.5,
                child: ElevatedButton(
                  onPressed: canSubmit ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.storefront_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Créer la boutique',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    String value,
    Function(String) onChanged,
    String placeholder, {
    bool multiline = false,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: multiline ? 80 : 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromRGBO(228, 226, 230, 0.4),
              ),
            ),
            child: TextField(
              onChanged: onChanged,
              keyboardType: isNumber
                  ? TextInputType.number
                  : (multiline ? TextInputType.multiline : TextInputType.text),
              maxLines: multiline ? null : 1,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryColor,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
