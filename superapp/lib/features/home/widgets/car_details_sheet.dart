import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/core/widgets/custom_dropdown.dart';
import 'package:superapp/core/widgets/custom_textfield.dart';
import 'package:superapp/core/constants/btn.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc_states.dart';
import 'package:superapp/features/marketplace/models/car_listing_metadata.dart';
import 'package:superapp/core/widgets/app_loading.dart';

class CarDetailsSheet extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const CarDetailsSheet({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<CarDetailsSheet> createState() => _CarDetailsSheetState();
}

class _CarDetailsSheetState extends State<CarDetailsSheet> {
  final _formKey = GlobalKey<FormState>();

  MetadataItem? _selectedEmirate;
  CarMake? _selectedMake;
  CarModel? _selectedModel;
  MetadataItem? _selectedTrim;
  MetadataItem? _selectedRegionalSpec;
  String? _selectedYear;
  MetadataItem? _selectedBodyType;
  String? _insuranceStatus = "Yes";

  final _kmController = TextEditingController();
  final _priceController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SellCarBloc>().add(LoadSellCarMetadata());
    
    // Load existing data if available
    final formData = context.read<SellCarBloc>().formData;
    if (formData.isNotEmpty) {
      _kmController.text = formData['kilometers']?.toString() ?? '';
      _priceController.text = formData['price']?.toString() ?? '';
      _phoneController.text = formData['phone_number']?.toString() ?? '';
      _selectedYear = formData['year']?.toString();
      _insuranceStatus = formData['is_insured'] == 1 ? "Yes" : "No";
      // Note: Metadata objects like _selectedEmirate cannot be easily restored from just IDs 
      // without the metadata list being loaded first.
    }
  }

  @override
  void dispose() {
    _kmController.dispose();
    _priceController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellCarBloc, SellCarState>(
      builder: (context, state) {
        if (state is SellCarMetadataLoading) {
          return const Center(child: AppLoading());
        }

        if (state is SellCarMetadataLoaded) {
          final metadata = state.metadata;
          final formData = context.read<SellCarBloc>().formData;

          // Restore selections from formData if not already set (one-time restoration)
          if (formData.isNotEmpty) {
            _selectedEmirate ??= metadata.emirates.cast<MetadataItem?>().firstWhere(
                  (e) => e?.id == formData['emirate_id'],
                  orElse: () => null,
                );
            _selectedMake ??= metadata.makes.cast<CarMake?>().firstWhere(
                  (e) => e?.id == formData['car_make_id'],
                  orElse: () => null,
                );
            if (_selectedMake != null) {
              _selectedModel ??= _selectedMake!.models.cast<CarModel?>().firstWhere(
                    (e) => e?.id == formData['car_model_id'],
                    orElse: () => null,
                  );
              if (_selectedModel != null) {
                _selectedTrim ??= _selectedModel!.trims.cast<MetadataItem?>().firstWhere(
                      (e) => e?.id == formData['car_trim_id'],
                      orElse: () => null,
                    );
              }
            }
            _selectedRegionalSpec ??= metadata.regionalSpecs.cast<MetadataItem?>().firstWhere(
                  (e) => e?.id == formData['regional_spec_id'],
                  orElse: () => null,
                );
            _selectedBodyType ??= metadata.bodyTypes.cast<MetadataItem?>().firstWhere(
                  (e) => e?.id == formData['body_type_id'],
                  orElse: () => null,
                );
          }

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    CustomDropdown<MetadataItem>(
                      label: "Emirate*",
                      value: _selectedEmirate,
                      items: metadata.emirates
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedEmirate = val),
                      validator: (val) => val == null ? "Required" : null,
                    ),
                    CustomDropdown<CarMake>(
                      label: "Make & Model",
                      value: _selectedMake,
                      items: metadata.makes
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedMake = val;
                          _selectedModel = null;
                          _selectedTrim = null;
                        });
                      },
                      validator: (val) => val == null ? "Required" : null,
                    ),
                    if (_selectedMake != null) ...[
                      const SizedBox(height: 12),
                      CustomDropdown<CarModel>(
                        label: "Model*",
                        value: _selectedModel,
                        items: (_selectedMake?.models ?? [])
                            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedModel = val;
                            _selectedTrim = null;
                          });
                        },
                        validator: (val) => val == null ? "Required" : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    CustomDropdown<MetadataItem>(
                      label: (_selectedModel?.trims.isNotEmpty ?? false) ? "Trim*" : "Trim",
                      value: _selectedTrim,
                      items: (_selectedModel?.trims ?? [])
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedTrim = val),
                      validator: (val) => ((_selectedModel?.trims.isNotEmpty ?? false) && val == null) ? "Required" : null,
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown<MetadataItem>(
                      label: "Regional Spec",
                      value: _selectedRegionalSpec,
                      items: metadata.regionalSpecs
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedRegionalSpec = val),
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown<String>(
                      label: "Year",
                      value: _selectedYear,
                      items: List.generate(30, (index) => (DateTime.now().year - index).toString())
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedYear = val),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _kmController,
                      hintText: "Kilometres",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown<MetadataItem>(
                      label: "Body Type",
                      value: _selectedBodyType,
                      items: metadata.bodyTypes
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedBodyType = val),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Is your car insured in UAE?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown<String>(
                      label: "Insurance Status",
                      value: _insuranceStatus,
                      items: const [
                        DropdownMenuItem(value: "Yes", child: Text("Yes")),
                        DropdownMenuItem(value: "No", child: Text("No")),
                      ],
                      onChanged: (val) => setState(() => _insuranceStatus = val),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _priceController,
                      hintText: "Price",
                      suffixText: "AED",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Phone Number",
                      keyboardType: TextInputType.phone,
                      suffixIcon: Icons.keyboard_arrow_down,
                    ),
                    const SizedBox(height: 24),
                    Btn(
                      text: "Next",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SellCarBloc>().add(
                                UpdateSellCarForm({
                                  "emirate_id": _selectedEmirate!.id,
                                  "car_make_id": _selectedMake!.id,
                                  "car_model_id": _selectedModel!.id,
                                  "car_trim_id": _selectedTrim?.id,
                                  "regional_spec_id": _selectedRegionalSpec?.id,
                                  "year": _selectedYear,
                                  "kilometers": _kmController.text,
                                  "body_type_id": _selectedBodyType?.id,
                                  "price": _priceController.text,
                                  "phone_number": _phoneController.text,
                                  "is_insured": _insuranceStatus == "Yes" ? 1 : 0,
                                }),
                              );
                          widget.onNext();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  return const SizedBox.shrink();
},
);
}
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: widget.onBack,
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const Text(
          "Tell us about your car",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
