import 'package:blog_application/Screens/login.dart';
import 'package:blog_application/components/blogpost.dart';
import 'package:blog_application/components/searchblogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final auth = FirebaseAuth.instance;
  final SearchController _searchbar = SearchController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: const Color.fromARGB(188, 12, 188, 156),
          title: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: Text(
              "Posts",
              style: GoogleFonts.jua(
                  color: const Color.fromARGB(188, 12, 188, 156), fontSize: 50),
            ),
          )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(188, 12, 188, 156),
              ),
              child: Center(
                child: Text(
                  "Welcome",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(LineIcons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Recent'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(LineIcons.user),
              title: const Text('Profile'),
              onTap: () {},
            ),
            const SizedBox(
              height: 100,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(LineIcons.alternateSignOut),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                const NavigatorPopHandler(
                  child: LoginScreen(),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: Column(
            children: [
              searchblogs(searchbar: _searchbar),
              const SizedBox(
                height: 30,
              ),
              const blogPost(
                  imageUrl: "", title: "Post 1", description: "Blogs"),
              const SizedBox(
                height: 10,
              ),
              const blogPost(
                  imageUrl: "", title: "Post 2", description: "Blogs"),
              const Row(
                children: [],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: GNav(
            // tab button hover color
            haptic: true, // haptic feedback

            curve: Curves.easeOutExpo, // tab animation curves
            duration:
                const Duration(milliseconds: 900), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Colors.grey[800], // unselected icon color
            activeColor: const Color.fromARGB(
                187, 255, 255, 255), // selected icon and text color
            iconSize: 24, // tab button icon size
            tabBackgroundColor: const Color.fromARGB(
                500, 12, 188, 156), // selected tab background color
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // navigation bar padding
            tabs: [
              const GButton(
                icon: LineIcons.home,
              ),
              GButton(
                icon: LineIcons.plus,
                iconSize: 30,
                onPressed: () => {Navigator.pushNamed(context, '/publishblog')},
              ),
              const GButton(
                icon: LineIcons.user,
              )
            ]),
      ),
    );
  }
}
