import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../components/CustomDrawer.dart';
import '../components/BlogPost.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchQuery = "";
  List<Map<String, dynamic>> blogPosts = [];
  bool isLoading = false;
  bool hasMore = true;
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    fetchBlogPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchBlogPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchBlogPosts() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('blog_posts')
        .orderBy('timestamp')
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      setState(() {
        blogPosts.addAll(querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
        hasMore = querySnapshot.docs.length == 10;
      });
    } else {
      setState(() {
        hasMore = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> searchBlogPosts(String query) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('blog_posts')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    QuerySnapshot contentSnapshot = await FirebaseFirestore.instance
        .collection('blog_posts')
        .where('content', arrayContains: query)
        .get();

    // Combine results from title and content searches
    List<QueryDocumentSnapshot> combinedDocs =
        querySnapshot.docs + contentSnapshot.docs;

    // Remove duplicates
    final seen = <String>{};
    List<Map<String, dynamic>> blogPosts = combinedDocs
        .where((doc) {
          final id = doc.id;
          if (seen.contains(id)) {
            return false;
          } else {
            seen.add(id);
            return true;
          }
        })
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return blogPosts;
  }

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
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search posts...',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(188, 12, 188, 156),
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim().toLowerCase();
                        blogPosts.clear();
                        lastDocument = null;
                        hasMore = true;
                        fetchBlogPosts();
                      });
                    },
                  ),
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: searchQuery.isEmpty
                    ? Future.value(blogPosts)
                    : searchBlogPosts(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      blogPosts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching posts.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No posts found.'));
                  } else {
                    List<Map<String, dynamic>> displayedPosts = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 5, 0, 0),
                          child: Text(
                            'Blogs',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF57636C),
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...displayedPosts.map((post) {
                          return BlogPost(
                            imageUrl: post['imageUrl'] ?? '',
                            title: post['title'] ?? '',
                            postId: post['postId'] ?? '',
                          );
                        }),
                        if (isLoading)
                          const Center(child: CircularProgressIndicator()),
                      ],
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
}
