import 'package:flutter/material.dart';
import '../models/job.dart';
import '../utils/app_colors.dart';

/// Neo-Brutalist Job Card widget.
/// Bold black outlines, hard unblurred drop shadows, and high-energy color blocking.
class JobCard extends StatelessWidget {
  final Job job;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  const JobCard({
    super.key,
    required this.job,
    required this.isSaved,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  // Pick vibrant Neo-Brutal color for company avatar
  Color _getNeoAvatarColor(String monogram) {
    final colors = [
      AppColors.neoYellow,
      AppColors.neoCyan,
      AppColors.neoPink,
      AppColors.neoGreen,
      AppColors.neoPurple,
      AppColors.neoOrange,
    ];
    final hash = monogram.codeUnits.fold(0, (prev, elem) => prev + elem);
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isInternship = job.jobType.toLowerCase().contains('intern');
    final isRemote = job.workMode.toLowerCase().contains('remote');
    final isHybrid = job.workMode.toLowerCase().contains('hybrid');
    final avatarColor = _getNeoAvatarColor(job.companyLogoText);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neoBlack, width: 2.5),
        boxShadow: AppColors.neoShadow(offset: 4.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Title & Company + Neo Bookmark Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Neo-Brutal Company Avatar Box
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: avatarColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.neoBlack, width: 2),
                        boxShadow: AppColors.neoShadow(offset: 2.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        job.companyLogoText,
                        style: const TextStyle(
                          color: AppColors.neoBlack,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Job Title and Company
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.neoBlack,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            job.company,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Neo Bookmark Button
                    GestureDetector(
                      onTap: onBookmarkToggle,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSaved ? AppColors.neoYellow : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.neoBlack, width: 2),
                          boxShadow: AppColors.neoShadow(offset: 2),
                        ),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.neoBlack,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Badges / Tags Row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Job Type Badge
                    _buildNeoPill(
                      label: job.jobType,
                      bgColor: isInternship ? AppColors.neoCyan : AppColors.neoYellow,
                    ),

                    // Work Mode Badge
                    _buildNeoPill(
                      label: job.workMode,
                      icon: isRemote
                          ? Icons.wifi_tethering
                          : (isHybrid ? Icons.home_work_outlined : Icons.business),
                      bgColor: isRemote
                          ? AppColors.neoGreen
                          : (isHybrid ? AppColors.neoPink : const Color(0xFFE5E7EB)),
                    ),

                    // Location Badge
                    _buildNeoPill(
                      label: job.location,
                      icon: Icons.location_on_outlined,
                      bgColor: Colors.white,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Short Description
                Text(
                  job.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Tech Skills Pills (First 3 skills)
                if (job.skills.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: job.skills.take(3).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.neoBlack, width: 1.2),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neoBlack,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                const Divider(height: 1, color: AppColors.neoBlack, thickness: 1.2),
                const SizedBox(height: 10),

                // Footer: Salary & Posted Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.neoYellow,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.neoBlack, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.payments_outlined,
                            size: 14,
                            color: AppColors.neoBlack,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            job.salary,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.neoBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          job.postedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: AppColors.neoBlack,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeoPill({
    required String label,
    IconData? icon,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.neoBlack, width: 1.5),
        boxShadow: AppColors.neoShadow(offset: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.neoBlack),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.neoBlack,
            ),
          ),
        ],
      ),
    );
  }
}
