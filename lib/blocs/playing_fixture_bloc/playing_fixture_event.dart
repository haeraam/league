part of 'playing_fixture_bloc.dart';

sealed class PlayingFixtureEvent {}

class SetPayingFixtureEvent extends PlayingFixtureEvent {
  final Fixture fixture;

  SetPayingFixtureEvent({required this.fixture});
}
