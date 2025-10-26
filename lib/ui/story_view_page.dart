import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class StoryViewPage extends StatefulWidget {
  final List<dynamic> storyImages;

  const StoryViewPage({super.key, required this.storyImages});

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _startStory();
  }

  void _startStory() {
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.storyImages.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _controller
        ..reset()
        ..forward();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //  تحديد نوع الصورة (File أو Asset)
  ImageProvider _getImageProvider(dynamic image) {
    if (image is File) {
      return FileImage(image);
    } else if (image is String) {
      return AssetImage(image);
    } else {
      throw Exception("نوع الصورة غير مدعوم");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 👇 الصورة الحالية
          Center(
            child: Image(
              image: _getImageProvider(widget.storyImages[_currentIndex]),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // 👇 التحكم باللمس (يمين / شمال)
          Row(
            children: [
              Expanded(child: GestureDetector(onTap: _previousStory)),
              Expanded(child: GestureDetector(onTap: _nextStory)),
            ],
          ),

          // 👇 شريط التقدم (progress bar)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: widget.storyImages.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          double value;
                          if (index < _currentIndex) {
                            value = 1;
                          } else if (index == _currentIndex) {
                            value = _controller.value;
                          } else {
                            value = 0;
                          }

                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.white24,
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
