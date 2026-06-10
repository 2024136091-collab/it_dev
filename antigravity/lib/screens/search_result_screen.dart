import 'package:flutter/material.dart';
import '../models/elevator.dart';
import '../services/favorites_service.dart';
import 'detail_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  final List<Elevator> results;

  const SearchResultScreen({
    super.key,
    required this.query,
    required this.results,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  String _selectedRegion = '전체';

  static const _regions = [
    '전체', '서울', '경기·인천', '강원', '충청권', '경북권', '호남권', '영남권', '제주'
  ];

  List<Elevator> get _filtered {
    if (_selectedRegion == '전체') return widget.results;
    return widget.results
        .where((e) => e.region == _selectedRegion)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        foregroundColor: Colors.white,
        title: Text('"${widget.query}" 검색 결과'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFe94560)),
        ),
      ),
      body: Column(
        children: [
          _RegionFilter(
            selected: _selectedRegion,
            onSelect: (r) => setState(() => _selectedRegion = r),
            regions: _regions,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '총 ${filtered.length}건',
                style: const TextStyle(
                    color: Color(0xFF9198a1), fontSize: 13),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(color: Color(0xFF9198a1)),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) =>
                        _ElevatorCard(elevator: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RegionFilter extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;
  final List<String> regions;

  const _RegionFilter({
    required this.selected,
    required this.onSelect,
    required this.regions,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: regions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final r = regions[i];
          final isSelected = r == selected;
          return GestureDetector(
            onTap: () => onSelect(r),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFe94560)
                    : const Color(0xFF0f3460).withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFe94560)
                      : const Color(0xFF0f3460),
                ),
              ),
              child: Text(
                r,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF9198a1),
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ElevatorCard extends StatelessWidget {
  final Elevator elevator;
  const _ElevatorCard({required this.elevator});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(elevator: elevator),
        ),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Tag(elevator.type),
                      const SizedBox(width: 6),
                      _Tag(elevator.region),
                      const SizedBox(width: 6),
                      _Tag(
                        elevator.isOperating ? '운행중' : '정지',
                        color: elevator.isOperating
                            ? const Color(0xFF3fb950)
                            : const Color(0xFFf85149),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListenableBuilder(
              listenable: FavoritesService.instance,
              builder: (context, _) {
                final isFav =
                    FavoritesService.instance.isFavorite(elevator.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: const Color(0xFFe94560),
                    size: 20,
                  ),
                  onPressed: () =>
                      FavoritesService.instance.toggle(elevator.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;

  const _Tag(this.text, {this.color = const Color(0xFF9198a1)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}
