// data/dummy_data.dart

import 'package:untitled6/Data/model_home_page.dart';
import 'package:untitled6/Data/story%20_model.dart';

// ===== Dummy Stories =====
final List<StoryModel> dummyStories = [
  StoryModel(
    username: "ahmed",
    images: ["assets/car.png", ],
  ),
  StoryModel(
    username: "sara",
    images: ["assets/post.png"],
  ),
  StoryModel(
    username: "lili",
    images: [ "assets/dog2.png"],
  ),
];

// ===== Dummy Posts =====
final List<Post> dummyPosts = [
  Post(
    username: "ahmed",
    profileImage: "assets/man.png",
    postImage: "assets/man.png",
    caption: 'good day',
  ),
  Post(
    username: "sara",
    profileImage: "assets/girl.png",
    postImage: "assets/post.png",
    caption: "moring",
  ),
  Post(
    username: "lili",
    profileImage: "assets/dog.png",
    postImage: "assets/dog2.png",
    caption: "hay",
  ),
];
