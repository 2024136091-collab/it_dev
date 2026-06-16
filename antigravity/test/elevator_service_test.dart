import 'package:flutter_test/flutter_test.dart';
import 'package:antigravity/domain/models/elevator.dart';
import 'package:antigravity/domain/services/elevator_service.dart';

const _sample = [
  Elevator(
    id: '2011-001',
    buildingName: '신구대학교 본관',
    buildingCategory: '학교',
    address: '경기도 성남시',
    type: '승객용',
    installYear: 2005,
    manufacturer: '현대엘리베이터',
    capacity: 13,
    lastInspectedAt: '2026-03-01',
    isOperating: true,
  ),
  Elevator(
    id: '2345-002',
    buildingName: '신구대학교 도서관',
    buildingCategory: '학교',
    address: '경기도 성남시',
    type: '장애인용',
    installYear: 2018,
    manufacturer: '오티스',
    capacity: 9,
    lastInspectedAt: '2026-02-10',
    isOperating: false,
  ),
  Elevator(
    id: '1899-003',
    buildingName: '강남 파이낸스센터',
    buildingCategory: '오피스',
    address: '서울시 강남구',
    type: '화물용',
    installYear: 2012,
    manufacturer: '티센크루프',
    capacity: 20,
    lastInspectedAt: '2026-01-20',
    isOperating: true,
  ),
];

void main() {
  final service = ElevatorService();

  group('search', () {
    test('건물명으로 검색하면 일치하는 항목을 반환한다', () {
      final result = service.search(_sample, '신구대학교');
      expect(result.length, 2);
    });

    test('승강기 번호로 검색하면 해당 항목을 반환한다', () {
      final result = service.search(_sample, '1899-003');
      expect(result.length, 1);
      expect(result.first.buildingName, '강남 파이낸스센터');
    });

    test('빈 문자열 검색은 빈 리스트를 반환한다', () {
      expect(service.search(_sample, ''), isEmpty);
    });
  });

  group('filterByRegion', () {
    test('"전체"는 모든 항목을 반환한다', () {
      expect(service.filterByRegion(_sample, '전체').length, 3);
    });

    test('서울 필터는 서울 지역 승강기만 반환한다', () {
      final result = service.filterByRegion(_sample, '서울');
      expect(result.length, 1);
      expect(result.first.id, '1899-003');
    });
  });

  group('filterByCategory', () {
    test('"업체" 필터는 아파트를 제외한 모든 항목을 반환한다', () {
      final result = service.filterByCategory(_sample, '업체');
      expect(result.length, 3);
    });

    test('"학교" 필터는 학교 카테고리만 반환한다', () {
      final result = service.filterByCategory(_sample, '학교');
      expect(result.length, 2);
    });
  });

  group('aiSearch', () {
    test('"오래된"이 포함되면 설치연도 오름차순으로 정렬한다', () {
      final result = service.aiSearch(_sample, '오래된 승강기 찾아줘');
      expect(result.results.first.installYear, 2005);
      expect(result.description, contains('오래된'));
    });

    test('"장애인"이 포함되면 장애인용 승강기만 반환한다', () {
      final result = service.aiSearch(_sample, '장애인 승강기 어디있어');
      expect(result.results.length, 1);
      expect(result.results.first.type, '장애인용');
    });

    test('"점검"이 포함되면 운행 정지 중인 승강기만 반환한다', () {
      final result = service.aiSearch(_sample, '점검중인 승강기');
      expect(result.results.every((e) => !e.isOperating), true);
    });

    test('키워드가 매칭되지 않으면 일반 검색으로 fallback된다', () {
      final result = service.aiSearch(_sample, '강남 파이낸스센터');
      expect(result.results.length, 1);
      expect(result.description, contains('검색 결과'));
    });
  });

  group('groupByBuilding', () {
    test('건물명 기준으로 그룹이 나뉘고, 같은 건물의 승강기는 한 그룹에 모인다', () {
      final grouped = service.groupByBuilding(_sample);
      expect(grouped.keys.length, 3);
      expect(grouped['신구대학교 본관']!.length, 1);
      expect(grouped['신구대학교 도서관']!.length, 1);
      expect(grouped['강남 파이낸스센터']!.length, 1);
    });

    test('같은 건물명의 승강기가 여러 개면 같은 그룹으로 묶인다', () {
      final extra = [
        ..._sample,
        const Elevator(
          id: '2011-004',
          buildingName: '신구대학교 본관',
          buildingCategory: '학교',
          address: '경기도 성남시',
          type: '승객용',
          installYear: 2015,
          manufacturer: '현대엘리베이터',
          capacity: 13,
          lastInspectedAt: '2026-03-01',
          isOperating: true,
        ),
      ];
      final grouped = service.groupByBuilding(extra);
      expect(grouped['신구대학교 본관']!.length, 2);
    });
  });
}
