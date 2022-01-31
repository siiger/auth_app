part of 'onboard_cubit.dart';

class OnboardState extends Equatable {
  const OnboardState({
    this.status = FormzStatus.pure,
  });

 
  final FormzStatus status;
 

  @override
  List<Object> get props => [status];

  OnboardState copyWith({
    FormzStatus? status,
  }) {
    return OnboardState(
      status: status ?? this.status,
    );
  }
}

