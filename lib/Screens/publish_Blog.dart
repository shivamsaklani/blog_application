import 'dart:io';
import 'package:blog_application/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PublishBlog extends StatefulWidget {
  const PublishBlog({super.key});

  @override
  State<PublishBlog> createState() => _PublishBlogState();
}

class _PublishBlogState extends State<PublishBlog> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final imagePicker = ImagePicker();
  XFile? pickedImage;

  Future<void> pickImage() async {
    final result = await imagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        pickedImage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Post'),
        foregroundColor: const Color.fromARGB(188, 12, 188, 156),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              pickedImage != null
                  ? Image.file(
                      File(pickedImage!.path)) // Display selected image
                  : InkWell(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                cursorHeight: 10,
                style: const TextStyle(
                  height: 10,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Buttons(
                  text: "Publish",
                  color: const Color.fromARGB(188, 12, 188, 156),
                  textColor: Colors.white,
                  onPressed: () => {
                        // Handle form submission (including image upload)
                        // ... (your logic for saving blog post and image)
                        titleController.clear(),
                        contentController.clear(),
                        pickedImage = null,
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Blog post submitted successfully!'),
                          ),
                        )
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
