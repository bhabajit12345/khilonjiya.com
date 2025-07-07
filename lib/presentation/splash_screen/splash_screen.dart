import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late AnimationController _categoryController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _categoryScale;
  late Animation<double> _categoryOpacity;
  late Animation<double> _pulseScale;

  // State management
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  double _initializationProgress = 0.0;
  int _currentStepIndex = 0;

  // Initialization steps
  final List<String> _initializationSteps = [
    'Connecting to khilonjiya.com...',
    'Loading user preferences...',
    'Checking location permissions...',
    'Preparing cultural content...',
    'Finalizing marketplace setup...',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading animation
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Category animation
    _categoryController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _categoryScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _categoryController,
        curve: Curves.elasticOut,
      ),
    );

    _categoryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _categoryController,
        curve: Curves.easeOut,
      ),
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    _logoAnimationController.forward();
    _loadingAnimationController.repeat();
    
    // Start category animation after logo begins
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) _categoryController.forward();
    });

    // Start pulse animation
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) _pulseController.repeat(reverse: true);
    });

    // Start particle animation
    _particleController.repeat();
  }

  Future<void> _initializeApp() async {
    try {
      await _performInitializationSteps();

      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to initialize khilonjiya.com. Please check your connection and try again.';
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    for (int i = 0; i < _initializationSteps.length; i++) {
      if (!mounted) return;
      
      setState(() {
        _currentStepIndex = i;
        _initializationProgress = i / _initializationSteps.length;
      });
      
      await Future.delayed(const Duration(milliseconds: 600));
      
      if (!mounted) return;
      
      setState(() {
        _initializationProgress = (i + 1) / _initializationSteps.length;
      });
    }
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Simulate authentication check
    final isAuthenticated = await _checkAuthenticationStatus();
    final isFirstTime = await _checkFirstTimeUser();

    String nextRoute;
    if (isFirstTime) {
      nextRoute = '/onboarding-tutorial';
    } else if (isAuthenticated) {
      nextRoute = '/home-marketplace-feed';
    } else {
      nextRoute = '/login-screen';
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return false; // Mock: user not authenticated
  }

  Future<bool> _checkFirstTimeUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Mock: first time user
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isInitializing = true;
      _initializationProgress = 0.0;
      _currentStepIndex = 0;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    _categoryController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
                AppTheme.lightTheme.primaryColor,
              ],
            ),
          ),
          child: SafeArea(
            child: _hasError ? _buildErrorView() : _buildSplashContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return Stack(
      children: [
        // Floating particles
        _buildFloatingParticles(),
        
        // Main content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category icons
            SizedBox(
              height: 25.h,
              child: _buildCategoryIcons(),
            ),
            
            SizedBox(height: 5.h),
            
            // Main logo
            _buildMainLogo(),
            
            SizedBox(height: 3.h),
            
            // App info
            _buildAppInfo(),
          ],
        ),
        
        // Progress section
        if (_isInitializing) _buildProgressSection(),
      ],
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final progress = (_particleController.value + index * 0.125) % 1.0;
            final opacity = progress < 0.1 || progress > 0.9 ? 0.0 : 1.0;
            
            return Positioned(
              left: 100.w * (0.1 + index * 0.1),
              top: 100.h * (1.0 - progress),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 1.w,
                  height: 1.w,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMainLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoAnimationController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value * _pulseScale.value,
          child: Opacity(
            opacity: _logoFadeAnimation.value,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF8C00), Color(0xFFFF6B35)],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'খ',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppInfo() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Column(
            children: [
              Text(
                'khilonjiya.com',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'আমাৰ সংস্কৃতি, আমাৰ গৌৰৱ',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcons() {
    return Stack(
      children: [
        _buildCategoryIcon(
          icon: '🏘️',
          label: 'Properties',
          color: const LinearGradient(colors: [Color(0xFFFFA500), Color(0xFFFF8C00)]),
          left: 0.45,
          top: 0.0,
          delay: 800,
        ),
        _buildCategoryIcon(
          icon: '🎭',
          label: 'Culture',
          color: const LinearGradient(colors: [Color(0xFFDC3545), Color(0xFFC82333)]),
          left: 0.15,
          top: 0.0,
          delay: 1200,
        ),
        _buildCategoryIcon(
          icon: '👔',
          label: 'Jobs',
          color: const LinearGradient(colors: [Color(0xFF28A745), Color(0xFF1E7E34)]),
          left: 0.75,
          top: 0.0,
          delay: 1000,
        ),
      ],
    );
  }

  Widget _buildCategoryIcon({
    required String icon,
    required String label,
    required LinearGradient color,
    required double left,
    required double top,
    required int delay,
  }) {
    return AnimatedBuilder(
      animation: _categoryController,
      builder: (context, child) {
        final delayProgress = math.max(0.0, _categoryController.value - delay / 2500.0);
        final scale = Curves.elasticOut.transform(delayProgress * 2500 / 2500);
        final opacity = _categoryOpacity.value;
        
        return Positioned(
          left: 100.w * left - 8.w,
          top: top,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Column(
                children: [
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        icon,
                        style: TextStyle(fontSize: 6.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return Positioned(
      bottom: 10.h,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Container(
              height: 1.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
              child: LinearProgressIndicator(
                value: _initializationProgress,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _currentStepIndex < _initializationSteps.length
                  ? _initializationSteps[_currentStepIndex]
                  : 'Ready to explore!',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: _retryInitialization,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C00),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 5.w),
                  SizedBox(width: 2.w),
                  Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
