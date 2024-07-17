import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../components/CustomDrawer.dart';
import '../components/BlogPost.dart';

class PostdataScreen extends StatefulWidget {
  const PostdataScreen({super.key});

  @override
  State<PostdataScreen> createState() => _PostdataScreenState();
}

class _PostdataScreenState extends State<PostdataScreen> {
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
                            imageUrl: post['imageUrl'] ??
                                'https://example.com/default_profile_photo.png',
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
    );
  }
}
