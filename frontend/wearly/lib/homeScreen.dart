//////////////////////////////// GOOD TO USE 1260//////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wearly/bestcomination_page.dart';
// import 'dart:math' as math;

// import 'package:wearly/mycollection_screen.dart';
// import 'package:wearly/season_screen.dart';
// import 'package:wearly/weeklyplanner_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with TickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   // Animation Controllers
//   late AnimationController _mainController;
//   late AnimationController _outfitController;
//   late AnimationController _floatingController;
//   late AnimationController _pulseController;

//   // Animations
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotateAnimation;

//   // Outfit Assembly Animations
//   late Animation<Offset> _shirtAnimation;
//   late Animation<Offset> _pantAnimation;
//   late Animation<Offset> _shoesAnimation;
//   late Animation<Offset> _accessoryAnimation;
//   late Animation<double> _outfitFadeAnimation;
//   late Animation<double> _pulseAnimation;

//   bool _showOutfit = false;
//   int _selectedOutfitIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _startAnimations();
//   }

//   void _initializeAnimations() {
//     // Main UI animations
//     _mainController = AnimationController(
//       duration: Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     // Outfit assembly animations
//     _outfitController = AnimationController(
//       duration: Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     // Floating elements
//     _floatingController = AnimationController(
//       duration: Duration(milliseconds: 3000),
//       vsync: this,
//     );

//     // Pulse effect
//     _pulseController = AnimationController(
//       duration: Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     // Main animations
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(parent: _mainController, curve: Curves.easeInOut));

//     _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
//         .animate(CurvedAnimation(
//             parent: _mainController, curve: Curves.easeOutCubic));

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//         CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));

//     _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(parent: _floatingController, curve: Curves.linear));

//     // Outfit assembly animations
//     _shirtAnimation = Tween<Offset>(begin: Offset(-2, -1), end: Offset(0, 0))
//         .animate(CurvedAnimation(
//             parent: _outfitController,
//             curve: Interval(0.0, 0.4, curve: Curves.elasticOut)));

//     _pantAnimation = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
//         .animate(CurvedAnimation(
//             parent: _outfitController,
//             curve: Interval(0.2, 0.6, curve: Curves.elasticOut)));

//     _shoesAnimation = Tween<Offset>(begin: Offset(0, 2), end: Offset(0, 0))
//         .animate(CurvedAnimation(
//             parent: _outfitController,
//             curve: Interval(0.4, 0.8, curve: Curves.elasticOut)));

//     _accessoryAnimation =
//         Tween<Offset>(begin: Offset(-1, -2), end: Offset(0, 0)).animate(
//             CurvedAnimation(
//                 parent: _outfitController,
//                 curve: Interval(0.6, 1.0, curve: Curves.elasticOut)));

//     _outfitFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(parent: _outfitController, curve: Curves.easeIn));

//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//         CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
//   }

//   void _startAnimations() {
//     _mainController.forward();
//     _floatingController.repeat();
//     _pulseController.repeat(reverse: true);

//     // Auto-start outfit animation after a delay
//     Future.delayed(Duration(milliseconds: 2000), () {
//       _showOutfitAnimation();
//     });
//   }

//   void _showOutfitAnimation() {
//     setState(() {
//       _showOutfit = true;
//     });
//     _outfitController.forward();
//     HapticFeedback.lightImpact();
//   }

//   void _nextOutfit() {
//     _outfitController.reset();
//     setState(() {});
//     _outfitController.forward();
//     HapticFeedback.selectionClick();
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     _outfitController.dispose();
//     _floatingController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Color(0xFF0a0a0a),
//       extendBodyBehindAppBar: true,
//       drawer: _buildDrawer(),
//       appBar: _buildAppBar(),
//       body: Stack(
//         children: [
//           _buildBackgroundGradient(),
//           _buildFloatingElements(),
//           _buildMainContent(),
//         ],
//       ),
//       floatingActionButton: _buildAnimatedFAB(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.black.withOpacity(0.2),
//       centerTitle: true,
//       title: ShaderMask(
//         shaderCallback: (Rect bounds) {
//           return LinearGradient(
//             colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ).createShader(bounds);
//         },
//         child: Text(
//           'Wearly',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//             letterSpacing: 1.2,
//           ),
//         ),
//       ),
//       leading: IconButton(
//         icon: Icon(Icons.menu_rounded, color: Colors.white),
//         onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//       ),
//       actions: [],
//     );
//   }

