part of 'story_cubit.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object> get props => [];
}

class StoryInitial extends StoryState {}

class CubitStoryLoading extends StoryState {}

class CubitStoryLoaded extends StoryState {
  final String postId;

  const CubitStoryLoaded(this.postId);
  @override
  List<Object> get props => [postId];
}

class CubitStoriesInfoLoaded extends StoryState {
  final List<UserPersonalInfo> storiesOwnersInfo;

  const CubitStoriesInfoLoaded(this.storiesOwnersInfo);
  @override
  List<Object> get props => [storiesOwnersInfo];
}

class SpecificStoriesInfoLoaded extends StoryState {
  final UserPersonalInfo userInfo;

  const SpecificStoriesInfoLoaded(this.userInfo);
  @override
  List<Object> get props => [userInfo];
}

class CubitDeletingStoryLoaded extends StoryState {}

class CubitDeletingStoryLoading extends StoryState {}

class CubitStoryFailed extends StoryState {
  final String error;
  const CubitStoryFailed(this.error);
  @override
  List<Object> get props => [error];
}
