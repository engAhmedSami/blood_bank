import 'package:blood_bank/feature/home/presentation/views/widget/home/manager/models/health_model.dart';

abstract class HealthState {}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthSuccess extends HealthState {
  final List<HealthModel> articles;

  HealthSuccess(this.articles);
}

class HealthError extends HealthState {
  final String message;

  HealthError(this.message);
}