//   Widget _buildBackgroundGradient() {
//     return AnimatedBuilder(
//       animation: _rotateAnimation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF0a0a0a),
//                 Color(0xFF1a1a2e),
//                 Color(0xFF16213e),
//                 Color(0xFF0f0f23),
//               ],
//               stops: [0.0, 0.3, 0.7, 1.0],
//               transform: GradientRotation(_rotateAnimation.value * 0.1),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFloatingElements() {
//     return AnimatedBuilder(
//       animation: _floatingController,
//       builder: (context, child) {
//         return Stack(
//           children: [
//             _buildFloatingIcon('👔', 0.1, 0.2, 0.0),
//             _buildFloatingIcon('👖', 0.8, 0.15, 0.3),
//             _buildFloatingIcon('👟', 0.2, 0.7, 0.6),
//             _buildFloatingIcon('⌚', 0.85, 0.8, 0.9),
//             _buildFloatingIcon('👗', 0.1, 0.5, 0.4),
//             _buildFloatingIcon('👠', 0.9, 0.4, 0.7),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFloatingIcon(String icon, double x, double y, double delay) {
//     final animation = Tween<double>(begin: -10, end: 10).animate(
//       CurvedAnimation(
//         parent: _floatingController,
//         curve: Interval(delay, 1.0, curve: Curves.easeInOut),
//       ),
//     );

