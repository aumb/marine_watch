part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {}

class OnboardingError extends OnboardingState {
  OnboardingError({
    required this.message,
    this.code,
  });

  final String message;
  final int? code;

  @override
  List<Object?> get props => [message, code];
}
