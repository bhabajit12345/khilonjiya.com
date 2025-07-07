import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_results_widget.dart';
import './widgets/trending_keywords_widget.dart';

class SearchAndFilters extends StatefulWidget {
  const SearchAndFilters({Key? key}) : super(key: key);

  @override
  State<SearchAndFilters> createState() => _SearchAndFiltersState();
}

class _SearchAndFiltersState extends State<SearchAndFilters>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearching = false;
  bool _showSuggestions = false;
  bool _isGridView = true;
  bool _showMapView = false;
  String _sortBy = 'Relevance';

  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _recentSearches = [];
  List<String> _trendingKeywords = [];

  late TabController _tabController;

  // Mock data
  final List<Map<String, dynamic>> _mockResults = [
    {
      "id": 1,
      "title": "iPhone 14 Pro Max - Excellent Condition",
      "price": "\$899",
      "location": "New York, NY",
      "distance": "2.5 km",
      "condition": "Like New",
      "images": [
        "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400"
      ],
      "seller": "John Doe",
      "rating": 4.8,
      "verified": true,
      "datePosted": "2 hours ago",
      "category": "Electronics"
    },
    {
      "id": 2,
      "title": "Vintage Leather Sofa - Brown",
      "price": "\$450",
      "location": "Brooklyn, NY",
      "distance": "5.2 km",
      "condition": "Good",
      "images": [
        "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400"
      ],
      "seller": "Sarah Wilson",
      "rating": 4.5,
      "verified": false,
      "datePosted": "1 day ago",
      "category": "Furniture"
    },
    {
      "id": 3,
      "title": "Mountain Bike - Trek 2023",
      "price": "\$650",
      "location": "Manhattan, NY",
      "distance": "3.8 km",
      "condition": "Excellent",
      "images": [
        "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400"
      ],
      "seller": "Mike Johnson",
      "rating": 4.9,
      "verified": true,
      "datePosted": "3 hours ago",
      "category": "Sports"
    },
    {
      "id": 4,
      "title": "Designer Handbag - Authentic",
      "price": "\$320",
      "location": "Queens, NY",
      "distance": "7.1 km",
      "condition": "Like New",
      "images": [
        "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400"
      ],
      "seller": "Emma Davis",
      "rating": 4.7,
      "verified": true,
      "datePosted": "5 hours ago",
      "category": "Fashion"
    }
  ];

  final List<String> _mockRecentSearches = [
    "iPhone 14",
    "Vintage furniture",
    "Mountain bike",
    "Designer bags",
    "Gaming laptop"
  ];

  final List<String> _mockTrendingKeywords = [
    "iPhone 14 Pro",
    "Vintage sofa",
    "Gaming setup",
    "Designer handbag",
    "Electric bike",
    "Home decor"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchResults = _mockResults;
    _recentSearches = _mockRecentSearches;
    _trendingKeywords = _mockTrendingKeywords;

    _searchFocusNode.addListener(() {
      setState(() {
        _showSuggestions =
            _searchFocusNode.hasFocus && _searchController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _showSuggestions = query.isEmpty && _searchFocusNode.hasFocus;
    });

    if (query.isNotEmpty) {
      _performSearch(query);
    }
  }

  void _performSearch(String query) {
    // Simulate search with filtering
    final filteredResults = _mockResults.where((item) {
      final title = (item['title'] as String).toLowerCase();
      final category = (item['category'] as String).toLowerCase();
      final searchQuery = query.toLowerCase();

      return title.contains(searchQuery) || category.contains(searchQuery);
    }).toList();

    setState(() {
      _searchResults = filteredResults;
    });
  }

  void _onFilterApplied(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filteredResults = List.from(_mockResults);

    // Apply category filter
    if (_activeFilters['category'] != null &&
        (_activeFilters['category'] as String).isNotEmpty) {
      filteredResults = filteredResults
          .where((item) =>
              (item['category'] as String).toLowerCase() ==
              (_activeFilters['category'] as String).toLowerCase())
          .toList();
    }

    // Apply price range filter
    if (_activeFilters['minPrice'] != null &&
        _activeFilters['maxPrice'] != null) {
      filteredResults = filteredResults.where((item) {
        final priceStr =
            (item['price'] as String).replaceAll('\$', '').replaceAll(',', '');
        final price = double.tryParse(priceStr) ?? 0;
        return price >= (_activeFilters['minPrice'] as double) &&
            price <= (_activeFilters['maxPrice'] as double);
      }).toList();
    }

    // Apply condition filter
    if (_activeFilters['condition'] != null &&
        (_activeFilters['condition'] as String).isNotEmpty) {
      filteredResults = filteredResults
          .where((item) =>
              (item['condition'] as String) ==
              (_activeFilters['condition'] as String))
          .toList();
    }

    setState(() {
      _searchResults = filteredResults;
    });
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _activeFilters.remove(filterKey);
    });
    _applyFilters();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _searchResults = _mockResults;
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ...[
              'Relevance',
              'Price: Low to High',
              'Price: High to Low',
              'Distance',
              'Date Posted'
            ].map((option) => ListTile(
                  title: Text(option),
                  trailing: _sortBy == option
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20)
                      : null,
                  onTap: () {
                    setState(() {
                      _sortBy = option;
                    });
                    Navigator.pop(context);
                    _applySorting();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _applySorting() {
    List<Map<String, dynamic>> sortedResults = List.from(_searchResults);

    switch (_sortBy) {
      case 'Price: Low to High':
        sortedResults.sort((a, b) {
          final priceA = double.tryParse((a['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          final priceB = double.tryParse((b['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        sortedResults.sort((a, b) {
          final priceA = double.tryParse((a['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          final priceB = double.tryParse((b['price'] as String)
                  .replaceAll('\$', '')
                  .replaceAll(',', '')) ??
              0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'Distance':
        sortedResults.sort((a, b) {
          final distanceA = double.tryParse(
                  (a['distance'] as String).replaceAll(' km', '')) ??
              0;
          final distanceB = double.tryParse(
                  (b['distance'] as String).replaceAll(' km', '')) ??
              0;
          return distanceA.compareTo(distanceB);
        });
        break;
    }

    setState(() {
      _searchResults = sortedResults;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        activeFilters: _activeFilters,
        onFiltersApplied: _onFilterApplied,
      ),
    );
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _onSearchChanged(search);
    _searchFocusNode.unfocus();
  }

  void _onTrendingKeywordTap(String keyword) {
    _searchController.text = keyword;
    _onSearchChanged(keyword);
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Search & Filters',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showMapView = !_showMapView;
              });
            },
            icon: CustomIconWidget(
              iconName: _showMapView ? 'list' : 'map',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _onSearchChanged,
                  onFilterPressed: _showFilterModal,
                ),
                if (_activeFilters.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  FilterChipsWidget(
                    activeFilters: _activeFilters,
                    onRemoveFilter: _removeFilter,
                    onClearAll: _clearAllFilters,
                  ),
                ],
              ],
            ),
          ),

          // Suggestions Section
          if (_showSuggestions && !_isSearching)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecentSearchesWidget(
                      recentSearches: _recentSearches,
                      onSearchTap: _onRecentSearchTap,
                    ),
                    SizedBox(height: 3.h),
                    TrendingKeywordsWidget(
                      trendingKeywords: _trendingKeywords,
                      onKeywordTap: _onTrendingKeywordTap,
                    ),
                  ],
                ),
              ),
            ),

          // Results Section
          if (_isSearching || _activeFilters.isNotEmpty)
            Expanded(
              child: Column(
                children: [
                  // Results Header
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_searchResults.length} results found',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _showSortOptions,
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'sort',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    _sortBy,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4.w),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isGridView = !_isGridView;
                                });
                              },
                              child: CustomIconWidget(
                                iconName:
                                    _isGridView ? 'view_list' : 'grid_view',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Results List/Grid
                  Expanded(
                    child: _showMapView
                        ? _buildMapView()
                        : SearchResultsWidget(
                            results: _searchResults,
                            isGridView: _isGridView,
                          ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'map',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Map View',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Interactive map with listing locations',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