//     return Positioned(
//       left: MediaQuery.of(context).size.width * x,
//       top: MediaQuery.of(context).size.height * y,
//       child: Transform.translate(
//         offset: Offset(
//             0,
//             math.sin(_floatingController.value * 2 * math.pi +
//                     delay * 2 * math.pi) *
//                 10),
//         child: Opacity(
//           opacity: 0.3,
//           child: Text(
//             icon,
//             style: TextStyle(fontSize: 30),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent() {
//     return SafeArea(
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20),
//               _buildWelcomeSection(),
//               SizedBox(height: 40),
//               _buildStatsSection(),
//               SizedBox(height: 40),
//               _buildQuickActions(),
//               SizedBox(height: 120),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _getTimeBasedGreeting(),
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Scan Smart.Style Smarter.',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2,
//                 fontWeight: FontWeight.w800,
//                 height: 1.2,
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF667eea).withOpacity(0.3),
//                     Color(0xFF764ba2).withOpacity(0.3)
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white.withOpacity(0.1)),
//               ),
//               child: Text(
//                 '✨ AI-Powered Style Assistant',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsSection() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         padding: EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white.withOpacity(0.1),
//               Colors.white.withOpacity(0.05),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withOpacity(0.1)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildStatItem('142', 'Items', Icons.checkroom),
//             Container(
//                 width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
//             _buildStatItem('28', 'Outfits', Icons.style),
//             Container(
//                 width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
//             _buildStatItem('7', 'Worn', Icons.favorite),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String number, String label, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, color: Color(0xFF667eea), size: 24),
//         SizedBox(height: 8),
//         Text(
//           number,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.7),
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActions() {
//   final actions = [
//     {
//       'icon': Icons.camera_alt_rounded,
//       'title': 'Scan Item',
//       'subtitle': 'Add to wardrobe'
//     },
//     {
//       'icon': Icons.auto_awesome,
//       'title': 'Style Me',
//       'subtitle': 'AI suggestions'
//     },
//     {
//       'icon': Icons.calendar_today_rounded,
//       'title': 'Planner',
//       'subtitle': 'Weekly looks'
//     },
//     {
//       'icon': Icons.trending_up,
//       'title': 'Analytics',
//       'subtitle': 'Wear insights'
//     },
//   ];

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'Quick Actions',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 22,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       SizedBox(height: 16),
//       GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           childAspectRatio: 1.0, // Reduced from 1.2 for more vertical space
//         ),
//         itemCount: actions.length,
//         itemBuilder: (context, index) {
//           return ScaleTransition(
//             scale: Tween<double>(begin: 0.8, end: 1.0).animate(
//               CurvedAnimation(
//                 parent: _mainController,
//                 curve: Interval(0.2 * index, 0.8, curve: Curves.elasticOut),
//               ),
//             ),
//             child: GestureDetector(
//               onTap: () => HapticFeedback.lightImpact(),
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14), // Reduced vertical padding
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.white.withOpacity(0.1),
//                       Colors.white.withOpacity(0.05),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white.withOpacity(0.1)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       actions[index]['icon'] as IconData,
//                       color: Color(0xFF667eea),
//                       size: 32,
//                     ),
//                     SizedBox(height: 12),
//                     Text(
//                       actions[index]['title'] as String,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       actions[index]['subtitle'] as String,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.6),
//                         fontSize: 12,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     ],
//   );
// }
//   Widget _buildAnimatedFAB() {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0xFF667eea).withOpacity(0.4),
//               blurRadius: 20,
//               offset: Offset(0, 10),
//             ),
//           ],
//         ),
//         child: FloatingActionButton.extended(
//           onPressed: _showOutfitAnimation,
//           backgroundColor: Color(0xFF667eea),
//           elevation: 0,
//           icon: Icon(Icons.auto_awesome, color: Colors.white),
//           label: Text(
//             'Generate Look',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _getTimeBasedGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Good Morning';
//     if (hour < 17) return 'Good Afternoon';
//     return 'Good Evening';
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF0a0a0a),
//               Color(0xFF1a1a2e),
//               Color(0xFF16213e),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildDrawerHeader(),
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     SizedBox(height: 20),
//                     _buildDrawerItem(Icons.checkroom_rounded, 'My Collections',
//                         'Manage your wardrobe', () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => MyCollectionsPage()));
//                     }),
//                     _buildDrawerItem(
//                         Icons.auto_awesome_rounded,
//                         'Best Combinations',
//                         'AI-powered outfit suggestions', () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => BestCombinationPage()));
//                     }),
//                     _buildDrawerItem(Icons.wb_sunny_rounded, 'Seasons',
//                         'Weather-based styling', () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => SeasonScreen()));
//                     }),
//                     _buildDrawerItem(Icons.calendar_month_rounded,
//                         'Weekly Planner', 'Plan your weekly looks', () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => WeeklyPlannerPage()));
//                     }),
//                     _buildDrawerItem(Icons.analytics_rounded, 'Style Analytics',
//                         'Track your fashion trends', () {
//                       Navigator.pop(context);
//                     }),
//                     Container(
//                       margin:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       height: 1,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.transparent,
//                             Colors.white.withOpacity(0.3),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     ),
//                     _buildDrawerItem(Icons.settings_rounded, 'Settings',
//                         'Customize your experience', () {
//                       Navigator.pop(context);
//                     }),
//                     _buildDrawerItem(Icons.help_outline_rounded,
//                         'Help & Support', 'Get assistance', () {
//                       Navigator.pop(context);
//                     }),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerHeader() {
//     return Container(
//       padding: EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0xFF667eea).withOpacity(0.3),
//                       blurRadius: 15,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.person_rounded,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Siddharth Pujan',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Color(0xFF667eea).withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: Color(0xFF667eea).withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         '✨ Fashion Enthusiast',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderStat(String number, String label) {
//     return Column(
//       children: [
//         Text(
//           number,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.7),
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDrawerItem(
//       IconData icon, String title, String subtitle, VoidCallback onTap) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             HapticFeedback.lightImpact();
//             onTap();
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF667eea).withOpacity(0.3),
//                         Color(0xFF764ba2).withOpacity(0.3),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.6),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   color: Colors.white.withOpacity(0.4),
//                   size: 16,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//////////////////////////////// GOOD TO USE 2066 //////////////////////////////////////
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wearly/ARfeature_screen.dart';
import 'dart:math' as math;

