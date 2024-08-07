import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../components/buttons.dart';

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
  bool isLoading = false;

  Future<void> pickImage() async {
    final result = await imagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        pickedImage = result;
      });
    }
  }

  Future<void> submitBlogPost() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        pickedImage == null) {
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        animateFrom: AnimateFrom.fromTop,
        leading: Text(
          'Please fill in all fields and select an image.',
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final String imageUrl = await uploadImage(File(pickedImage!.path));
      await saveBlogPost(
          titleController.text, contentController.text, imageUrl);
      Navigator.maybePop(context);
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        animateFrom: AnimateFrom.fromTop,
        leading: Text(
          'Blog post submitted successfully!',
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );

      titleController.clear();
      contentController.clear();
      setState(() {
        pickedImage = null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        animateFrom: AnimateFrom.fromTop,
        leading: Text(
          'Failed to submit blog post: $e',
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Future<String> uploadImage(File imageFile) async {
    final String fileId = const Uuid().v4();
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('blog_images/$fileId');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> saveBlogPost(
      String title, String content, String imageUrl) async {
    String postId =
        FirebaseFirestore.instance.collection('blog_posts').doc().id;

    await FirebaseFirestore.instance.collection('blog_posts').doc(postId).set({
      'title': title,
      'content': content.trim(),
      'postId': postId,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                cursorHeight: 20,
                controller: contentController,
                style: const TextStyle(
                  height: 10,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : Buttons(
                      text: "Publish",
                      color: const Color.fromARGB(188, 12, 188, 156),
                      textColor: Colors.white,
                      onPressed: submitBlogPost,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
