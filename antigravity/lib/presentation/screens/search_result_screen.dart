import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/elevator_providers.dart';
import '../../application/providers/favorites_providers.dart';
import '../../domain/models/elevator.dart';
import 'detail_screen.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  ConsumerState<SearchResultScreen> createState() =>
      _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  String _selectedRegion = '전체';
  String _selectedType = '전체';
  String _selectedCategory = '전체';

  static const _regions = [
    '전체', '서울', '경기·인천', '강원', '충청권', '경북권', '호남권', '영남권', '제주'
  ];

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);
    final types = notifier.availableTypes;
    final categories = notifier.availableCategories;
    final filtered = notifier.filterByAll(
        _selectedRegion, _selectedType, _selectedCategory);

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
            regions: _regions,
            onSelect: (r) => setState(() => _selectedRegion = r),
          ),
          _RegionFilter(
            selected: _selectedCategory,
            regions: categories,
            onSelect: (c) => setState(() => _selectedCategory = c),
          ),
          _RegionFilter(
            selected: _selectedType,
            regions: types,
            onSelect: (t) => setState(() => _selectedType = t),
          ),
          Expanded(
            child: searchState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFe94560)),
              ),
              error: (e, _) => Center(
                child: Text('오류 발생: $e',
                    style: const TextStyle(color: Colors.red)),
              ),
              data: (_) {
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('검색 결과가 없습니다.',
                        style: TextStyle(color: Color(0xFF9198a1))),
                  );
                }
                final grouped = ref
                    .read(searchProvider.notifier)
                    .groupByBuilding(filtered);
                final buildings = grouped.keys.toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '건물 ${buildings.length}곳 · 승강기 ${filtered.length}대',
                          style: const TextStyle(
                              color: Color(0xFF9198a1), fontSize: 13),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: buildings.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, i) => _BuildingGroup(
                          buildingName: buildings[i],
                          elevators: grouped[buildings[i]]!,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionFilter extends StatelessWidget {
  final String selected;
  final List<String> regions;
  final void Function(String) onSelect;

  const _RegionFilter({
    required this.selected,
    required this.regions,
    required this.onSelect,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                  color:
                      isSelected ? Colors.white : const Color(0xFF9198a1),
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ElevatorCard extends ConsumerWidget {
  final Elevator elevator;
  const _ElevatorCard({required this.elevator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(elevator.id);
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
                  Text(elevator.buildingName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(elevator.address,
                      style: const TextStyle(
                          color: Color(0xFF9198a1), fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
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
                  ]),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFav ? Icons.star : Icons.star_border,
                color: const Color(0xFFe94560),
                size: 20,
              ),
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(elevator.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildingGroup extends StatelessWidget {
  final String buildingName;
  final List<Elevator> elevators;
  const _BuildingGroup({required this.buildingName, required this.elevators});

  @override
  Widget build(BuildContext context) {
    final category = elevators.first.buildingCategory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.business, color: Color(0xFFe94560), size: 16),
            const SizedBox(width: 6),
            Text(
              buildingName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            _Tag(category, color: const Color(0xFF4493f8)),
            const SizedBox(width: 6),
            _Tag('${elevators.length}대'),
          ],
        ),
        const SizedBox(height: 8),
        ...elevators.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ElevatorCard(elevator: e),
            )),
      ],
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
