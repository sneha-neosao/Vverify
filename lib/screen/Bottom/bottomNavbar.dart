import 'package:flutter/material.dart';
import 'package:v_verify/screen/Home%20screen/home_page.dart';
import 'package:v_verify/screen/ProfileScreen/ProfilePage.dart';

import '../VerificationPending/Pagination/pending_doc_Pagination.dart';

int selectedIndex = 0;

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  // int _selectedIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    PendingDocPagination(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body:
              //screens[selectedIndex],
              IndexedStack(
            index: selectedIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigation(
            selectedIndex: selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF202020),
          currentIndex: selectedIndex,
          selectedItemColor: const Color(0xFFF67D3C),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fingerprint),
              label: 'VV',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ));
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../router/router.dart';
//
// class Bottomnavbar extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<Bottomnavbar> {
//   int _selectedIndex = 0;
//
//   // The list of routes to be used with BottomNavigationBar
//   final List<String> _routes = ['/homeScreen', '/PendingDoc', '/ProfilePage'];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     context.go(_routes[index]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Flutter BottomNav & GoRouter',
//       routerConfig: AppRouter.router,
//       builder: (context, child) {
//         return Scaffold(
//           appBar: AppBar(title: Text("Flutter Navigation")),
//           body: child,
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _selectedIndex,
//             onTap: _onItemTapped,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.search),
//                 label: 'Search',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.account_circle),
//                 label: 'Profile',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
