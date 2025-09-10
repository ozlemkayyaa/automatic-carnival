import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final String errorMessage;
  final bool isInitialized;

  const SplashState({
    required this.isLoading,
    required this.errorMessage,
    required this.isInitialized,
  });

  factory SplashState.initial() {
    return const SplashState(
      isLoading: false,
      errorMessage: '',
      isInitialized: false,
    );
  }

  SplashState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isInitialized,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object> get props => [isLoading, errorMessage, isInitialized];
}
