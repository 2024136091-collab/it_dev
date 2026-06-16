import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../application/providers/favorites_providers.dart';
import '../../domain/models/elevator.dart';

class DetailScreen extends ConsumerWidget {
  final Elevator elevator;
  const DetailScreen({super.key, required this.elevator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(elevator.id);

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        foregroundColor: Colors.white,
        title: Text(elevator.buildingName),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.star : Icons.star_border,
              color: const Color(0xFFe94560),
            ),
            tooltip: isFav ? '즐겨찾기 해제' : '즐겨찾기 추가',
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(elevator.id),
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
            _InfoCard(title: '기본 정보', rows: [
              ('승강기 번호', elevator.id),
              ('지역', elevator.region),
              ('건물명', elevator.buildingName),
              ('건물 유형', elevator.buildingCategory),
              ('주소', elevator.address),
              ('종류', elevator.type),
            ]),
            const SizedBox(height: 16),
            _ExternalLinkCard(elevatorId: elevator.id),
            const SizedBox(height: 16),
            _InfoCard(title: '제원', rows: [
              ('제조사', elevator.manufacturer),
              ('설치 연도', '${elevator.installYear}년'),
              if (elevator.capacity > 0)
                ('최대 정원', '${elevator.capacity}명')
              else
                ('최대 정원', '해당 없음'),
            ]),
            const SizedBox(height: 16),
            _InfoCard(title: '점검 이력', rows: [
              ('최종 검사일', elevator.lastInspectedAt),
              ('검사 결과', '합격'),
              ('담당 검사원', '홍길동'),
            ]),
            if (elevator.lat != null && elevator.lng != null) ...[
              const SizedBox(height: 16),
              _MapSection(lat: elevator.lat!, lng: elevator.lng!,
                  label: elevator.buildingName),
            ],
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
            ? const Color(0xFF1a7f37).withValues(alpha: 0.2)
            : const Color(0xFFcf222e).withValues(alpha: 0.2),
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

class _ExternalLinkCard extends StatelessWidget {
  final String elevatorId;
  const _ExternalLinkCard({required this.elevatorId});

  // 실제 API 연동 전까지는 공식 사이트로 바로 이동하는 링크만 제공한다.
  Future<void> _open() => launchUrl(
        Uri.parse('https://www.elevator.go.kr'),
        mode: LaunchMode.externalApplication,
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _open,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0f3460).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0f3460)),
        ),
        child: Row(
          children: [
            const Icon(Icons.open_in_new, color: Color(0xFFe94560), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '국가승강기정보센터에서 "$elevatorId" 원본 정보 확인',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9198a1)),
          ],
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
        color: const Color(0xFF0f3460).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0f3460)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFe94560),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(children: [
                  SizedBox(
                    width: 100,
                    child: Text(row.$1,
                        style: const TextStyle(
                            color: Color(0xFF9198a1), fontSize: 13)),
                  ),
                  Expanded(
                    child: Text(row.$2,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14)),
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  final double lat;
  final double lng;
  final String label;
  const _MapSection({required this.lat, required this.lng, required this.label});

  @override
  Widget build(BuildContext context) {
    final point = LatLng(lat, lng);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFe94560),
            borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
          ),
          child: const Text(
            '위치 지도',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(11)),
          child: SizedBox(
            height: 220,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: point,
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.antigravity',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.location_pin,
                        color: Color(0xFFe94560),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          child: Text(
            '$label · ${lat.toStringAsFixed(4)}° N, ${lng.toStringAsFixed(4)}° E',
            style: const TextStyle(color: Color(0xFF9198a1), fontSize: 11),
          ),
        ),
      ],
    );
  }
}
