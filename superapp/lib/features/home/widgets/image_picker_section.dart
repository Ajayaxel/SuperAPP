import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:superapp/Themes/app_colors.dart';

class ImagePickerSection extends StatefulWidget {
  final Function(List<XFile>) onImagesChanged;
  const ImagePickerSection({super.key, required this.onImagesChanged});

  @override
  State<ImagePickerSection> createState() => _ImagePickerSectionState();
}

class _ImagePickerSectionState extends State<ImagePickerSection> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
      widget.onImagesChanged(_selectedImages);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesChanged(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.formBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (_selectedImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.start,
                children: List.generate(_selectedImages.length, (index) {
                  return _buildSelectedImageItem(index);
                }),
              ),
            ),
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.btnColor.withValues(alpha: 0.5),
                ),
              ),
              child: Center(
                child: Text(
                  'Add Images',
                  style: TextStyle(
                    color: AppColors.btnColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

  Widget _buildSelectedImageItem(int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 142,
      height: 115,
      decoration: ShapeDecoration(
        color: const Color(0x191E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  index == 0 ? 'Main Image' : 'Image ${index + 1}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _removeImage(index),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFFE7000B),
                  child: Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Image.file(
                File(_selectedImages[index].path),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
