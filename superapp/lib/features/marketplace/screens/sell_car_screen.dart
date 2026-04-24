import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/core/constants/btn.dart';
import 'package:superapp/core/widgets/app_loading.dart';
import 'package:superapp/core/widgets/custom_dropdown.dart';
import 'package:superapp/core/widgets/custom_textfield.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc_states.dart';
import 'package:superapp/features/marketplace/models/car_listing_metadata.dart';

class SellCarScreen extends StatefulWidget {
  const SellCarScreen({super.key});

  @override
  State<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  final _formKey = GlobalKey<FormState>();

  // Selected values
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tell us about your car",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SellCarBloc, SellCarState>(
        listener: (context, state) {
          if (state is SellCarFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is SellCarMetadataLoading) {
            return const Center(child: AppLoading());
          }

          if (state is SellCarMetadataLoaded) {
            final metadata = state.metadata;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomDropdown<MetadataItem>(
                      label: "Emirate*",
                      value: _selectedEmirate,
                      items: metadata.emirates.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e.name));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedEmirate = val),
                      validator: (val) => val == null ? "Required" : null,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<CarMake>(
                      label: "Make & Model",
                      value: _selectedMake,
                      items: metadata.makes.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e.name));
                      }).toList(),
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
                      const SizedBox(height: 16),
                      CustomDropdown<CarModel>(
                        label: "Model*",
                        value: _selectedModel,
                        items: (_selectedMake?.models ?? []).map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedModel = val;
                            _selectedTrim = null;
                          });
                        },
                        validator: (val) => val == null ? "Required" : null,
                      ),
                    ],
                    const SizedBox(height: 16),
                    CustomDropdown<MetadataItem>(
                      label: (_selectedModel?.trims.isNotEmpty ?? false)
                          ? "Trim*"
                          : "Trim",
                      value: _selectedTrim,
                      items: (_selectedModel?.trims ?? []).map((e) {
                        return DropdownMenuItem(value: e, child: Text(e.name));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedTrim = val),
                      validator: (val) =>
                          ((_selectedModel?.trims.isNotEmpty ?? false) &&
                              val == null)
                          ? "Required"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<MetadataItem>(
                      label: "Regional Spec",
                      value: _selectedRegionalSpec,
                      items: metadata.regionalSpecs.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e.name));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedRegionalSpec = val),
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      label: "Year",
                      value: _selectedYear,
                      items:
                          List.generate(
                                30,
                                (index) =>
                                    (DateTime.now().year - index).toString(),
                              )
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _selectedYear = val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _kmController,
                      hintText: "Kilometres",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<MetadataItem>(
                      label: "Body Type",
                      value: _selectedBodyType,
                      items: metadata.bodyTypes.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e.name));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedBodyType = val),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Is your car insured in UAE?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
                      onChanged: (val) =>
                          setState(() => _insuranceStatus = val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _priceController,
                      hintText: "Price",
                      suffixText: "AED",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Phone Number",
                      keyboardType: TextInputType.phone,
                      suffixIcon: Icons.keyboard_arrow_down,
                    ),
                    const SizedBox(height: 40),
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
                          // For now, since there's no separate FinalListingScreen,
                          // we might want to navigate back or to a specific flow.
                          // But typically this screen should be part of a flow.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Form updated. Please continue."),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
