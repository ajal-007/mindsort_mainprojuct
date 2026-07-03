import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:mainsupabase_projuct/constants/color_constant.dart';

class ThoughtsPage extends StatefulWidget {
  const ThoughtsPage({super.key});

  @override
  State<ThoughtsPage> createState() => _ThoughtsPageState();
}

class _ThoughtsPageState extends State<ThoughtsPage> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Ideas', 'Tasks', 'Reflections', 'Dreams'];
  
  final List<Map<String, String>> _thoughts = [
    {
      'title': 'Cerebral Database Architecture',
      'category': 'Ideas',
      'time': '10 min ago',
      'content': 'We need a multi-tenant layout mapped with standard partition keys inside Supabase table metadata.',
      'color': '0xFF6C63FF',
    },
    {
      'title': 'Weekly Action Items',
      'category': 'Tasks',
      'time': '2 hours ago',
      'content': 'Finish refactoring the theme layout configurations, configure MultiProvider binding rules.',
      'color': '0xFF5EA8FF',
    },
    {
      'title': 'Reflective Journaling Session',
      'category': 'Reflections',
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
      duration: const Duration(milliseconds: 800),
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
        final matchesCategory = _selectedCategory == 'All' || thought['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _addThought(String title, String category, String content) {
    if (title.isEmpty || content.isEmpty) return;
    setState(() {
      String hexColor = '0xFF6C63FF';
      if (category == 'Ideas') hexColor = '0xFF6C63FF';
      if (category == 'Tasks') hexColor = '0xFF5EA8FF';
      if (category == 'Reflections') hexColor = '0xFF9D97FF';
      if (category == 'Dreams') hexColor = '0xFFFF7597';

      _thoughts.insert(0, {
        'title': title,
        'category': category,
        'time': 'Just now',
        'content': content,
        'color': hexColor,
      });
      _filterThoughts();
    });
    _cardEntranceController.reset();
    _cardEntranceController.forward();
  }

  void _showAddThoughtSheet() {
    String localCategory = 'Ideas';
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1527).withOpacity(0.9),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                                'Capture Thought',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.white60),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Title input
                          TextFormField(
                            controller: titleController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Thought title...',
                              hintStyle: const TextStyle(color: Colors.white30),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: MindSortColors.accent, width: 1.5),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
                          ),
                          const SizedBox(height: 18),
                          
                          // Category Selectors
                          SizedBox(
                            height: 38,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _categories.skip(1).map((cat) {
                                final isSel = localCategory == cat;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(
                                      cat,
                                      style: TextStyle(
                                        color: isSel ? Colors.white : Colors.white60,
                                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    selected: isSel,
                                    selectedColor: MindSortColors.accent,
                                    backgroundColor: Colors.black.withOpacity(0.04),
                                    checkmarkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                          const SizedBox(height: 18),
                          
                          // Content input
                          TextFormField(
                            controller: contentController,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Pour thoughts...',
                              hintStyle: const TextStyle(color: Colors.white30),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              contentPadding: const EdgeInsets.all(16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: MindSortColors.accent, width: 1.5),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Cannot save empty thought' : null,
                          ),
                          const SizedBox(height: 28),
                          
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
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [MindSortColors.accent, MindSortColors.blueAccent],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: MindSortColors.accent.withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Store Thought',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mind Space',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Manage your recorded mental models',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar & Filter Pills
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search_rounded, color: Colors.white38),
                                hintText: 'Search logged thoughts...',
                                hintStyle: TextStyle(color: Colors.white30, fontSize: 15),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
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
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  cat,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : Colors.white60,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                selected: isSel,
                                selectedColor: MindSortColors.accent,
                                backgroundColor: Colors.white.withOpacity(0.04),
                                checkmarkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSel ? Colors.transparent : Colors.white.withOpacity(0.05),
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

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Grid items list
              if (_filteredThoughts.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off_rounded,
                          size: 64,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No records found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
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
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
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
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.35),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    thought['title']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    thought['content']!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.65),
                                      fontSize: 14,
                                      height: 1.45,
                                    ),
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
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),

          // Floating Action Button
          Positioned(
            bottom: 16,
            right: 24,
            child: GestureDetector(
              onTap: _showAddThoughtSheet,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [MindSortColors.accent, MindSortColors.blueAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: MindSortColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
