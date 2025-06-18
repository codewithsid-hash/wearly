// // import 'package:flutter/material.dart';
// // import 'package:wearly/scanner_page.dart';



// // class HomeScreen extends StatelessWidget {
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       drawer: Drawer(
// //         child: ListView(
// //           children: [
// //             const DrawerHeader(
// //               decoration: BoxDecoration(color: Colors.blue),
// //               child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.wb_sunny),
// //               title: Text('Seasons'),
// //               onTap: () {},
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.calendar_today),
// //               title: Text('Weekly Planner'),
// //               onTap: () {},
// //             ),
// //           ],
// //         ),
// //       ),
// //       appBar: AppBar(
// //         title: Text('Wardrobe'),
// //         leading: IconButton(
// //           icon: Icon(Icons.menu),
// //           onPressed: () => _scaffoldKey.currentState?.openDrawer(),
// //         ),
// //       ),
// //       body: Center(
// //         child: Text(
// //           'Welcome to Wardrobe!',
// //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.of(context).pushReplacement(
// //         MaterialPageRoute(builder: (context) => ScannerPage()),
// //         );
// //           // Open camera or upload action
// //         },
// //         backgroundColor: Colors.lightBlueAccent,
// //         child: Icon(Icons.camera_alt),
// //       ),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// //       bottomNavigationBar: BottomAppBar(
// //         shape: CircularNotchedRectangle(),
// //         notchMargin: 8.0,
// //         child: Container(
// //           height: 60.0,
// //           color: Colors.white,
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:wearly/scanner_page.dart';


// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with TickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late AnimationController _scaleController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
    
//     _fadeController = AnimationController(
//       duration: Duration(milliseconds: 1200),
//       vsync: this,
//     );
    
//     _slideController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _scaleController = AnimationController(
//       duration: Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));

//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.easeOutCubic,
//     ));

//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.elasticOut,
//     ));

//     // Start animations
//     _fadeController.forward();
//     Future.delayed(Duration(milliseconds: 200), () {
//       _slideController.forward();
//     });
//     Future.delayed(Duration(milliseconds: 400), () {
//       _scaleController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }

//   String _getTimeBasedGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Good Morning! ☀️';
//     } else if (hour < 17) {
//       return 'Good Afternoon! 🌤️';
//     } else {
//       return 'Good Evening! 🌙';
//     }
//   }

//   String _getTimeBasedMessage() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return 'Start your day with the perfect outfit. Your smart wardrobe assistant is here to help!';
//     } else if (hour < 17) {
//       return 'Looking for your next outfit? Let me help you find the perfect combination for today.';
//     } else {
//       return 'Planning tomorrow\'s look? Your smart wardrobe assistant is ready to help you shine.';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Color(0xFFF8F9FA),
//       drawer: _buildDrawer(),
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildWelcomeSection(),
//                   SizedBox(height: 30),
//                   // _buildQuickActionsSection(),
//                   // SizedBox(height: 30),
//                   _buildFeaturesSection(),
//                   SizedBox(height: 100), // Space for FAB
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildAnimatedFAB(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 120.0,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.white,
//       leading: IconButton(
//         icon: Icon(Icons.menu, color: Color(0xFF2D3436)),
//         onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         title: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Text(
//             'Wearly',
//             style: TextStyle(
//               color: Color(0xFF2D3436),
//               fontWeight: FontWeight.w700,
//               fontSize: 28,
//             ),
//           ),
//         ),
//         centerTitle: false,
//         titlePadding: EdgeInsets.only(left: 60, bottom: 16),
//       ),
//       actions: [
//         // IconButton(
//         //   icon: Icon(Icons.notifications_outlined, color: Color(0xFF2D3436)),
//         //   onPressed: () {},
//         // ),
//         // SizedBox(width: 8),
//       ],
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0xFF667eea).withOpacity(0.3),
//                 blurRadius: 20,
//                 offset: Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _getTimeBasedGreeting(),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 _getTimeBasedMessage(),
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.9),
//                   fontSize: 16,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Actions',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF2D3436),
//           ),
//         ),
//         SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionCard(
//                 'Scan Outfit',
//                 Icons.camera_alt,
//                 Color(0xFF00b894),
//                 () {},
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: _buildActionCard(
//                 'Plan Looks',
//                 Icons.calendar_today,
//                 Color(0xFF6c5ce7),
//                 () {},
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               SizedBox(height: 12),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3436),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeaturesSection() {
//     final features = [
//       {
//         'icon': Icons.camera_alt_outlined,
//         'title': 'Digitize Wardrobe',
//         'subtitle': 'Scan clothes with just your camera',
//         'color': Color(0xFF0984e3),
//       },
//       {
//         'icon': Icons.local_offer_outlined,
//         'title': 'Smart Tagging',
//         'subtitle': 'Auto-tag by type, color & frequency',
//         'color': Color(0xFFe17055),
//       },
//       {
//         'icon': Icons.wb_sunny_outlined,
//         'title': 'Weather Outfits',
//         'subtitle': 'Suggestions for weather & events',
//         'color': Color(0xFFfdcb6e),
//       },
//       {
//         'icon': Icons.event_note_outlined,
//         'title': 'Look Calendar',
//         'subtitle': 'Plan your weekly style',
//         'color': Color(0xFF6c5ce7),
//       },
//       {
//         'icon': Icons.search,
//         'title': 'Discover Combos',
//         'subtitle': 'Find unused clothes & missing pieces',
//         'color': Color(0xFF00b894),
//       },
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'What Wearly Can Do',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF2D3436),
//           ),
//         ),
//         SizedBox(height: 16),
//         ...features.asMap().entries.map((entry) {
//           int index = entry.key;
//           Map<String, dynamic> feature = entry.value;
          
