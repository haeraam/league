part of 'playing_fixture_bloc.dart';

sealed class PlayingFixtureState {
  final Fixture? fixture;

  const PlayingFixtureState({this.fixture});
}

final class PlayingFixtureInitial extends PlayingFixtureState {}

final class PlayingFixtureReady extends PlayingFixtureState {
  PlayingFixtureReady({required super.fixture});
}
