import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final String errorMessage;
  final String? selectedCity;

  const SettingsState({
    required this.isLoading,
    required this.errorMessage,
    this.selectedCity,
  });

  /// Başlangıç durumu: Yükleme yok, hata mesajı boş ve seçili şehir yok.
  factory SettingsState.initial() => const SettingsState(
        isLoading: false,
        errorMessage: '',
        selectedCity: null,
      );

  SettingsState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? selectedCity,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, selectedCity];
}
