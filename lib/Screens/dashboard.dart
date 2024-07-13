import 'package:blog_application/components/blogpost.dart';
import 'package:blog_application/components/searchblogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../components/CustomDrawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            "Posts",
            style: GoogleFonts.jua(
              color: const Color.fromARGB(188, 12, 188, 156),
              fontSize: 50,
            ),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              searchblogs(searchbar: _searchbar),
              const SizedBox(height: 30),
              const blogPost(
                  imageUrl: "", title: "Post 1", description: "Blogs"),
              const SizedBox(height: 10),
              const blogPost(
                  imageUrl: "", title: "Post 2", description: "Blogs"),
              const Row(children: []),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: GNav(
          haptic: true,
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 900),
          gap: 8,
          color: Colors.grey[800],
          activeColor: const Color.fromARGB(187, 255, 255, 255),
          iconSize: 24,
          tabBackgroundColor: const Color.fromARGB(500, 12, 188, 156),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          tabs: [
            const GButton(
              icon: LineIcons.home,
            ),
            GButton(
              icon: LineIcons.plus,
              iconSize: 30,
              onPressed: () => Navigator.pushNamed(context, '/publishblog'),
            ),
            GButton(
              icon: LineIcons.user,
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
