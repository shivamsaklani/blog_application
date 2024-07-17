import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account Options',
                  style: GoogleFonts.robotoMono(),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF57636C),
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    !snapshot.data!.exists) {
                  // Handle scenario where document is empty or doesn't exist
                  return Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.displayName ?? 'User Name',
                        style: GoogleFonts.robotoMono(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? 'email@example.com',
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  );
                }

                var userData = snapshot.data!;

                // Handle null or missing fields gracefully
                String? photoUrl = userData.get('photoUrl') as String?;
                String? displayName = userData.get('name') as String?;

                return Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0x4C4B39EF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4B39EF),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: photoUrl != null
                              ? Image.network(
                                  photoUrl,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                )
                              : user.photoURL != null
                                  ? Image.network(
                                      user.photoURL!,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName ?? user.displayName ?? 'User Name',
                            style: GoogleFonts.robotoMono(),
                            overflow: TextOverflow.ellipsis,
                            // This ensures the text doesn't overflow
                          ),
                          Text(
                            user.email ?? 'email@example.com',
                            style: GoogleFonts.robotoMono(),
                            overflow: TextOverflow.ellipsis,
                            // This ensures the text doesn't overflow
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const Divider(
              thickness: 1,
              color: Color(0xFFE0E3E7),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      color: Color(0xFF14181B),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'My Profile',
                      style: GoogleFonts.robotoMono(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF14181B),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: GoogleFonts.robotoMono(),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Color(0xFFE0E3E7),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.login_rounded,
                      color: Color(0xFF14181B),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Log out',
                      style: GoogleFonts.robotoMono(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}