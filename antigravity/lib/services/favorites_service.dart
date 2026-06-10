import 'package:flutter/foundation.dart';
import '../models/elevator.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService instance = FavoritesService._();
  FavoritesService._();

  final Set<String> _ids = {};

  bool isFavorite(String id) => _ids.contains(id);

  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    notifyListeners();
  }

  List<Elevator> get favorites =>
      dummyElevators.where((e) => _ids.contains(e.id)).toList();
}
