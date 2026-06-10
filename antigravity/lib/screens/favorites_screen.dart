import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../models/elevator.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        foregroundColor: Colors.white,
        title: const Text('즐겨찾기'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFe94560)),
        ),
      ),
      body: ListenableBuilder(
        listenable: FavoritesService.instance,
        builder: (context, _) {
          final favorites = FavoritesService.instance.favorites;
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_border, color: Color(0xFF9198a1), size: 48),
                  SizedBox(height: 12),
                  Text(
                    '즐겨찾기한 승강기가 없습니다.',
                    style: TextStyle(color: Color(0xFF9198a1)),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) =>
                _FavoriteCard(elevator: favorites[i]),
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Elevator elevator;
  const _FavoriteCard({required this.elevator});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(elevator: elevator)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0f3460).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0f3460)),
        ),
        child: Row(
          children: [
            const Icon(Icons.elevator, color: Color(0xFFe94560), size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    elevator.buildingName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    elevator.address,
                    style: const TextStyle(
                        color: Color(0xFF9198a1), fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${elevator.id}  ·  ${elevator.region}',
                    style: const TextStyle(
                        color: Color(0xFF9198a1), fontSize: 11),
                  ),
                ],
              ),
            ),
            ListenableBuilder(
              listenable: FavoritesService.instance,
              builder: (context, _) => IconButton(
                icon: const Icon(Icons.star, color: Color(0xFFe94560)),
                onPressed: () =>
                    FavoritesService.instance.toggle(elevator.id),
                tooltip: '즐겨찾기 해제',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
