import 'package:flutter/material.dart';
import 'package:superapp/Themes/app_colors.dart';

class CustomToast extends StatelessWidget {
  final String title;
  final String message;
  final bool isError;
  final VoidCallback? onClose;

  const CustomToast({
    super.key,
    required this.title,
    required this.message,
    this.isError = false,
    this.onClose,
  });

  /// static method to show the toast
  static void show(BuildContext context, {required String title, required String message, bool isError = false}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        right: 20, // Changed to right side
        width: MediaQuery.of(context).size.width * 0.8, // Set a max width
        child: Material(
          color: Colors.transparent,
          child: CustomToast(
            title: title,
            message: message,
            isError: isError,
            onClose: () {
              if (entry.mounted) {
                entry.remove();
              }
            },
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // Auto remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isError ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isError ? Colors.red.shade200 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isError ? Colors.red.shade100 : AppColors.btnColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isError ? Icons.error_outline : Icons.done_all,
              color: isError ? Colors.red : AppColors.btnColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onClose,
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
