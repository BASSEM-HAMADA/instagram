class StoryModel {
  final String username;
  final List<String> images;
  final bool isUser;

  StoryModel({
    required this.username,
    required this.images,
    this.isUser = false,
  });
}
