import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../components/CustomDrawer.dart';
import 'PostdataScreen.dart';
import 'Profile.dart';
import 'publish_Blog.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // Moved outside build method

  // List of widgets for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    PostdataScreen(),
    PublishBlog(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(188, 12, 188, 156),
        title: Text(
          "Posts",
          style: GoogleFonts.jua(
            color: const Color.fromARGB(188, 12, 188, 156),
            fontSize: 24, // Adjust the font size as needed
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor:
                  const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
              hoverColor:
                  const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: const Color.fromARGB(255, 255, 255, 255),
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                  onPressed: () {
                    _onItemTapped(0);
                  },
                ),
                GButton(
                  icon: LineIcons.plus,
                  text: 'Publish',
                  onPressed: () {
                    _onItemTapped(1);
                  },
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  onPressed: () {
                    _onItemTapped(2);
                  },
                ),
              ],
              selectedIndex: _selectedIndex,
            ),
          ),
        ),
      ),
    );
  }
}
