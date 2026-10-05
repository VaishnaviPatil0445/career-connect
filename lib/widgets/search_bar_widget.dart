import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Neo-Brutalist Search Bar Widget.
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback? onFilterTap;
  final int activeFilterCount;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.onFilterTap,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neoBlack, width: 2.5),
        boxShadow: AppColors.neoShadow(offset: 4),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14, right: 10),
            child: Icon(
              Icons.search,
              color: AppColors.neoBlack,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.neoBlack,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                hintText: 'Search jobs or internships...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                filled: false,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.neoPink,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.neoBlack, width: 1.5),
                ),
                child: const Icon(Icons.close, size: 14, color: AppColors.neoBlack),
              ),
            ),
          if (onFilterTap != null) ...[
            Container(
              height: 28,
              width: 2,
              color: AppColors.neoBlack,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            GestureDetector(
              onTap: onFilterTap,
              child: Container(
                margin: const EdgeInsets.only(right: 8, left: 4),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: activeFilterCount > 0 ? AppColors.neoYellow : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.neoBlack, width: 2),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.tune,
                      size: 18,
                      color: AppColors.neoBlack,
                    ),
                    if (activeFilterCount > 0)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.neoPink,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.neoBlack, width: 1.5),
                          ),
                          child: Text(
                            '$activeFilterCount',
                            style: const TextStyle(
                              color: AppColors.neoBlack,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
