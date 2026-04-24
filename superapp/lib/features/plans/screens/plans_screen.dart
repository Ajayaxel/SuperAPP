import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/core/utils/custom_toast.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc_states.dart';
import 'package:superapp/features/bootmnav/bottm_navbar.dart';
import 'package:superapp/features/marketplace/models/car_listing_metadata.dart';
import '../../../Themes/app_colors.dart';

class PlansScreen extends StatefulWidget {
  final List<PlanModel>? initialPlans;
  final List<String>? imagePaths;
  const PlansScreen({super.key, this.initialPlans, this.imagePaths});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  late PageController _pageController;
  late List<Map<String, dynamic>> plans;
  @override
  void initState() {
    super.initState();
    _initializePlans();
    _pageController = PageController(
      initialPage: plans.length > 1 ? 1 : 0,
      viewportFraction: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant PlansScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPlans != oldWidget.initialPlans) {
      setState(() {
        _initializePlans();
      });
    }
  }

  void _initializePlans() {
    if (widget.initialPlans != null && widget.initialPlans!.isNotEmpty) {
      plans = widget.initialPlans!
          .map(
            (p) => {
              'title': p.title,
              'price': 'AED ${p.price}',
              'badgeText': p.badgeText,
              'included': p.included,
              'benefits': p.benefits,
              'buttonText': p.buttonText,
            },
          )
          .toList();
    } else {
      plans = [];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellCarBloc, SellCarState>(
      listener: (context, state) {
        if (state is SellCarSuccess) {
          CustomToast.show(
            context,
            title: "Success",
            message: "Ad posted successfully!",
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false,
          );
        } else if (state is SellCarFailure) {
          CustomToast.show(context, title: "Error", message: state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Select a package that\nworks for you',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: plans.isEmpty
                    ? const Center(
                        child: Text(
                          'No plans available',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListenableBuilder(
                        listenable: _pageController,
                        builder: (context, child) {
                          double currentPage = _pageController.hasClients
                              ? _pageController.page ?? 1.0
                              : 1.0;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // PageView at the bottom, ignoring hits so it doesn't block buttons
                              IgnorePointer(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: plans.length,
                                  itemBuilder: (context, index) =>
                                      const SizedBox.expand(),
                                ),
                              ),
                              // GestureDetector to forward swipes to the PageController
                              // This allows buttons inside the cards to still receive tap events
                              GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  if (_pageController.hasClients) {
                                    _pageController.jumpTo(
                                      _pageController.offset - details.delta.dx,
                                    );
                                  }
                                },
                                onHorizontalDragEnd: (details) {
                                  if (_pageController.hasClients) {
                                    _pageController.animateToPage(
                                      _pageController.page!.round(),
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: _buildOrderedStack(currentPage),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (plans.isNotEmpty) ...[
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: _pageController,
                  builder: (context, child) {
                    double currentPage = _pageController.hasClients
                        ? _pageController.page ?? 1.0
                        : 1.0;
                    return _buildIndicators(currentPage.round());
                  },
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderedStack(double currentPage) {
    // Sort indices by distance from currentPage (farthest first)
    List<int> sortedIndices = List.generate(plans.length, (i) => i);
    sortedIndices.sort((a, b) {
      double distA = (a - currentPage).abs();
      double distB = (b - currentPage).abs();
      return distB.compareTo(distA);
    });

    return sortedIndices.map((index) {
      double relativePosition = index - currentPage;
      double absPos = relativePosition.abs();

      // Calculate transformations
      double scale = 1.0 - (absPos * 0.15);
      double opacity = (1.0 - (absPos * 0.4)).clamp(0.0, 1.0);
      double translateX = relativePosition * 110;
      double translateY = absPos * -15;
      double rotateZ = relativePosition * 0.12;

      return Transform.translate(
        offset: Offset(translateX, translateY),
        child: Transform.rotate(
          angle: rotateZ,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: RepaintBoundary(
                child: PlanCard(
                  title: plans[index]['title'],
                  price: plans[index]['price'],
                  badgeText: plans[index]['badgeText'],
                  included: plans[index]['included'],
                  benefits: plans[index]['benefits'],
                  buttonText: plans[index]['buttonText'],
                  isActive: absPos < 0.5,
                  onSelected: () {
                    final selectedPlan = plans[index];
                    int planId = 1;
                    if (widget.initialPlans != null &&
                        widget.initialPlans!.isNotEmpty) {
                      planId = widget.initialPlans!
                          .firstWhere(
                            (p) => p.title == selectedPlan['title'],
                            orElse: () => widget.initialPlans![0],
                          )
                          .id;
                    }

                    context.read<SellCarBloc>().add(
                      UpdateSellCarForm({"plan_id": planId}),
                    );

                    context.read<SellCarBloc>().add(
                      SubmitSellCarListing(imagePaths: widget.imagePaths ?? []),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildIndicators(int currentActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(plans.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildLine(isActive: index == currentActive),
        );
      }),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 48 : 18,
      height: 3,
      decoration: BoxDecoration(
        color: isActive ? AppColors.btnColor : const Color(0xFF404040),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String badgeText;
  final List<String> included;
  final List<String> benefits;
  final String buttonText;
  final bool isActive;
  final VoidCallback? onSelected;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    this.badgeText = 'Recommended',
    required this.included,
    required this.benefits,
    required this.buttonText,
    this.isActive = true,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      height: 526,
      decoration: BoxDecoration(
        color: isActive ? AppColors.btnColor : const Color(0xFF505050),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Badge text (Recommended/Best Value etc)
          if (badgeText.isNotEmpty)
            Positioned(
              top: 10,
              right: 16,
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                  height: 1.67,
                ),
              ),
            ),
          // Black section with custom clip
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(5.0), // Outer border thickness
              child: ClipPath(
                clipper: PlanCardClipper(),
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Opacity(
                        opacity: 0.5,
                        child: Text(
                          "What's included",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...included.map((item) => _buildCheckItem(item)),
                      const SizedBox(height: 5),
                      Opacity(
                        opacity: 0.54,
                        child: Text(
                          'Why $title?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...benefits.map((item) => _buildCheckItem(item)),
                      const Spacer(),
                      GestureDetector(
                        onTap: onSelected,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: ShapeDecoration(
                            color: isActive
                                ? const Color(0xFF35A2BC)
                                : const Color(0xFF333333),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double radius = 15;
    const double notchWidth = 118;
    const double notchHeight = 32;
    const double smooth = 14;

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - notchWidth - smooth, 0);
    path.quadraticBezierTo(
      size.width - notchWidth,
      0,
      size.width - notchWidth,
      smooth,
    );
    path.lineTo(size.width - notchWidth, notchHeight - smooth);
    path.quadraticBezierTo(
      size.width - notchWidth,
      notchHeight,
      size.width - notchWidth + smooth,
      notchHeight,
    );
    path.lineTo(size.width - radius, notchHeight);
    path.quadraticBezierTo(
      size.width,
      notchHeight,
      size.width,
      notchHeight + radius,
    );
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
