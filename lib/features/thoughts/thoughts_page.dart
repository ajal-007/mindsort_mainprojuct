import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';

class ThoughtsPage extends StatefulWidget {
  const ThoughtsPage({super.key});

  @override
  State<ThoughtsPage> createState() => _ThoughtsPageState();
}

class _ThoughtsPageState extends State<ThoughtsPage> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _selectedCategory = AppText.catAll;

  final List<String> _categories = [
    AppText.catAll,
    AppText.catIdeas,
    AppText.catTasks,
    AppText.catReflections,
    AppText.catDreams
  ];
  
  final List<Map<String, String>> _thoughts = [
    {
      'title': 'Cerebral Database Architecture',
      'category': AppText.catIdeas,
      'time': '10 min ago',
      'content': 'We need a multi-tenant layout mapped with standard partition keys inside Supabase table metadata.',
      'color': '0xFF6C63FF',
    },
    {
      'title': 'Weekly Action Items',
      'category': AppText.catTasks,
      'time': '2 hours ago',
      'content': 'Finish refactoring the theme layout configurations, configure MultiProvider binding rules.',
      'color': '0xFF5EA8FF',
    },
    {
      'title': 'Reflective Journaling Session',
      'category': AppText.catReflections,
      'time': '1 day ago',
      'content': 'Focusing on incremental milestones reduces anxiety and helps track daily progress metrics.',
      'color': '0xFF9D97FF',
    },
  ];

  List<Map<String, String>> _filteredThoughts = [];

  late final AnimationController _cardEntranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _filteredThoughts = List.from(_thoughts);

    _cardEntranceController = AnimationController(
      vsync: this,
      duration: AppDuration.thoughtsEntrance,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _cardEntranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardEntranceController,
      curve: Curves.easeOutCubic,
    ));

    _cardEntranceController.forward();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _cardEntranceController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterThoughts();
  }

  void _filterThoughts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredThoughts = _thoughts.where((thought) {
        final matchesSearch = thought['title']!.toLowerCase().contains(query) ||
            thought['content']!.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == AppText.catAll || thought['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _addThought(String title, String category, String content) {
    if (title.isEmpty || content.isEmpty) return;
    setState(() {
      String hexColor = '0xFF6C63FF';
      if (category == AppText.catIdeas) hexColor = '0xFF6C63FF';
      if (category == AppText.catTasks) hexColor = '0xFF5EA8FF';
      if (category == AppText.catReflections) hexColor = '0xFF9D97FF';
      if (category == AppText.catDreams) hexColor = '0xFFFF7597';

      _thoughts.insert(0, {
        'title': title,
        'category': category,
        'time': AppText.timeJustNow,
        'content': content,
        'color': hexColor,
      });
      _filterThoughts();
    });
    _cardEntranceController.reset();
    _cardEntranceController.forward();
  }

  void _showAddThoughtSheet() {
    String localCategory = AppText.catIdeas;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.black.withOpacity(0.6),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.top30,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSheet.withOpacity(0.9),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.08),
                        width: 1.5,
                      ),
                      borderRadius: AppRadius.top30,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl, vertical: AppSizes.huge),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                AppText.captureThought,
                                style: AppTextStyles.thoughtsSheetTitle,
                              ),
                              IconButton(
                                icon: const Icon(AppIcons.close, color: AppColors.white),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                          const SizedBox(height: AppSizes.xxxl),
                          
                          // Title input
                          TextFormField(
                            controller: titleController,
                            style: AppTextStyles.thoughtsSheetInput,
                            decoration: InputDecoration(
                              hintText: AppText.thoughtTitleHint,
                              hintStyle: AppTextStyles.thoughtsSheetInputHint,
                              filled: true,
                              fillColor: AppColors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.lg),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.r16,
                                borderSide: BorderSide(color: AppColors.white.withOpacity(0.08)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppRadius.r16,
                                borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1.5),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty ? AppText.enterTitleValidator : null,
                          ),
                          const SizedBox(height: AppSizes.xl),
                          
                          // Category Selectors
                          SizedBox(
                            height: 38,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _categories.skip(1).map((cat) {
                                final isSel = localCategory == cat;
                                return Padding(
                                  padding: const EdgeInsets.only(right: AppSizes.sm),
                                  child: ChoiceChip(
                                    label: Text(
                                      cat,
                                      style: TextStyle(
                                        color: isSel ? AppColors.black : AppColors.white,
                                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    selected: isSel,
                                    selectedColor: AppColors.primaryAccent,
                                    backgroundColor: AppColors.black.withOpacity(0.04),
                                    checkmarkColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppRadius.r12,
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        setSheetState(() => localCategory = cat);
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: AppSizes.xl),
                          
                          // Content input
                          TextFormField(
                            controller: contentController,
                            style: AppTextStyles.thoughtsSheetInput,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: AppText.pourThoughtsHint,
                              hintStyle: AppTextStyles.thoughtsSheetInputHint,
                              filled: true,
                              fillColor: AppColors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.all(AppSizes.lg),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.r16,
                                borderSide: BorderSide(color: AppColors.white.withOpacity(0.08)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppRadius.r16,
                                borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1.5),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty ? AppText.emptyThoughtValidator : null,
                          ),
                          const SizedBox(height: AppSizes.giant),
                          
                          GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                _addThought(
                                  titleController.text,
                                  localCategory,
                                  contentController.text,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: AppRadius.r16,
                                gradient: const LinearGradient(
                                  colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryAccent.withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                AppText.storeThought,
                                style: AppTextStyles.thoughtsSheetSubmit,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl, vertical: AppSizes.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppText.mindSpace,
                        style: AppTextStyles.thoughtsTitle,
                      ),
                      const SizedBox(height: AppSizes.sxs),
                      Text(
                        AppText.manageMentalModels,
                        style: AppTextStyles.thoughtsSub,
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar & Filter Pills
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.r18,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.04),
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.08),
                              ),
                              borderRadius: AppRadius.r18,
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(AppIcons.search, color: AppColors.white),
                                hintText: AppText.searchThoughtsHint,
                                hintStyle: AppTextStyles.thoughtsSearchHint,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.xxl),
                      
                      // Choice Chips
                      SizedBox(
                        height: 38,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSel = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: AppSizes.sm),
                              child: ChoiceChip(
                                label: Text(
                                  cat,
                                  style: TextStyle(
                                    color: isSel ? AppColors.white : AppColors.white,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                selected: isSel,
                                selectedColor: AppColors.primaryAccent,
                                backgroundColor: AppColors.white.withOpacity(0.04),
                                checkmarkColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.r12,
                                  side: BorderSide(
                                    color: isSel ? AppColors.transparent : AppColors.white.withOpacity(0.05),
                                  ),
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedCategory = cat;
                                      _filterThoughts();
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxxl)),

              // Grid items list
              if (_filteredThoughts.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl, vertical: AppSizes.absolute),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AppIcons.cloudOff,
                          size: AppSizes.behemoth,
                          color: AppColors.white.withOpacity(0.15),
                        ),
                        const SizedBox(height: AppSizes.xl),
                        const Text(
                          AppText.noRecordsFound,
                          style: AppTextStyles.thoughtsEmptyTitle,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final thought = _filteredThoughts[index];
                        final colorVal = int.parse(thought['color']!);
                        final primaryColor = Color(colorVal);

                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: AppSizes.lg),
                              padding: const EdgeInsets.all(AppSizes.xxl),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.04),
                                borderRadius: AppRadius.r24,
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.08),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.msm, vertical: AppSizes.xs),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.15),
                                          borderRadius: AppRadius.r8,
                                          border: Border.all(
                                            color: primaryColor.withOpacity(0.35),
                                          ),
                                        ),
                                        child: Text(
                                          thought['category']!,
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        thought['time']!,
                                        style: AppTextStyles.thoughtsCardTime,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSizes.mlg),
                                  Text(
                                    thought['title']!,
                                    style: AppTextStyles.thoughtsCardTitle,
                                  ),
                                  const SizedBox(height: AppSizes.sm),
                                  Text(
                                    thought['content']!,
                                    style: AppTextStyles.thoughtsCardContent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _filteredThoughts.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSizes.absolute)),
            ],
          ),

          // Floating Action Button
          Positioned(
            bottom: AppSizes.lg,
            right: AppSizes.xxxl,
            child: GestureDetector(
              onTap: _showAddThoughtSheet,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(
                  AppIcons.add,
                  color: AppColors.white,
                  size: AppSizes.huge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
