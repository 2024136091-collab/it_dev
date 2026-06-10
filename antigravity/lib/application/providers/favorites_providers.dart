import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/elevator.dart';
import '../../data/repositories/local_repository.dart';

final localRepositoryProvider = Provider<LocalRepository>(
  (ref) => LocalRepository(),
);

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final LocalRepository _repo;

  FavoritesNotifier(this._repo) : super({});

  void toggle(String id) {
    _repo.toggle(id);
    state = Set.from(_repo.favoriteIds);
  }

  bool isFavorite(String id) => state.contains(id);

  List<Elevator> get favorites => _repo.getFavorites();
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(ref.read(localRepositoryProvider)),
);
