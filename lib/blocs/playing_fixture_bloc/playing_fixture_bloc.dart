import 'package:bloc/bloc.dart';
import 'package:leage_simulator/entities/fixture/fixture.dart';

part 'playing_fixture_event.dart';
part 'playing_fixture_state.dart';

class PlayingFixtureBloc extends Bloc<PlayingFixtureEvent, PlayingFixtureState> {
  PlayingFixtureBloc() : super(PlayingFixtureInitial()) {
    on<SetPayingFixtureEvent>((event, emit) {
      emit(PlayingFixtureReady(fixture: event.fixture));
    });
  }
}
