import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/elevator.dart';
import '../../domain/services/elevator_service.dart';
import '../../data/repositories/api_repository.dart';

final elevatorRepositoryProvider = Provider<ElevatorRepository>(
  (ref) => ApiRepository(),
);

final elevatorServiceProvider = Provider<ElevatorService>(
  (ref) => ElevatorService(),
);

class SearchNotifier extends StateNotifier<AsyncValue<List<Elevator>>> {
  final ElevatorRepository _repo;
  final ElevatorService _service;

  SearchNotifier(this._repo, this._service)
      : super(const AsyncValue.data([]));

  String _lastQuery = '';

  Future<void> search(String query) async {
    _lastQuery = query;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.search(query));
  }

  List<Elevator> filterByRegion(String region) {
    return state.maybeWhen(
      data: (list) => _service.filterByRegion(list, region),
      orElse: () => [],
    );
  }

  List<Elevator> filterByAll(String region, String type, String category) {
    return state.maybeWhen(
      data: (list) {
        var result = _service.filterByRegion(list, region);
        result = _service.filterByType(result, type);
        result = _service.filterByCategory(result, category);
        return result;
      },
      orElse: () => [],
    );
  }

  List<String> get availableTypes {
    return state.maybeWhen(
      data: (list) => _service.extractTypes(list),
      orElse: () => ['전체'],
    );
  }

  List<String> get availableCategories {
    return state.maybeWhen(
      data: (list) => _service.extractCategories(list),
      orElse: () => ['전체'],
    );
  }

  Map<String, List<Elevator>> groupByBuilding(List<Elevator> elevators) {
    return _service.groupByBuilding(elevators);
  }

  Future<({List<Elevator> results, String description})> aiSearch(
      String query) async {
    _lastQuery = query;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    final all = await _repo.getAll();
    final result = _service.aiSearch(all, query);
    state = AsyncValue.data(result.results);
    return result;
  }

  String get lastQuery => _lastQuery;
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<Elevator>>>(
  (ref) => SearchNotifier(
    ref.read(elevatorRepositoryProvider),
    ref.read(elevatorServiceProvider),
  ),
);
