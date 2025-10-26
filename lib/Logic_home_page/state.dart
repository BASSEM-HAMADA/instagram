// Logic_home_page/state.dart

import 'package:equatable/equatable.dart';
import 'package:untitled6/Data/story%20_model.dart';

abstract class StoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoaded extends StoryState {
  final List<StoryModel> stories;

  StoryLoaded(this.stories);

  @override
  List<Object?> get props => [stories];
}
