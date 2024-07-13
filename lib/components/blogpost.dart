import 'package:flutter/material.dart';

class blogPost extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const blogPost({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(188, 12, 188, 156),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover, // Adjust fit as needed
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white, // Adjust text color
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white70, // Adjust text color
            ),
          ),
        ],
      ),
    );
  }
}
