import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../components/CustomDrawer.dart';
import 'BlogPost.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

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
              PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search posts...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim().toLowerCase();
                      });
                    },
                  ),
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: searchQuery.isEmpty
                    ? fetchBlogPosts()
                    : searchBlogPosts(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching posts.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No posts found.'));
                  } else {
                    List<Map<String, dynamic>> blogPosts = snapshot.data!;
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 52),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                            child: Text(
                              'Blogs',
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xFF57636C),
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...blogPosts.map((post) {
                            return BlogPost(
                              imageUrl: post['imageUrl'] ?? '',
                              title: post['title'] ?? '',
                              description: post['content'] ?? '',
                              postId: post['postId'] ?? '',
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }
                },
              ),
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

  Future<List<Map<String, dynamic>>> fetchBlogPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('blog_posts').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> searchBlogPosts(String query) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('blog_posts')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