import 'package:wearly/bestcomination_page.dart';
import 'package:wearly/mycollection_screen.dart';
import 'package:wearly/season_screen.dart';
import 'package:wearly/weeklyplanner_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Animation Controllers
  late AnimationController _mainController;
  late AnimationController _outfitController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  // Outfit Assembly Animations
  late Animation<Offset> _shirtAnimation;
  late Animation<Offset> _pantAnimation;
  late Animation<Offset> _shoesAnimation;
  late Animation<Offset> _accessoryAnimation;
  late Animation<double> _outfitFadeAnimation;
  late Animation<double> _pulseAnimation;

  bool _showOutfit = false;
  int _selectedOutfitIndex = 0;
  int? outfitCount;
  int _itemCount = 0;
  bool _isLoading = true;

  @override
void initState() {
  super.initState();
  _initializeAnimations();
  _startAnimations();
  fetchItemCount();
  fetchOutfitCount().then((count) {
    setState(() {
      outfitCount = count;
    });
  });
}

Future<void> fetchItemCount() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.10.171:8045/wardrobe/total'));
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _itemCount = data['total_items']; // <-- Fixed key
        _isLoading = false;
      });
    } else {
      print('Failed to load count with status ${response.statusCode}');
      setState(() => _isLoading = false);
    }
  } catch (e) {
    print('Exception: $e');
    setState(() => _isLoading = false);
  }
}

