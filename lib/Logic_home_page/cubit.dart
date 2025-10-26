import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/Data/story%20_model.dart';
import 'package:untitled6/Logic_home_page/state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryInitial()) {
    loadStories();
  }

  void loadStories() {
    final stories = [
      StoryModel(username: "You", images: ["assets/profile.png"], isUser: true),
      StoryModel(username: "Ahmed", images: ["assets/man.png"]),
      StoryModel(username: "Sara", images: ["assets/girl.png"]),
      StoryModel(username: "Lili", images: ["assets/dog.png"]),
    ];
    emit(StoryLoaded(stories));
  }

  void addMyStories(List<String> newPaths) {
    if (state is StoryLoaded) {
      final stories = (state as StoryLoaded).stories;
      final updated = stories.map((s) {
        if (s.isUser) {
          return StoryModel(username: s.username, images: newPaths, isUser: true);
        }
        return s;
      }).toList();
      emit(StoryLoaded(updated));
    }
  }
}
