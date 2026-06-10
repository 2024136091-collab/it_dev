import 'package:flutter/material.dart';
import '../models/elevator.dart';
import '../services/favorites_service.dart';

class DetailScreen extends StatelessWidget {
  final Elevator elevator;

  const DetailScreen({super.key, required this.elevator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        foregroundColor: Colors.white,
        title: Text(elevator.buildingName),
        actions: [
          ListenableBuilder(
            listenable: FavoritesService.instance,
            builder: (context, _) {
              final isFav = FavoritesService.instance.isFavorite(elevator.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: const Color(0xFFe94560),
                ),
                tooltip: isFav ? '즐겨찾기 해제' : '즐겨찾기 추가',
                onPressed: () =>
                    FavoritesService.instance.toggle(elevator.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusBadge(isOperating: elevator.isOperating),
            const SizedBox(height: 20),
            _InfoCard(
              title: '기본 정보',
              rows: [
                ('승강기 번호', elevator.id),
                ('지역', elevator.region),
                ('건물명', elevator.buildingName),
                ('주소', elevator.address),
                ('종류', elevator.type),
              ],
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: '제원',
              rows: [
                ('제조사', elevator.manufacturer),
                ('설치 연도', '${elevator.installYear}년'),
                if (elevator.capacity > 0)
                  ('최대 정원', '${elevator.capacity}명'),
              ],
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: '점검 이력',
              rows: [
                ('최종 검사일', elevator.lastInspectedAt),
                ('검사 결과', '합격'),
                ('담당 검사원', '홍길동'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOperating;
  const _StatusBadge({required this.isOperating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isOperating
            ? const Color(0xFF1a7f37).withOpacity(0.2)
            : const Color(0xFFcf222e).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOperating
              ? const Color(0xFF3fb950)
              : const Color(0xFFf85149),
        ),
      ),
      child: Text(
        isOperating ? '● 정상 운행' : '● 운행 정지',
        style: TextStyle(
          color: isOperating
              ? const Color(0xFF3fb950)
              : const Color(0xFFf85149),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0f3460).withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0f3460)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFe94560),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          ...rows.map((row) => _Row(label: row.$1, value: row.$2)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9198a1),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
