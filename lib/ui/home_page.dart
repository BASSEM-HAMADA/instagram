import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'story_view_page.dart';
import '../Data/dummy_data_stoy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _myStory;
  List<File> _myStoryImages = [];
  int _selectedIndex = 0;

  Future<void> _pickMyStory() async {
    final pickedList = await ImagePicker().pickMultiImage();
    if (pickedList.isNotEmpty) {
      final selectedFiles = pickedList.map((e) => File(e.path)).toList();
      setState(() {
        _myStoryImages = selectedFiles;
        _myStory = selectedFiles.first;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryViewPage(storyImages: selectedFiles),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color iconColor = isDark ? Colors.white : Colors.black;
    final Color dividerColor = isDark ? Colors.white24 : Colors.grey[300]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 🟢 شلت السهم اللي بيرجع
        backgroundColor: bgColor,
        elevation: 1,
        title: Text(
          'Instagram',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(
              color: textColor.withOpacity(0.85), // درجة أفتح شوية
              fontSize: 25,
              fontWeight: FontWeight.w400,
              letterSpacing: -1.2,
            ),
          ),
        ),
        actions: [
          Icon(Icons.add_box_outlined, color: iconColor),
          const SizedBox(width: 15),
          Icon(Icons.favorite_border, color: iconColor),
          const SizedBox(width: 15),
          Icon(Icons.chat_bubble_outline, color: iconColor),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== Stories Section =====
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dummyStories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_myStoryImages.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryViewPage(
                                      storyImages: _myStoryImages,
                                    ),
                                  ),
                                );
                              } else {
                                _pickMyStory();
                              }
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: _myStory != null
                                      ? FileImage(_myStory!)
                                      : const AssetImage("assets/profile.png")
                                  as ImageProvider,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: const Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Your Story",
                            style: TextStyle(fontSize: 12, color: textColor),
                          ),
                        ],
                      ),
                    );
                  }

                  final story = dummyStories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryViewPage(
                                  storyImages: story.images,
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(story.images.first),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          story.username,
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Divider(color: dividerColor),

            // ===== Posts Section =====
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyPosts.length,
              itemBuilder: (context, index) {
                final post = dummyPosts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(post.profileImage),
                      ),
                      title: Text(
                        post.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      trailing: Icon(Icons.more_vert, color: iconColor),
                    ),
                    Image.asset(
                      post.postImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border, color: iconColor),
                          const SizedBox(width: 20),
                          Icon(Icons.chat_bubble_outline, color: iconColor),
                          const SizedBox(width: 10),
                          Icon(Icons.send, color: iconColor),
                          const Spacer(),
                          Icon(Icons.bookmark_border, color: iconColor),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "${post.username}: ${post.caption}",
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ],
        ),
      ),

      // ===== Bottom Navigation Bar =====
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: isDark ? Colors.white : Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: bgColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
