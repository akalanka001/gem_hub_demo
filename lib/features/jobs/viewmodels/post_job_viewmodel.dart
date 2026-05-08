import 'package:job_market/data/models/job_market/job_model.dart';
import 'package:job_market/data/repositories/job_market/job_repository.dart';
import 'package:job_market/features/marketplace/viewmodels/marketplace_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_job_viewmodel.g.dart';

@riverpod
class PostJobViewModel extends _$PostJobViewModel {
  @override
  bool build() {
    return false;
  }

  Future<bool> publishJob(Job job) async {
    try {
      final repository = ref.read(jobRepositoryProvider);
      await repository.insertJob(job);

      // Refresh the marketplace jobs list after adding a new job
      ref.invalidate(marketplaceViewModelProvider);
      return true;
    } catch (_) {
      return false;
    }
  }
}
