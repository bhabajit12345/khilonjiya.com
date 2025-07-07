import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySelectionWidget extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelectionWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelectionWidget> createState() =>
      _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Electronics',
      'icon': 'smartphone',
      'subcategories': ['Phones', 'Laptops', 'Tablets', 'Accessories'],
    },
    {
      'name': 'Vehicles',
      'icon': 'directions_car',
      'subcategories': ['Cars', 'Motorcycles', 'Bicycles', 'Parts'],
    },
    {
      'name': 'Fashion',
      'icon': 'checkroom',
      'subcategories': ['Clothing', 'Shoes', 'Accessories', 'Bags'],
    },
    {
      'name': 'Home & Garden',
      'icon': 'home',
      'subcategories': ['Furniture', 'Appliances', 'Decor', 'Tools'],
    },
    {
      'name': 'Sports',
      'icon': 'sports_soccer',
      'subcategories': ['Equipment', 'Clothing', 'Outdoor', 'Fitness'],
    },
    {
      'name': 'Books',
      'icon': 'menu_book',
      'subcategories': ['Fiction', 'Non-fiction', 'Textbooks', 'Comics'],
    },
    {
      'name': 'Toys & Games',
      'icon': 'toys',
      'subcategories': [
        'Action Figures',
        'Board Games',
        'Educational',
        'Outdoor'
      ],
    },
    {
      'name': 'Services',
      'icon': 'build',
      'subcategories': ['Repair', 'Cleaning', 'Tutoring', 'Photography'],
    },
    {
      'name': 'Real Estate',
      'icon': 'apartment',
      'subcategories': ['Apartments', 'Houses', 'Commercial', 'Land'],
    },
    {
      'name': 'Jobs',
      'icon': 'work',
      'subcategories': ['Full-time', 'Part-time', 'Freelance', 'Internship'],
    },
    {
      'name': 'Pets',
      'icon': 'pets',
      'subcategories': ['Dogs', 'Cats', 'Birds', 'Accessories'],
    },
    {
      'name': 'Other',
      'icon': 'category',
      'subcategories': ['Miscellaneous', 'Collectibles', 'Art', 'Music'],
    },
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _categories;
    }
    return _categories.where((category) {
      final name = (category['name'] as String).toLowerCase();
      final subcategories = (category['subcategories'] as List<String>)
          .map((sub) => sub.toLowerCase())
          .toList();
      final query = _searchQuery.toLowerCase();

      return name.contains(query) ||
          subcategories.any((sub) => sub.contains(query));
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Category',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose the category that best describes your item',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search categories...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          SizedBox(height: 3.h),

          // Categories grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: _filteredCategories.length,
            itemBuilder: (context, index) {
              final category = _filteredCategories[index];
              final isSelected = widget.selectedCategory == category['name'];

              return GestureDetector(
                onTap: () =>
                    widget.onCategorySelected(category['name'] as String),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primaryContainer
                        : AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: category['icon'] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        category['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${(category['subcategories'] as List).length} subcategories',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Selected category details
          if (widget.selectedCategory.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Selected: ${widget.selectedCategory}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Subcategories available:',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: (_categories.firstWhere((cat) =>
                                cat['name'] ==
                                widget.selectedCategory)['subcategories']
                            as List<String>)
                        .map((subcategory) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Text(
                                subcategory,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
