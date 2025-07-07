import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;

class ImprovedKhilonjiyaSplashScreen extends StatefulWidget {
  const ImprovedKhilonjiyaSplashScreen({Key? key}) : super(key: key);

  @override
  State<ImprovedKhilonjiyaSplashScreen> createState() => _ImprovedKhilonjiyaSplashScreenState();
}

class _ImprovedKhilonjiyaSplashScreenState extends State<ImprovedKhilonjiyaSplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _categoryController;
  late AnimationController _progressController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _categoryScale;
  late Animation<double> _categoryOpacity;
  late Animation<double> _categoryRotation;
  late Animation<double> _progressOpacity;
  late Animation<double> _pulseScale;

  // State management
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  double _initializationProgress = 0.0;
  int _currentStepIndex = 0;

  // Initialization steps
  final List<InitializationStep> _initializationSteps = [
    InitializationStep('Checking authentication status...', 1000),
    InitializationStep('Loading user preferences...', 800),
    InitializationStep('Fetching location permissions...', 1200),
    InitializationStep('Preparing cultural content...', 900),
    InitializationStep('Setting up khilonjiya.com...', 1100),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // Category icons animation
    _categoryController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _categoryScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _categoryController, curve: Curves.elasticOut),
    );
    _categoryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _categoryController, curve: Curves.easeOut),
    );
    _categoryRotation = Tween<double>(begin: math.pi, end: 0.0).animate(
      CurvedAnimation(parent: _categoryController, curve: Curves.easeOut),
    );

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _progressOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
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
    _logoController.forward();
    
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) _categoryController.forward();
    });

    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _progressController.forward();
        _pulseController.repeat(reverse: true);
      }
    });

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
      
      // Simulate the initialization step
      await Future.delayed(Duration(milliseconds: _initializationSteps[i].duration));
      
      if (!mounted) return;
      
      setState(() {
        _initializationProgress = (i + 1) / _initializationSteps.length;
      });
    }
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    // Simulate checks
    final isAuthenticated = await _checkAuthenticationStatus();
    final isFirstTime = await _checkFirstTimeUser();

    String nextRoute;
    if (isFirstTime) {
      nextRoute = '/onboarding';
    } else if (isAuthenticated) {
      nextRoute = '/home';
    } else {
      nextRoute = '/login';
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
    _logoController.dispose();
    _categoryController.dispose();
    _progressController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF1A1A2E),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category icons
              _buildCategoryIcons(),
              
              const SizedBox(height: 80),
              
              // Main logo
              _buildMainLogo(),
              
              const SizedBox(height: 20),
              
              // App name and tagline
              _buildAppInfo(),
            ],
          ),
        ),
        
        // Progress section
        if (_isInitializing) _buildProgressSection(),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _retryInitialization,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
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

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(9, (index) {
            final progress = (_particleController.value + index * 0.1) % 1.0;
            final opacity = progress < 0.1 || progress > 0.9 ? 0.0 : 1.0;
            
            return Positioned(
              left: MediaQuery.of(context).size.width * (0.1 + index * 0.1),
              top: MediaQuery.of(context).size.height * (1.0 - progress),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 4,
                  height: 4,
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
      animation: Listenable.merge([_logoController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value * _pulseScale.value,
          child: Opacity(
            opacity: _logoOpacity.value,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF8C00), Color(0xFFFF6B35)],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'খ',
                  style: TextStyle(
                    fontSize: 80,
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
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacity.value,
          child: const Column(
            children: [
              Text(
                'khilonjiya.com',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'আমাৰ সংস্কৃতি, আমাৰ গৌৰৱ',
                style: TextStyle(
                  fontSize: 16,
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
    return SizedBox(
      height: 200,
      child: Stack(
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
            left: 0.25,
            top: 0.0,
            delay: 1200,
          ),
          _buildCategoryIcon(
            icon: '👔',
            label: 'Jobs',
            color: const LinearGradient(colors: [Color(0xFF28A745), Color(0xFF1E7E34)]),
            left: 0.80,
            top: 0.0,
            delay: 1000,
          ),
        ],
      ),
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
        final delayProgress = math.max(0.0, _categoryController.value - delay / 3000.0);
        final scale = Curves.elasticOut.transform(delayProgress * 3000 / 3000);
        final opacity = _categoryOpacity.value;
        
        return Positioned(
          left: MediaQuery.of(context).size.width * left - 30,
          top: top,
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: _categoryRotation.value,
              child: Opacity(
                opacity: opacity,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
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
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: _progressOpacity.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: LinearProgressIndicator(
                      value: _initializationProgress,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currentStepIndex < _initializationSteps.length
                        ? _initializationSteps[_currentStepIndex].message
                        : 'Ready to explore!',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper class for initialization steps
class InitializationStep {
  final String message;
  final int duration;

  InitializationStep(this.message, this.duration);
}

// Usage in your main app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khilonjiya',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const ImprovedKhilonjiyaSplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}

// Placeholder screens
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Khilonjiya')),
      body: const Center(child: Text('Onboarding Screen')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen')),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khilonjiya')),
      body: const Center(child: Text('Welcome to Khilonjiya!')),
    );
  }
}