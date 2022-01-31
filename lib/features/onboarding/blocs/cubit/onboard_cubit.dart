import 'package:auth_app/data/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'onboard_state.dart';


class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(OnboardState());

  final UserRepository _userRepository;


  Future<void> seenNews() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _userRepository.updateIntroSeenCurrentUser(introSeen: true);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } on NoSuchMethodError {
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }

}