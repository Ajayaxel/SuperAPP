import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Themes/app_colors.dart';
import '../../../Themes/app_images.dart';
import 'product_stats_and_price.dart';
import 'marketplace_product_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/core/utils/custom_toast.dart';
import 'package:superapp/features/favourite/bloc/favorite_bloc.dart';
import 'package:superapp/features/favourite/bloc/favorite_event.dart';
import 'package:superapp/features/favourite/bloc/favorite_state.dart';
import '../models/home_data_model.dart';
import '../../chat/screens/chat_detail_screen.dart';

class ProductDetailModal extends StatefulWidget {
  final FreshRecommendation car;
  final String heroTag;

  const ProductDetailModal({
    super.key,
    required this.car,
    required this.heroTag,
  });

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  bool _isExpanded = false;
  bool _isSafetyExpanded = true;
  bool _isTechExpanded = false;
  bool _isComfortExpanded = false;
  bool _isExteriorExpanded = false;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.car.isFavorite;
  }

  // Finance Calculator State
  double _carPrice = 45000;
  double _downPaymentPercent = 20;
  double _interestRate = 2.9;
  int _loanPeriodYears = 5;

  double get _downPaymentAmount => _carPrice * (_downPaymentPercent / 100);
  double get _totalLoanAmount => _carPrice - _downPaymentAmount;

  double get _totalInterest =>
      _totalLoanAmount * (_interestRate / 100) * _loanPeriodYears;
  double get _totalRepayment => _totalLoanAmount + _totalInterest;
  double get _monthlyPayment => _totalRepayment / (_loanPeriodYears * 12);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        if (state is ToggleFavoriteSuccess && state.carListingId == widget.car.id) {
          CustomToast.show(
            context,
            title: 'Success',
            message: state.message,
          );
        } else if (state is FavoriteError) {
          CustomToast.show(
            context,
            title: 'Error',
            message: state.message,
            isError: true,
          );
          setState(() {
            _isFavorite = widget.car.isFavorite;
          });
        }
      },
      child: Center(
        child: GestureDetector(
          onTap: () {
          if (!_isExpanded) {
            setState(() {
              _isExpanded = true;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
          width: _isExpanded ? size.width : size.width * 0.9,
          height: _isExpanded ? size.height : null,
          constraints: BoxConstraints(
            maxHeight: _isExpanded ? size.height : size.height * 0.8,
            minHeight: _isExpanded ? size.height : 0,
          ),
          decoration: ShapeDecoration(
            color: _isExpanded ? Colors.black : const Color(0xFF505050),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_isExpanded ? 0 : 20),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_isExpanded ? 0 : 20),
            child: SingleChildScrollView(
              physics: _isExpanded
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: SafeArea(
                    top: _isExpanded,
                    bottom: _isExpanded,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.primary,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF393938),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: Color(0xFF00D66F),
                                        size: 14,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Color(0xFF00D66F),
                                          fontSize: 12,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    context.read<FavoriteBloc>().add(
                                          ToggleFavoriteEvent(
                                              carListingId: widget.car.id),
                                        );
                                    setState(() {
                                      _isFavorite = !_isFavorite;
                                    });
                                  },
                                  icon: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFavorite
                                        ? Colors.red
                                        : AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Hero(
                            tag: widget.heroTag,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.fastOutSlowIn,
                              height: _isExpanded ? 250 : 150,
                              child: widget.car.images.isNotEmpty
                                  ? Image.network(
                                      widget.car.images.first.imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                                AppImages.carimage,
                                                fit: BoxFit.contain,
                                              ),
                                    )
                                  : Image.asset(
                                      AppImages.carimage,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Hero(
                          tag: '${widget.heroTag}_title',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.car.title.isNotEmpty
                                  ? widget.car.title
                                  : '${widget.car.make.name} ${widget.car.model.name}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.car.description ?? 'No description available.',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFB5B5B5),
                            fontSize: 12,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ProductStatsAndPrice(
                          heroTag: widget.heroTag,
                          price: 'AED ${_formatPrice(widget.car.price)}',
                          year: widget.car.year.toString(),
                          kilometers: widget.car.kilometers.toString(),
                        ),
                        const SizedBox(height: 25),
                        const Opacity(
                          opacity: 0.54,
                          child: Text(
                            'Posted By',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFFFFFFF),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.car.user.profileImageUrl ??
                                        "https://uploads.vw-mms.de/system/production/images/vwn/030/145/images/7a0d84d3b718c9a621100e43e581278433114c82/DB2019AL01950_web_1600.jpg?1649155356",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.car.user.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.car.user.roleName == 'dealer'
                                        ? 'Dealer'
                                        : 'Private Seller',
                                    style: const TextStyle(
                                      color: Color(0xFFB5B5B5),
                                      fontSize: 14,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_isExpanded) ...[
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailScreen(
                                    receiverId: widget.car.user.id,
                                    receiverName: widget.car.user.name,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 46,
                              width: double.infinity,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFF0FF0FC),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: Color(0xFF0FF0FC),
                                    size: 21,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Chat',
                                    style: TextStyle(
                                      color: Color(0xFF0FF0FC),
                                      fontSize: 16,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF1C1C1A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Car Overview',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                OverViewRow(
                                  title: 'Interior Color',
                                  value: 'Black',
                                ),
                                OverViewRow(
                                  title: 'Horsepower',
                                  value: '100 - 199 HP',
                                ),
                                OverViewRow(title: 'Doors', value: '5+ doors'),
                                OverViewRow(
                                  title: 'Fuel Type',
                                  value: 'Diesel',
                                ),
                                OverViewRow(
                                  title: 'No. of Cylinders',
                                  value: '4',
                                ),
                                OverViewRow(
                                  title: 'Engine Capacity (cc)',
                                  value: '1995cc',
                                ),
                                Text(
                                  'See More',
                                  style: TextStyle(
                                    color: Color(0xFF35A2BC),
                                    fontSize: 14,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'RUSH GX | 2022 AGENCY MAINTAINED | 1.5L | SILVER COLOR | 7 SEATER | GCC | (677-MONTHLY)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'TOYOTA RUSH GX , AGENCY MAINTAINED , 2022 MODEL , 1.5L , SILVER COLOR , 7 SEATER , SUV , VERY GOOD CONDITION INTERIOR AND EXTERIOR.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'See More',
                            style: TextStyle(
                              color: Color(0xFF005729),
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFF4F4F4)),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Features',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 19),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSafetyExpanded = !_isSafetyExpanded;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Driver Assistance & Safety',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      _isSafetyExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              if (_isSafetyExpanded) ...[
                                const SizedBox(height: 16),
                                Opacity(
                                  opacity: 0.54,
                                  child: Text(
                                    _getFeaturesString(widget.car.safetyFeatures),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 1.71,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Divider(
                                color: const Color(0xFFF4F4F4).withOpacity(0.1),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isTechExpanded = !_isTechExpanded;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Entertainment & Technology',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      _isTechExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              if (_isTechExpanded) ...[
                                const SizedBox(height: 16),
                                Opacity(
                                  opacity: 0.54,
                                  child: Text(
                                    _getFeaturesString(widget.car.techFeatures),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 1.71,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Divider(
                                color: const Color(0xFFF4F4F4).withOpacity(0.1),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isComfortExpanded = !_isComfortExpanded;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Comfort & Convenience',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      _isComfortExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              if (_isComfortExpanded) ...[
                                const SizedBox(height: 16),
                                Opacity(
                                  opacity: 0.54,
                                  child: Text(
                                    _getFeaturesString(widget.car.comfortFeatures),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 1.71,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Divider(
                                color: const Color(0xFFF4F4F4).withOpacity(0.1),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExteriorExpanded = !_isExteriorExpanded;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Exterior',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      _isExteriorExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              if (_isExteriorExpanded) ...[
                                const SizedBox(height: 16),
                                Opacity(
                                  opacity: 0.54,
                                  child: Text(
                                    _getFeaturesString(widget.car.exteriorFeatures),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 1.71,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF1C1C1A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Car Finance Calculator',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    height: 1.11,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                    horizontal: 16,
                                  ),
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF505050),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Monthly Payment',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'AED ${_monthlyPayment.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.54,
                                            child: Text(
                                              'Total Loan Amount',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'AED ${_totalLoanAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.54,
                                            child: Text(
                                              'Total interest',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'AED ${_totalInterest.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Car Price',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      width: 121,
                                      height: 34,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF1C1C1A),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.04,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.54,
                                            child: Text(
                                              'AED',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _carPrice
                                                .toStringAsFixed(0)
                                                .replaceAllMapped(
                                                  RegExp(
                                                    r"(\d{1,3})(?=(\d{3})+(?!\d))",
                                                  ),
                                                  (Match m) => "${m[1]},",
                                                ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                _buildSlider(
                                  value: _carPrice,
                                  min: 10000,
                                  max: 500000,
                                  onChanged: (val) =>
                                      setState(() => _carPrice = val),
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Down Payment',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      height: 34,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF1C1C1A),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.04,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Opacity(
                                            opacity: 0.54,
                                            child: Text(
                                              'AED ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _downPaymentAmount
                                                .toStringAsFixed(0)
                                                .replaceAllMapped(
                                                  RegExp(
                                                    r"(\d{1,3})(?=(\d{3})+(?!\d))",
                                                  ),
                                                  (Match m) => "${m[1]},",
                                                ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '${_downPaymentPercent.toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                _buildSlider(
                                  value: _downPaymentPercent,
                                  min: 0,
                                  max: 100,
                                  onChanged: (val) =>
                                      setState(() => _downPaymentPercent = val),
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Interest Rate',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      height: 34,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF1C1C1A),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.04,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${_interestRate.toStringAsFixed(1)}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildSlider(
                                  value: _interestRate,
                                  min: 0,
                                  max: 20,
                                  onChanged: (val) =>
                                      setState(() => _interestRate = val),
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Loan Period',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: List.generate(5, (index) {
                                    int year = index + 1;
                                    bool isSelected = _loanPeriodYears == year;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(
                                          () => _loanPeriodYears = year,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          height: 40,
                                          decoration: ShapeDecoration(
                                            color: isSelected
                                                ? const Color(0xFF1C1C1A)
                                                : Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: isSelected
                                                    ? const Color(0xFF0FF0FC)
                                                    : Colors.white.withOpacity(
                                                        0.1,
                                                      ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$year',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Opacity(
                            opacity: 0.54,
                            child: Text(
                              widget.car.locationName ?? 'Location not provided',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF393938),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    double.tryParse(widget.car.latitude) ?? 25.2048,
                                    double.tryParse(widget.car.longitude) ?? 55.2708,
                                  ),
                                  zoom: 14,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('seller_location'),
                                    position: LatLng(
                                      double.tryParse(widget.car.latitude) ?? 25.2048,
                                      double.tryParse(widget.car.longitude) ?? 55.2708,
                                    ),
                                  ),
                                },
                                zoomControlsEnabled: false,
                                mapToolbarEnabled: false,
                                myLocationButtonEnabled: false,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Similar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 230,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: RecommendationWidget(
                                    index: index,
                                    car: widget.car,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }

  String _getFeaturesString(List<Feature> features) {
    if (features.isEmpty) return 'No features listed';
    return features.map((e) => e.name).join('\n');
  }

  String _formatPrice(String? price) {
    if (price == null) return '0';
    double? parsed = double.tryParse(price);
    if (parsed == null) return price;
    return parsed
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        activeTrackColor: const Color(0xFF0FF0FC),
        inactiveTrackColor: Colors.white.withOpacity(0.1),
        thumbColor: const Color(0xFF0FF0FC),
        overlayColor: const Color(0xFF0FF0FC).withOpacity(0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        trackShape: const _FullWidthSliderTrackShape(),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _FullWidthSliderTrackShape extends RoundedRectSliderTrackShape {
  const _FullWidthSliderTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class OverViewRow extends StatelessWidget {
  final String title;
  final String value;
  const OverViewRow({super.key, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
