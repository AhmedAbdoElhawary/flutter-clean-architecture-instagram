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

class CubitStoryFailed extends StoryState {
  final String error;
  const CubitStoryFailed(this.error);
  @override
  List<Object> get props => [error];
}
