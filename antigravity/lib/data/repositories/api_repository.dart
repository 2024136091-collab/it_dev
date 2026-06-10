import '../../domain/models/elevator.dart';
import '../../domain/services/elevator_service.dart';

// 더미 데이터 (실제 서비스에서는 공공 API 호출로 대체)
const List<Elevator> _dummyElevators = [
  // 학교
  Elevator(
    id: '2091-142',
    buildingName: '신구대학교 본관',
    buildingCategory: '학교',
    address: '경기도 성남시 중원구 양현로 391',
    type: '승객용',
    installYear: 2015,
    manufacturer: '현대엘리베이터',
    capacity: 15,
    lastInspectedAt: '2025-11-20',
    isOperating: true,
    lat: 37.4387, lng: 127.1494,
  ),
  Elevator(
    id: '2091-143',
    buildingName: '신구대학교 본관',
    buildingCategory: '학교',
    address: '경기도 성남시 중원구 양현로 391',
    type: '장애인용',
    installYear: 2015,
    manufacturer: '현대엘리베이터',
    capacity: 9,
    lastInspectedAt: '2025-11-20',
    isOperating: true,
    lat: 37.4387, lng: 127.1494,
  ),
  Elevator(
    id: '3819-208',
    buildingName: '신구대학교 도서관',
    buildingCategory: '학교',
    address: '경기도 성남시 중원구 양현로 391',
    type: '에스컬레이터',
    installYear: 2018,
    manufacturer: '오티스엘리베이터',
    capacity: 0,
    lastInspectedAt: '2025-10-05',
    isOperating: true,
    lat: 37.4389, lng: 127.1498,
  ),
  // 오피스
  Elevator(
    id: '0153-924',
    buildingName: '강남 파이낸스센터',
    buildingCategory: '오피스',
    address: '서울특별시 강남구 테헤란로 152',
    type: '승객용',
    installYear: 2010,
    manufacturer: '티센크루프엘리베이터',
    capacity: 20,
    lastInspectedAt: '2025-09-18',
    isOperating: false,
    lat: 37.4984, lng: 127.0280,
  ),
  Elevator(
    id: '0153-925',
    buildingName: '강남 파이낸스센터',
    buildingCategory: '오피스',
    address: '서울특별시 강남구 테헤란로 152',
    type: '화물용',
    installYear: 2010,
    manufacturer: '티센크루프엘리베이터',
    capacity: 0,
    lastInspectedAt: '2025-09-18',
    isOperating: true,
    lat: 37.4984, lng: 127.0280,
  ),
  Elevator(
    id: '0153-926',
    buildingName: '강남 파이낸스센터',
    buildingCategory: '오피스',
    address: '서울특별시 강남구 테헤란로 152',
    type: '장애인용',
    installYear: 2010,
    manufacturer: '티센크루프엘리베이터',
    capacity: 9,
    lastInspectedAt: '2025-09-18',
    isOperating: true,
    lat: 37.4984, lng: 127.0280,
  ),
  // 상업시설
  Elevator(
    id: '1940-831',
    buildingName: '롯데월드타워',
    buildingCategory: '상업시설',
    address: '서울특별시 송파구 올림픽로 300',
    type: '고속승객용',
    installYear: 2016,
    manufacturer: '쉰들러엘리베이터',
    capacity: 26,
    lastInspectedAt: '2025-12-01',
    isOperating: true,
    lat: 37.5126, lng: 127.1026,
  ),
  Elevator(
    id: '1940-832',
    buildingName: '롯데월드타워',
    buildingCategory: '상업시설',
    address: '서울특별시 송파구 올림픽로 300',
    type: '전망용',
    installYear: 2016,
    manufacturer: '쉰들러엘리베이터',
    capacity: 20,
    lastInspectedAt: '2025-12-01',
    isOperating: true,
    lat: 37.5126, lng: 127.1026,
  ),
  Elevator(
    id: '1940-833',
    buildingName: '롯데월드타워',
    buildingCategory: '상업시설',
    address: '서울특별시 송파구 올림픽로 300',
    type: '장애인전망용',
    installYear: 2016,
    manufacturer: '쉰들러엘리베이터',
    capacity: 9,
    lastInspectedAt: '2025-12-01',
    isOperating: true,
    lat: 37.5126, lng: 127.1026,
  ),
  // 오피스
  Elevator(
    id: '3902-291',
    buildingName: '판교 알파돔타워',
    buildingCategory: '오피스',
    address: '경기도 성남시 분당구 판교역로 166',
    type: '수직형리프트',
    installYear: 2014,
    manufacturer: '현대엘리베이터',
    capacity: 17,
    lastInspectedAt: '2025-08-30',
    isOperating: true,
    lat: 37.3947, lng: 127.1109,
  ),
  // 아파트
  Elevator(
    id: '2018-399',
    buildingName: '휴먼시아아파트',
    buildingCategory: '아파트',
    address: '경기도 성남시 중원구 희망로 123',
    type: '승객용',
    installYear: 2018,
    manufacturer: '현대엘리베이터',
    capacity: 13,
    lastInspectedAt: '2025-06-10',
    isOperating: true,
    lat: 37.4452, lng: 127.1448,
  ),
  Elevator(
    id: '3815-441',
    buildingName: '분당 파크뷰 아파트 101동',
    buildingCategory: '아파트',
    address: '경기도 성남시 분당구 분당로 55',
    type: '승객용',
    installYear: 2012,
    manufacturer: '현대엘리베이터',
    capacity: 13,
    lastInspectedAt: '2025-07-14',
    isOperating: true,
    lat: 37.3756, lng: 127.1126,
  ),
  Elevator(
    id: '3815-442',
    buildingName: '분당 파크뷰 아파트 101동',
    buildingCategory: '아파트',
    address: '경기도 성남시 분당구 분당로 55',
    type: '화물용',
    installYear: 2012,
    manufacturer: '현대엘리베이터',
    capacity: 0,
    lastInspectedAt: '2025-07-14',
    isOperating: false,
    lat: 37.3756, lng: 127.1126,
  ),
  // 병원
  Elevator(
    id: '0841-771',
    buildingName: '서울아산병원',
    buildingCategory: '병원',
    address: '서울특별시 송파구 올림픽로 43길 88',
    type: '승객용',
    installYear: 2008,
    manufacturer: '오티스엘리베이터',
    capacity: 17,
    lastInspectedAt: '2025-10-30',
    isOperating: true,
    lat: 37.5270, lng: 127.1086,
  ),
  Elevator(
    id: '0841-772',
    buildingName: '서울아산병원',
    buildingCategory: '병원',
    address: '서울특별시 송파구 올림픽로 43길 88',
    type: '장애인용',
    installYear: 2008,
    manufacturer: '오티스엘리베이터',
    capacity: 9,
    lastInspectedAt: '2025-10-30',
    isOperating: true,
    lat: 37.5270, lng: 127.1086,
  ),
  Elevator(
    id: '0841-773',
    buildingName: '서울아산병원',
    buildingCategory: '병원',
    address: '서울특별시 송파구 올림픽로 43길 88',
    type: '화물용',
    installYear: 2008,
    manufacturer: '오티스엘리베이터',
    capacity: 0,
    lastInspectedAt: '2025-10-30',
    isOperating: true,
    lat: 37.5270, lng: 127.1086,
  ),
];

List<Elevator> get allElevators => _dummyElevators;

abstract class ElevatorRepository {
  Future<List<Elevator>> search(String query);
  Future<Elevator?> findById(String id);
  Future<List<Elevator>> getAll();
}

class ApiRepository implements ElevatorRepository {
  final _service = ElevatorService();

  @override
  Future<List<Elevator>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _service.search(_dummyElevators, query);
  }

  @override
  Future<Elevator?> findById(String id) async {
    try {
      return _dummyElevators.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Elevator>> getAll() async => _dummyElevators;
}
