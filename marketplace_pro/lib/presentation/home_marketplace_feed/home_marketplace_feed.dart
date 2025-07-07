import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/listing_card_widget.dart';
import './widgets/location_selector_widget.dart';

class HomeMarketplaceFeed extends StatefulWidget {
  const HomeMarketplaceFeed({Key? key}) : super(key: key);

  @override
  State<HomeMarketplaceFeed> createState() => _HomeMarketplaceFeedState();
}

class _HomeMarketplaceFeedState extends State<HomeMarketplaceFeed>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late RefreshIndicator _refreshIndicator;
  bool _isLoading = false;
  bool _isRefreshing = false;
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  String _selectedLocation = 'New York, NY';
  Set<String> _favoriteListings = {};

  // Mock data for listings
  final List<Map<String, dynamic>> _listings = [
    {
      "id": "1",
      "title": "iPhone 14 Pro Max - Excellent Condition",
      "price": "\$899",
      "location": "Manhattan, NY",
      "timePosted": "2 hours ago",
      "imageUrl":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=300&fit=crop",
      "category": "Electronics",
      "isSponsored": true,
      "isFavorite": false,
    },
    {
      "id": "2",
      "title": "Vintage Leather Sofa - Great for Living Room",
      "price": "\$450",
      "location": "Brooklyn, NY",
      "timePosted": "5 hours ago",
      "imageUrl":
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&h=300&fit=crop",
      "category": "Furniture",
      "isSponsored": false,
      "isFavorite": false,
    },
    {
      "id": "3",
      "title": "Mountain Bike - Trek X-Caliber 8",
      "price": "\$650",
      "location": "Queens, NY",
      "timePosted": "1 day ago",
      "imageUrl":
          "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop",
      "category": "Sports",
      "isSponsored": false,
      "isFavorite": false,
    },
    {
      "id": "4",
      "title": "Designer Handbag - Authentic Louis Vuitton",
      "price": "\$1,200",
      "location": "Manhattan, NY",
      "timePosted": "3 hours ago",
      "imageUrl":
          "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&h=300&fit=crop",
      "category": "Fashion",
      "isSponsored": true,
      "isFavorite": false,
    },
    {
      "id": "5",
      "title": "Gaming Setup - Complete PC Build",
      "price": "\$1,800",
      "location": "Bronx, NY",
      "timePosted": "6 hours ago",
      "imageUrl":
          "https://images.unsplash.com/photo-1593640408182-31c70c8268f5?w=400&h=300&fit=crop",
      "category": "Electronics",
      "isSponsored": false,
      "isFavorite": false,
    },
    {
      "id": "6",
      "title": "Dining Table Set - Seats 6 People",
      "price": "\$320",
      "location": "Staten Island, NY",
      "timePosted": "8 hours ago",
      "imageUrl":
          "https://images.unsplash.com/photo-1549497538-303791108f95?w=400&h=300&fit=crop",
      "category": "Furniture",
      "isSponsored": false,
      "isFavorite": false,
    },
  ];

  final List<String> _categories = [
    'All',
    'Electronics',
    'Furniture',
    'Fashion',
    'Sports',
    'Automotive',
    'Books',
    'Home & Garden'
  ];

  final List<String> _locations = [
    'New York, NY',
    'Los Angeles, CA',
    'Chicago, IL',
    'Houston, TX',
    'Phoenix, AZ',
    'Philadelphia, PA'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreListings();
    }
  }

  Future<void> _refreshListings() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _loadMoreListings() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleFavorite(String listingId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_favoriteListings.contains(listingId)) {
        _favoriteListings.remove(listingId);
      } else {
        _favoriteListings.add(listingId);
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onLocationChanged(String location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _onListingTap(Map<String, dynamic> listing) {
    Navigator.pushNamed(context, '/listing-detail', arguments: listing);
  }

  void _onListingLongPress(Map<String, dynamic> listing) {
    HapticFeedback.mediumImpact();
    _showQuickActions(listing);
  }

  void _showQuickActions(Map<String, dynamic> listing) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      'Share',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle share
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'report',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 24,
                    ),
                    title: Text(
                      'Report',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle report
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'visibility_off',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    title: Text(
                      'Hide similar',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle hide similar
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredListings {
    if (_selectedCategory == 'All') {
      return _listings;
    }
    return _listings
        .where(
            (listing) => (listing['category'] as String) == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Column(
                children: [
                  // Location and Notification Row
                  Row(
                    children: [
                      Expanded(
                        child: LocationSelectorWidget(
                          selectedLocation: _selectedLocation,
                          locations: _locations,
                          onLocationChanged: _onLocationChanged,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      GestureDetector(
                        onTap: () {
                          // Handle notification tap
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'notifications',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  // Category Chips
                  SizedBox(
                    height: 5.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: CategoryChipWidget(
                            category: _categories[index],
                            isSelected: _selectedCategory == _categories[index],
                            onTap: () =>
                                _onCategorySelected(_categories[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshListings,
                color: AppTheme.lightTheme.colorScheme.primary,
                child: _filteredListings.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        itemCount:
                            _filteredListings.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _filteredListings.length) {
                            return _buildLoadingIndicator();
                          }

                          final listing = _filteredListings[index];
                          final isFavorite =
                              _favoriteListings.contains(listing['id']);

                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: ListingCardWidget(
                              listing: listing,
                              isFavorite: isFavorite,
                              onTap: () => _onListingTap(listing),
                              onLongPress: () => _onListingLongPress(listing),
                              onFavoriteTap: () =>
                                  _toggleFavorite(listing['id'] as String),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              // Already on Home
              break;
            case 1:
              Navigator.pushNamed(context, '/search-and-filters');
              break;
            case 2:
              Navigator.pushNamed(context, '/create-listing');
              break;
            case 3:
              Navigator.pushNamed(context, '/chat-messaging');
              break;
            case 4:
              Navigator.pushNamed(context, '/user-profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-listing');
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No listings found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your location or category filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'All';
                });
              },
              child: const Text('Reset Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }
}
