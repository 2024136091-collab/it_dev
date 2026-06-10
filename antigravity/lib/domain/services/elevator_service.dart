import '../models/elevator.dart';

class ElevatorService {
  List<Elevator> search(List<Elevator> elevators, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return elevators.where((e) =>
      e.buildingName.toLowerCase().contains(q) ||
      e.address.toLowerCase().contains(q) ||
      e.id.contains(q)
    ).toList();
  }

  List<Elevator> filterByRegion(List<Elevator> elevators, String region) {
    if (region == '전체') return elevators;
    return elevators.where((e) => e.region == region).toList();
  }

  List<Elevator> filterByType(List<Elevator> elevators, String type) {
    if (type == '전체') return elevators;
    return elevators.where((e) => e.type == type).toList();
  }

  List<String> extractTypes(List<Elevator> elevators) {
    final types = elevators.map((e) => e.type).toSet().toList();
    types.sort();
    return ['전체', ...types];
  }

  List<Elevator> filterByCategory(List<Elevator> elevators, String category) {
    if (category == '전체') return elevators;
    if (category == '업체') {
      return elevators.where((e) => e.buildingCategory != '아파트').toList();
    }
    return elevators.where((e) => e.buildingCategory == category).toList();
  }

  List<String> extractCategories(List<Elevator> elevators) {
    final cats = elevators.map((e) => e.buildingCategory).toSet().toList();
    cats.sort();
    return ['전체', '업체', ...cats];
  }

  // 자연어 키워드를 해석해 결과와 설명을 반환
  ({List<Elevator> results, String description}) aiSearch(
      List<Elevator> elevators, String query) {
    final q = query.trim().toLowerCase();

    if (q.contains('오래된') || q.contains('노후') || q.contains('오래')) {
      final sorted = [...elevators]
        ..sort((a, b) => a.installYear.compareTo(b.installYear));
      return (
        results: sorted.take(5).toList(),
        description: '설치연도가 오래된 순으로 표시합니다.',
      );
    }
    if (q.contains('점검') || q.contains('정지') || q.contains('고장')) {
      final stopped = elevators.where((e) => !e.isOperating).toList();
      return (
        results: stopped,
        description: '현재 운행이 정지된 승강기입니다.',
      );
    }
    if (q.contains('장애인') || q.contains('휠체어') || q.contains('배리어')) {
      final result = elevators
          .where((e) =>
              e.type.contains('장애인') || e.type.contains('배리어프리'))
          .toList();
      return (
        results: result,
        description: '장애인용 승강기만 표시합니다.',
      );
    }
    if (q.contains('화물') || q.contains('물건') || q.contains('짐')) {
      final result = elevators.where((e) => e.type == '화물용').toList();
      return (results: result, description: '화물용 승강기만 표시합니다.');
    }
    if (q.contains('전망') || q.contains('뷰') || q.contains('경치')) {
      final result = elevators
          .where((e) => e.type.contains('전망'))
          .toList();
      return (results: result, description: '전망용 승강기만 표시합니다.');
    }
    if (q.contains('아파트') || q.contains('주거')) {
      final result =
          elevators.where((e) => e.buildingCategory == '아파트').toList();
      return (results: result, description: '아파트 승강기만 표시합니다.');
    }
    if (q.contains('병원') || q.contains('의료')) {
      final result =
          elevators.where((e) => e.buildingCategory == '병원').toList();
      return (results: result, description: '병원 승강기만 표시합니다.');
    }
    if (q.contains('학교') || q.contains('대학')) {
      final result =
          elevators.where((e) => e.buildingCategory == '학교').toList();
      return (results: result, description: '학교 승강기만 표시합니다.');
    }
    // 키워드 미매칭 시 일반 검색으로 fallback
    return (
      results: search(elevators, query),
      description: '"$query" 검색 결과입니다.',
    );
  }

  Map<String, List<Elevator>> groupByBuilding(List<Elevator> elevators) {
    final Map<String, List<Elevator>> grouped = {};
    for (final e in elevators) {
      grouped.putIfAbsent(e.buildingName, () => []).add(e);
    }
    return grouped;
  }
}
