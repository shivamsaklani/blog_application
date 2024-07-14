import 'package:blog_application/Screens/PostDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogPost extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String postId; // Add postId

  const BlogPost({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.postId, // Add postId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailsScreen(postId: postId),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x411D2429),
                offset: Offset(
                  0.0,
                  1,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
                  child: Text(
                    title,
                    style: GoogleFonts.leagueSpartan(
                      color: Color(0xFF101213),
                      fontSize: 22,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 4, 8, 0),
                  child: Text(
                    description,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.leagueSpartan(
                      color: Color.fromARGB(255, 84, 87, 88),
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