//           return FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: Tween<Offset>(
//                 begin: Offset(0.3, 0),
//                 end: Offset.zero,
//               ).animate(CurvedAnimation(
//                 parent: _slideController,
//                 curve: Interval(
//                   index * 0.1,
//                   0.6 + (index * 0.1),
//                   curve: Curves.easeOutCubic,
//                 ),
//               )),
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 12),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: feature['color'].withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         feature['icon'],
//                         color: feature['color'],
//                         size: 20,
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             feature['title'],
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF2D3436),
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             feature['subtitle'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF636e72),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       size: 16,
//                       color: Color(0xFFddd),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }

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
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => ScannerPage()),
//     );
//             // Open camera action with haptic feedback
//           },
//           backgroundColor: Color(0xFF667eea),
//           elevation: 0,
//           child: Icon(Icons.camera_alt, color: Colors.white, size: 28),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: Offset(0, -5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         child: BottomAppBar(
//           shape: CircularNotchedRectangle(),
//           notchMargin: 8.0,
//           color: Colors.white,
//           elevation: 0,
//           child: Container(
//             height: 65,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 // _buildNavItem(
//                 //   icon: Icons.home_outlined,
//                 //   activeIcon: Icons.home,
//                 //   label: 'Home',
//                 //   index: 0,
//                 // ),
//                 // _buildNavItem(
//                 //   icon: Icons.checkroom_outlined,
//                 //   activeIcon: Icons.checkroom,
//                 //   label: 'Wardrobe',
//                 //   index: 1,
//                 // ),
//                 // SizedBox(width: 40), // Space for FAB
//                 // _buildNavItem(
//                 //   icon: Icons.calendar_today_outlined,
//                 //   activeIcon: Icons.calendar_today,
//                 //   label: 'Planner',
//                 //   index: 2,
//                 // ),
//                 // _buildNavItem(
//                 //   icon: Icons.person_outline,
//                 //   activeIcon: Icons.person,
//                 //   label: 'Profile',
//                 //   index: 3,
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//     required int index,
//   }) {
//     bool isActive = _currentIndex == index;
    
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: isActive ? Color(0xFF667eea).withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedSwitcher(
//               duration: Duration(milliseconds: 200),
//               child: Icon(
//                 isActive ? activeIcon : icon,
//                 key: ValueKey(isActive),
//                 color: isActive ? Color(0xFF667eea) : Color(0xFF636e72),
//                 size: 24,
//               ),
//             ),
//             SizedBox(height: 4),
//             AnimatedDefaultTextStyle(
//               duration: Duration(milliseconds: 200),
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
//                 color: isActive ? Color(0xFF667eea) : Color(0xFF636e72),
//               ),
//               child: Text(label),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: ListView(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white.withOpacity(0.2),
//                     child: Icon(Icons.person, color: Colors.white, size: 30),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     'Siddharth Pujan',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     'Fashion Enthusiast',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             _buildDrawerItem(Icons.wb_sunny, 'Seasons', () {}),
//             _buildDrawerItem(Icons.calendar_today, 'Weekly Planner', () {}),
//             _buildDrawerItem(Icons.favorite, 'Favorites', () {}),
//             _buildDrawerItem(Icons.analytics, 'Style Analytics', () {}),
//             _buildDrawerItem(Icons.settings, 'Settings', () {}),
//             Divider(color: Colors.white.withOpacity(0.3)),
//             _buildDrawerItem(Icons.help_outline, 'Help & Support', () {}),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(
//         title,
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//       ),
//       onTap: onTap,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:wearly/scanner_page.dart';
import 'package:wearly/season_screen.dart';
import 'package:wearly/services/view_tags_page.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(Duration(milliseconds: 400), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning! ☀️';
    } else if (hour < 17) {
      return 'Good Afternoon! 🌤️';
    } else {
      return 'Good Evening! 🌙';
    }
  }

  String _getTimeBasedMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Start your day with the perfect outfit. Your smart wardrobe assistant is here to help!';
    } else if (hour < 17) {
      return 'Looking for your next outfit? Let me help you find the perfect combination for today.';
    } else {
      return 'Planning tomorrow\'s look? Your smart wardrobe assistant is ready to help you shine.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF8F9FA),
      drawer: _buildDrawer(),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  SizedBox(height: 30),
                  _buildFeaturesSection(),
                  SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildCurvedBottomNavigationBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Color(0xFF2D3436)),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Wearly',
            style: TextStyle(
              color: Color(0xFF2D3436),
              fontWeight: FontWeight.w700,
              fontSize: 28,
            ),
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 60, bottom: 16),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF667eea).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTimeBasedGreeting(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _getTimeBasedMessage(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {
        'icon': Icons.camera_alt_outlined,
        'title': 'Digitize Wardrobe',
        'subtitle': 'Scan clothes with just your camera',
        'color': Color(0xFF0984e3),
      },
      {
        'icon': Icons.local_offer_outlined,
        'title': 'Smart Tagging',
        'subtitle': 'Auto-tag by type, color & frequency',
        'color': Color(0xFFe17055),
      },
      {
        'icon': Icons.wb_sunny_outlined,
        'title': 'Weather Outfits',
        'subtitle': 'Suggestions for weather & events',
        'color': Color(0xFFfdcb6e),
      },
      {
        'icon': Icons.event_note_outlined,
        'title': 'Look Calendar',
        'subtitle': 'Plan your weekly style',
        'color': Color(0xFF6c5ce7),
      },
      {
        'icon': Icons.search,
        'title': 'Discover Combos',
        'subtitle': 'Find unused clothes & missing pieces',
        'color': Color(0xFF00b894),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Wearly Can Do',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3436),
          ),
        ),
        SizedBox(height: 16),
        ...features.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> feature = entry.value;
          
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.3, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _slideController,
                curve: Interval(
                  index * 0.1,
                  0.6 + (index * 0.1),
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: feature['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature['icon'],
                        color: feature['color'],
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            feature['subtitle'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF636e72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFFddd),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ScannerPage()),
            );
          },
          backgroundColor: Color(0xFF667eea),
          elevation: 0,
          child: Icon(Icons.camera_alt, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildCurvedBottomNavigationBar() {
    return Container(
      height: 80,
      child: CustomPaint(
        painter: CurvedBottomNavPainter(),
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    bool isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF667eea).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? Color(0xFF667eea) : Color(0xFF636e72),
                size: 20,
              ),
            ),
            SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? Color(0xFF667eea) : Color(0xFF636e72),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Siddharth Pujan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Fashion Enthusiast',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.settings, 'My collections', () {}),
            _buildDrawerItem(Icons.favorite, 'Favorites', () {}),
            _buildDrawerItem(Icons.wb_sunny, 'Seasons', () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeasonScreen()),
      );
}),

            _buildDrawerItem(Icons.calendar_today, 'Weekly Planner', () {}),
            _buildDrawerItem(Icons.analytics, 'Style Analytics', () {}),
            _buildDrawerItem(Icons.label_outline, 'View Saved Tags', () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ViewTagsPage()),
  );
}),
            Divider(color: Colors.white.withOpacity(0.3)),
            _buildDrawerItem(Icons.help_outline, 'Help & Support', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

// Custom painter for curved bottom navigation bar
class CurvedBottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();
    final shadowPath = Path();
    
    // Start from left
    path.moveTo(0, 20);
    shadowPath.moveTo(0, 20);
    
    // Curve to the notch
    path.quadraticBezierTo(size.width * 0.35, 20, size.width * 0.40, 0);
    shadowPath.quadraticBezierTo(size.width * 0.35, 20, size.width * 0.40, 0);
    
    // Create the notch for FAB
    path.quadraticBezierTo(size.width * 0.45, -10, size.width * 0.50, -10);
    shadowPath.quadraticBezierTo(size.width * 0.45, -10, size.width * 0.50, -10);
    
    path.quadraticBezierTo(size.width * 0.55, -10, size.width * 0.60, 0);
    shadowPath.quadraticBezierTo(size.width * 0.55, -10, size.width * 0.60, 0);
    
    // Curve to the right
    path.quadraticBezierTo(size.width * 0.65, 20, size.width, 20);
    shadowPath.quadraticBezierTo(size.width * 0.65, 20, size.width, 20);
    
    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    shadowPath.lineTo(size.width, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.close();

    // Draw shadow
    canvas.drawPath(shadowPath, shadowPaint);
    
    // Draw the main shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}