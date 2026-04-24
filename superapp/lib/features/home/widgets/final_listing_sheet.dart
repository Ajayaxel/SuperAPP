import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/core/constants/btn.dart';
import 'package:superapp/core/utils/custom_toast.dart';
import 'package:superapp/core/widgets/custom_dropdown.dart';
import 'package:superapp/core/widgets/custom_textfield.dart';
import 'package:superapp/core/services/location_service.dart';
import 'package:superapp/features/plans/screens/plans_screen.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc_states.dart';
import 'package:superapp/features/marketplace/models/car_listing_metadata.dart';

class FinalListingSheet extends StatefulWidget {
  final VoidCallback onBack;
  const FinalListingSheet({super.key, required this.onBack});

  @override
  State<FinalListingSheet> createState() => _FinalListingSheetState();
}

class _FinalListingSheetState extends State<FinalListingSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  MetadataItem? _selectedExtColor;
  MetadataItem? _selectedIntColor;
  MetadataItem? _selectedWarranty;
  MetadataItem? _selectedCharging;
  MetadataItem? _selectedDoor;
  MetadataItem? _selectedTransmission;
  MetadataItem? _selectedEngineCylinders;
  MetadataItem? _selectedHorsepower;
  MetadataItem? _selectedSteeringSide;
  CarListingMetadata? _metadata;

  // Selection states for new fields
  final List<MetadataItem> _selectedSafetyFeatures = [];
  final List<MetadataItem> _selectedTechFeatures = [];
  final List<MetadataItem> _selectedComfortFeatures = [];
  final List<MetadataItem> _selectedExteriorFeatures = [];

  final _locationController = TextEditingController();
  final _buildingController = TextEditingController();
  final _customLabelController = TextEditingController();

  // Google Maps state
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(25.2048, 55.2708); // Default to Dubai
  final Set<Marker> _markers = {};

  String? _selectedCondition;

  MetadataItem? _selectedEngineCapacity;
  MetadataItem? _selectedSeats;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId("selected_location"),
            position: _currentPosition,
            draggable: true,
            onDragEnd: (newPos) => setState(() => _currentPosition = newPos),
          ),
        );
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((f) => File(f.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellCarBloc, SellCarState>(
      builder: (context, state) {
        if (state is SellCarMetadataLoaded) {
          _metadata = state.metadata;
        }
        final metadata = _metadata;

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
                      children: [
                        _buildSummarySection(metadata),
                        const SizedBox(height: 24),
                        const SizedBox(height: 24),
                        _buildImageSection(),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _titleController,
                          hintText: "Title",
                          validator: (val) =>
                              val == null || val.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 12),
                        CustomDropdown<String>(
                          label: "Describe your item",
                          value: _selectedCondition,
                          items: const [
                            DropdownMenuItem(
                              value: "Excellent",
                              child: Text("Excellent"),
                            ),
                            DropdownMenuItem(
                              value: "Good",
                              child: Text("Good"),
                            ),
                            DropdownMenuItem(
                              value: "Fair",
                              child: Text("Fair"),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedCondition = val),
                          validator: (val) => val == null ? "Required" : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _descController,
                          hintText: "Description",
                          maxLines: 3,
                          validator: (val) =>
                              val == null || val.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 12),
                        if (metadata != null) ...[
                          CustomDropdown<MetadataItem>(
                            label: "Exterior Color",
                            value: _selectedExtColor,
                            items:
                                (metadata.exteriorColors.isNotEmpty
                                        ? metadata.exteriorColors
                                        : metadata.colors)
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedExtColor = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          CustomDropdown<MetadataItem>(
                            label: "Interior color",
                            value: _selectedIntColor,
                            items:
                                (metadata.interiorColors.isNotEmpty
                                        ? metadata.interiorColors
                                        : metadata.colors)
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedIntColor = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Warranty*",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropdown<MetadataItem>(
                            label: "Yes",
                            value: _selectedWarranty,
                            items: metadata.warrantyOptions
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedWarranty = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Charging Port*",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropdown<MetadataItem>(
                            label: "Petrol",
                            value: _selectedCharging,
                            items: metadata.chargingTypes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedCharging = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Doors *",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropdown<MetadataItem>(
                            label: "4 door",
                            value: _selectedDoor,
                            items: metadata.doorTypes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedDoor = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          CustomDropdown<MetadataItem>(
                            label: "Transmission Type*",
                            value: _selectedTransmission,
                            items: metadata.transmissions
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedTransmission = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          CustomDropdown<MetadataItem>(
                            label: "Engine Cylinders*",
                            value: _selectedEngineCylinders,
                            items: metadata.engineCylinders
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedEngineCylinders = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          CustomDropdown<MetadataItem>(
                            label: "Engine Capacity*",
                            value: _selectedEngineCapacity,
                            items: metadata.engineCapacities
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedEngineCapacity = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          CustomDropdown<MetadataItem>(
                            label: "Seating Capacity",
                            value: _selectedSeats,
                            items: metadata.seatingCapacities
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedSeats = val),
                          ),
                          const SizedBox(height: 12),
                          CustomDropdown<MetadataItem>(
                            label: "Horsepower",
                            value: _selectedHorsepower,
                            items: metadata.horsepowers
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedHorsepower = val),
                          ),
                          const SizedBox(height: 24),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Steering Side*",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomDropdown<MetadataItem>(
                            label: "Right Hand",
                            value: _selectedSteeringSide,
                            items: metadata.steeringSides
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedSteeringSide = val),
                            validator: (val) => val == null ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureSelector(
                            "Driver Assistance & Safety",
                            metadata.safetyFeatures,
                            _selectedSafetyFeatures,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureSelector(
                            "Entertainment & Technology",
                            metadata.techFeatures,
                            _selectedTechFeatures,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureSelector(
                            "Comfort & Connivence",
                            metadata.comfortFeatures,
                            _selectedComfortFeatures,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureSelector(
                            "Exterior Features",
                            metadata.exteriorFeatures,
                            _selectedExteriorFeatures,
                          ),
                        ],
                        const SizedBox(height: 24),
                        _buildLocationSection(),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            "Make sure the car information you have entered is correct. You will only be able to make select changes once the ad is live.",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildRejectionWarning(),
                        const SizedBox(height: 24),
                        Btn(
                          text: "Next",
                          onTap: () {
                            if (_images.isEmpty) {
                              CustomToast.show(
                                context,
                                title: "Required",
                                message: "Please add at least one image",
                                isError: true,
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              // Update Bloc with remaining data
                              context.read<SellCarBloc>().add(
                                UpdateSellCarForm({
                                  "title": _titleController.text,
                                  "description": _descController.text,
                                  "exterior_color_id": _selectedExtColor?.id,
                                  "interior_color_id": _selectedIntColor?.id,
                                  "warranty_option_id": _selectedWarranty?.id,
                                  "charging_type_id": _selectedCharging?.id,
                                  "door_type_id": _selectedDoor?.id,
                                  "engine_cylinder_id":
                                      _selectedEngineCylinders?.id,
                                  "engine_capacity_id":
                                      _selectedEngineCapacity?.id,
                                  "transmission_id": _selectedTransmission?.id,
                                  "horsepower_id": _selectedHorsepower?.id,
                                  "steering_side_id": _selectedSteeringSide?.id,
                                  "latitude": _currentPosition.latitude,
                                  "longitude": _currentPosition.longitude,
                                  "location_label": _customLabelController.text,
                                  "condition": _selectedCondition,
                                  "seating_capacity_id": _selectedSeats?.id,
                                  "images": _images,
                                  "safety_features[]": _selectedSafetyFeatures
                                      .map((e) => e.id)
                                      .toList(),
                                  "tech_features[]": _selectedTechFeatures
                                      .map((e) => e.id)
                                      .toList(),
                                  "comfort_features[]": _selectedComfortFeatures
                                      .map((e) => e.id)
                                      .toList(),
                                  "exterior_features[]":
                                      _selectedExteriorFeatures
                                          .map((e) => e.id)
                                          .toList(),
                                }),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlansScreen(
                                    initialPlans: metadata?.plans,
                                    imagePaths: _images
                                        .map((e) => e.path)
                                        .toList(),
                                  ),
                                ),
                              );
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
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
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
              "You're almost there!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Include as much details and pictures as possible, and set the right price!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add Photos*",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              ..._images.map(
                (file) => Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => setState(() => _images.remove(file)),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(CarListingMetadata? metadata) {
    final formData = context.read<SellCarBloc>().formData;

    // Resolve Names from IDs
    String makeName = "N/A";
    String modelName = "N/A";
    if (metadata != null) {
      final make = metadata.makes.firstWhere(
        (e) => e.id == formData['car_make_id'],
        orElse: () => CarMake(id: 0, name: "N/A", models: [], status: true),
      );
      makeName = make.name;
      final model = make.models.firstWhere(
        (e) => e.id == formData['car_model_id'],
        orElse: () =>
            CarModel(id: 0, carMakeId: 0, name: "N/A", status: true, trims: []),
      );
      modelName = model.name;
    }

    String trimName = "N/A";
    if (metadata != null && formData['car_trim_id'] != null) {
      final make = metadata.makes.firstWhere(
        (e) => e.id == formData['car_make_id'],
        orElse: () => CarMake(id: 0, name: "N/A", models: [], status: true),
      );
      final model = make.models.firstWhere(
        (e) => e.id == formData['car_model_id'],
        orElse: () =>
            CarModel(id: 0, carMakeId: 0, name: "N/A", status: true, trims: []),
      );
      trimName = model.trims
          .firstWhere(
            (e) => e.id == formData['car_trim_id'],
            orElse: () => MetadataItem(id: 0, name: "N/A"),
          )
          .name;
    }

    String regSpec = "N/A";
    if (metadata != null && formData['regional_spec_id'] != null) {
      regSpec = metadata.regionalSpecs
          .firstWhere(
            (e) => e.id == formData['regional_spec_id'],
            orElse: () => MetadataItem(id: 0, name: "N/A"),
          )
          .name;
    }

    String bodyType = "N/A";
    if (metadata != null && formData['body_type_id'] != null) {
      bodyType = metadata.bodyTypes
          .firstWhere(
            (e) => e.id == formData['body_type_id'],
            orElse: () => MetadataItem(id: 0, name: "N/A"),
          )
          .name;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.formBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Listing Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow("Make & Model", "$makeName $modelName"),
          const Divider(color: Colors.white24),
          _buildSummaryRow("Trim", trimName),
          const Divider(color: Colors.white24),
          _buildSummaryRow("Regional Specs", regSpec),
          const Divider(color: Colors.white24),
          _buildSummaryRow("Year", "${formData['year'] ?? 'N/A'}"),
          const Divider(color: Colors.white24),
          _buildSummaryRow("Kilometres", "${formData['kilometers'] ?? 'N/A'}"),
          const Divider(color: Colors.white24),
          _buildSummaryRow("Body Type", bodyType),
          const Divider(color: Colors.white24),
          _buildSummaryRow("Price", "${formData['price'] ?? 'N/A'}"),
          const Divider(color: Colors.white24),
          _buildSummaryRow(
            "Phone number",
            "${formData['phone_number'] ?? 'N/A'}",
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.formBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          if (_images.isNotEmpty)
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.05),
                            image: DecorationImage(
                              image: FileImage(_images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (index == 0)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Main Image",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _images.removeAt(index)),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00A3AD)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Add Images",
                  style: TextStyle(
                    color: Color(0xFF00A3AD),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSelector(
    String label,
    List<MetadataItem> options,
    List<MetadataItem> selected,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
            ],
          ),
          if (selected.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selected.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A4A4A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => selected.remove(item)),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          // Temporary picker button
          TextButton(
            onPressed: () {
              // Show a dialog to select from options
              _showFeatureDialog(label, options, selected);
            },
            child: const Text(
              "Select Features",
              style: TextStyle(color: Colors.cyan, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(
    String label,
    List<MetadataItem> options,
    List<MetadataItem> selected,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: Text(label, style: const TextStyle(color: Colors.white)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final item = options[index];
                    final isSelected = selected.contains(item);
                    return CheckboxListTile(
                      title: Text(
                        item.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: isSelected,
                      onChanged: (val) {
                        setDialogState(() {
                          if (val == true) {
                            selected.add(item);
                          } else {
                            selected.remove(item);
                          }
                        });
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.formBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Location",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'SF Pro',
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: "Locate your item",
            controller: _locationController,
            suffixText: "Optional",
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "Building or street name",
            controller: _buildingController,
            suffixText: "Optional",
          ),
          const SizedBox(height: 20),
          const Text(
            "Is the pin in the right location?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Click and drag the pin to the exact spot. Users are more likely to respond to ads that are correctly shown on the map.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontFamily: 'SF Pro',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onTap: (pos) {
                      setState(() {
                        _currentPosition = pos;
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: const MarkerId("selected_location"),
                            position: pos,
                            draggable: true,
                            onDragEnd: (newPos) =>
                                setState(() => _currentPosition = newPos),
                          ),
                        );
                      });
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: FloatingActionButton.small(
                      backgroundColor: AppColors.btnColor,
                      child: const Icon(Icons.my_location, color: Colors.white),
                      onPressed: _initializeLocation,
                    ),
                  ),
                  Center(
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Show In Map",
                          style: TextStyle(
                            color: Color(0xFF00A3AD),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
              ),
              children: [
                TextSpan(text: "Choose how you want to label your location "),
                TextSpan(
                  text: "(optional)",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Add Custom Label",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: "Add a name for your location",
            controller: _customLabelController,
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 14),
              children: [
                TextSpan(
                  text:
                      "Your ad will be rejected if it does not comply with our ",
                ),
                TextSpan(
                  text: "posting guidelines",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ". Got questions? "),
                TextSpan(
                  text: "email us",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: "."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 14),
              children: [
                TextSpan(
                  text:
                      "By proceeding, I confirm that I have reviewed the information provided above and confirm that such information is complete and accurate. ",
                ),
                TextSpan(
                  text: "Terms & conditions",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: "."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
