import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_market/core/constants/app_colors.dart';

// 👇 Screens & ViewModels
import 'package:job_market/features/auth/provider/session_provider.dart';
import 'package:job_market/features/auth/view/login_screen.dart';
import 'package:job_market/features/jobs/view/PostNewJob/post_new_job.dart';
import 'package:job_market/features/marketplace/viewmodels/marketplace_viewmodel.dart';

// 👇 Widgets
import 'package:job_market/features/marketplace/view/marketplace_components.dart';
import 'package:job_market/features/marketplace/view/marketplace_lists.dart';

class JobMarketplaceScreen extends ConsumerStatefulWidget {
  const JobMarketplaceScreen({super.key});

  @override
  ConsumerState<JobMarketplaceScreen> createState() =>
      _JobMarketplaceScreenState();
}

class _JobMarketplaceScreenState extends ConsumerState<JobMarketplaceScreen> {
    final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final sessionAsync = ref.watch(sessionProvider);
    final isLoggedIn = sessionAsync.value?.supabaseUser != null;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackgroundAlt,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Search bar ───
            const SizedBox(height: 8),
            MarketplaceSearchBar(
              controller: _searchController,
              onSearchChanged: (value) {
                ref
                    .read(marketplaceViewModelProvider.notifier)
                    .updateSearchQuery(value);
              },
            ),

            // ─── Categories ───
            MarketplaceCategories(
              onCategorySelected: (category) {
                ref
                    .read(marketplaceViewModelProvider.notifier)
                    .updateCategory(category);
              },
            ),

            const SectionHeader(
              title: 'Newly Listed Jobs',
              actionText: 'See All',
            ),

            const FeaturedJobsList(),

            const SectionHeader(title: 'Explore All Jobs', icon: Icons.sort),

            const RecentJobsList(),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isLoggedIn) {
            context.go('/jobs/new');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please log in to post a job')),
            );
            context.go('/login');
          }
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
