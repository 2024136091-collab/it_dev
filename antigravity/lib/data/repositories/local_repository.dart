import '../../domain/models/elevator.dart';
import 'api_repository.dart';

class LocalRepository {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void add(String id) => _favoriteIds.add(id);

  void remove(String id) => _favoriteIds.remove(id);

  void toggle(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
  }

  List<Elevator> getFavorites() =>
      allElevators.where((e) => _favoriteIds.contains(e.id)).toList();

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
}
