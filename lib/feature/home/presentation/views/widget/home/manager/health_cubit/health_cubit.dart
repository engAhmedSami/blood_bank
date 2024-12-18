import 'package:blood_bank/core/services/health_request.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/manager/health_cubit/health_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthCubit extends Cubit<HealthState> {
  final HealthRequest healthRequest;

  HealthCubit(this.healthRequest) : super(HealthInitial());

  void fetchHealthNews() async {
    emit(HealthLoading());

    try {
      final articles = await healthRequest.news(category: 'health');
      emit(HealthSuccess(articles));
    } catch (e) {
      emit(HealthError('Failed to fetch data.'));
    }
  }
}