Future<int?> fetchOutfitCount() async {
  final url = Uri.parse("http://192.168.10.171:8045/outfits/count"); // Replace with your actual IP
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['total_outfits'] as int;
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}



  void _initializeAnimations() {
    // Main UI animations
    _mainController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Outfit assembly animations
    _outfitController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Floating elements
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    // Pulse effect
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Main animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _mainController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _floatingController, curve: Curves.linear));

    // Outfit assembly animations
    _shirtAnimation = Tween<Offset>(begin: Offset(-2, -1), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _outfitController,
            curve: Interval(0.0, 0.4, curve: Curves.elasticOut)));

    _pantAnimation = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _outfitController,
            curve: Interval(0.2, 0.6, curve: Curves.elasticOut)));

    _shoesAnimation = Tween<Offset>(begin: Offset(0, 2), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _outfitController,
            curve: Interval(0.4, 0.8, curve: Curves.elasticOut)));

    _accessoryAnimation =
        Tween<Offset>(begin: Offset(-1, -2), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _outfitController,
                curve: Interval(0.6, 1.0, curve: Curves.elasticOut)));

    _outfitFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _outfitController, curve: Curves.easeIn));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  void _startAnimations() {
    _mainController.forward();
    _floatingController.repeat();
    _pulseController.repeat(reverse: true);

    // Auto-start outfit animation after a delay
    Future.delayed(Duration(milliseconds: 2000), () {
      _showOutfitAnimation();
    });
  }

  void _showOutfitAnimation() {
    setState(() {
      _showOutfit = true;
    });
    _outfitController.forward();
    HapticFeedback.lightImpact();
  }

  void _nextOutfit() {
    _outfitController.reset();
    setState(() {});
    _outfitController.forward();
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _outfitController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF0a0a0a),
      extendBodyBehindAppBar: true,
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildFloatingElements(),
          _buildMainContent(),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.2),
      centerTitle: true,
      title: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Text(
          'Wearly',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu_rounded, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [],
    );
  }

  Widget _buildBackgroundGradient() {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0a0a0a),
                Color(0xFF1a1a2e),
                Color(0xFF16213e),
                Color(0xFF0f0f23),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
              transform: GradientRotation(_rotateAnimation.value * 0.1),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: [
            _buildFloatingIcon('👔', 0.1, 0.2, 0.0),
            _buildFloatingIcon('👖', 0.8, 0.15, 0.3),
            _buildFloatingIcon('👟', 0.2, 0.7, 0.6),
            _buildFloatingIcon('⌚', 0.85, 0.8, 0.9),
            _buildFloatingIcon('👗', 0.1, 0.5, 0.4),
            _buildFloatingIcon('👠', 0.9, 0.4, 0.7),
          ],
        );
      },
    );
  }

  Widget _buildFloatingIcon(String icon, double x, double y, double delay) {
    final animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Interval(delay, 1.0, curve: Curves.easeInOut),
      ),
    );

    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: MediaQuery.of(context).size.height * y,
      child: Transform.translate(
        offset: Offset(
            0,
            math.sin(_floatingController.value * 2 * math.pi +
                    delay * 2 * math.pi) *
                10),
        child: Opacity(
          opacity: 0.3,
          child: Text(
            icon,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildWelcomeSection(),
              SizedBox(height: 20),
              _buildStatsSection(),
              SizedBox(height: 10),
              _buildQuickActions(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTimeBasedGreeting(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your Smart Wardrobe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF667eea).withOpacity(0.3),
                    Color(0xFF764ba2).withOpacity(0.3)
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Text(
                '✨ AI-Powered Style Assistant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(_isLoading ? '...' : _itemCount.toString(),'Items',Icons.checkroom,),
            Container(
                width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
            _buildStatItem(outfitCount?.toString() ?? '...','Outfits',Icons.style,),

            Container(
                width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
            _buildStatItem('7', 'Worn', Icons.favorite),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF667eea), size: 24),
        SizedBox(height: 8),
        Text(
          number,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.camera_alt_rounded,
        'title': 'Scan Item',
        'subtitle': 'Add to wardrobe'
      },
      {
        'icon': Icons.auto_awesome,
        'title': 'Style Me',
        'subtitle': 'AI suggestions'
      },
      {
        'icon': Icons.calendar_today_rounded,
        'title': 'Planner',
        'subtitle': 'Weekly looks'
      },
      {
        'icon': Icons.trending_up,
        'title': 'Analytics',
        'subtitle': 'Wear insights'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        // SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _mainController,
                  curve: Interval(0.2 * index, 0.8, curve: Curves.elasticOut),
                ),
              ),
              child: GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        actions[index]['icon'] as IconData,
                        color: Color(0xFF667eea),
                        size: 32,
                      ),
                      SizedBox(height: 12),
                      Text(
                        actions[index]['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        actions[index]['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedFAB() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF667eea).withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showOutfitAnimation,
          backgroundColor: Color(0xFF667eea),
          elevation: 0,
          icon: Icon(Icons.auto_awesome, color: Colors.white),
          label: Text(
            'Generate Look',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0a0a0a),
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildDrawerHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: 20),
                    _buildDrawerItem(Icons.checkroom_rounded, 'My Collections',
                        'Manage your wardrobe', () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MyCollectionsPage()));
                    }),
                    _buildDrawerItem(
                        Icons.auto_awesome_rounded,
                        'Best Combinations',
                        'AI-powered outfit suggestions', () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BestCombinationPage()));
                    }),
                    _buildDrawerItem(Icons.wb_sunny_rounded, 'Seasons',
                        'Weather-based styling', () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SeasonScreen()));
                    }),
                    _buildDrawerItem(Icons.calendar_month_rounded,
                        'Weekly Planner', 'Plan your weekly looks', () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => WeeklyPlannerPage()));
                    }),
                    _buildDrawerItem(Icons.analytics_rounded, 'AR Feature',
    'Track your fashion trends', () {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => VirtualTryOnScreen()),
  );
}),

                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    _buildDrawerItem(Icons.settings_rounded, 'Settings',
                        'Customize your experience', () {
                      Navigator.pop(context);
                    }),
                    _buildDrawerItem(Icons.help_outline_rounded,
                        'Help & Support', 'Get assistance', () {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667eea).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Siddharth Pujan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF667eea).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFF667eea).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '✨ Fashion Enthusiast',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF667eea).withOpacity(0.3),
                        Color(0xFF764ba2).withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.4),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
