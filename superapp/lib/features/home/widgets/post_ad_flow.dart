import 'package:flutter/material.dart';
import 'package:superapp/features/home/widgets/select_city_sheet.dart';
import 'package:superapp/features/home/widgets/choose_category_sheet.dart';
import 'package:superapp/features/home/widgets/car_details_sheet.dart';
import 'package:superapp/features/home/widgets/final_listing_sheet.dart';

class PostAdFlow extends StatefulWidget {
  const PostAdFlow({super.key});

  @override
  State<PostAdFlow> createState() => _PostAdFlowState();
}

class _PostAdFlowState extends State<PostAdFlow> {
  int _currentStep =
      1; // 0: Select City, 1: Choose Category, 2: Car Details, 3: Final Listing

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep--;
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
    if (_currentStep == 0) {
      return SelectCitySheet(onCitySelected: (city) => _nextStep());
    } else */
    if (_currentStep == 1) {
      return ChooseCategorySheet(
        onBack: _prevStep,
        onCategorySelected: (category) => _nextStep(),
      );
    } else if (_currentStep == 2) {
      return CarDetailsSheet(onBack: _prevStep, onNext: () => _nextStep());
    } else {
      return FinalListingSheet(onBack: _prevStep);
    }
  }
}

void showPostAdFlow(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withAlpha(150),
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: Material(color: Colors.transparent, child: PostAdFlow()),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: child,
      );
    },
  );
}
