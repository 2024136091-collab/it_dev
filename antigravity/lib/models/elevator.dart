class Elevator {
  final String id;
  final String buildingName;
  final String address;
  final String type;
  final int installYear;
  final String manufacturer;
  final int capacity;
  final String lastInspectedAt;
  final bool isOperating;

  const Elevator({
    required this.id,
    required this.buildingName,
    required this.address,
    required this.type,
    required this.installYear,
    required this.manufacturer,
    required this.capacity,
    required this.lastInspectedAt,
    required this.isOperating,
  });

  // 번호 형식: XXXX-XXX (예: 2091-192, 3819-299)
  String get region {
    final digits = id.replaceAll('-', '');
    final p2 = digits.length >= 2 ? digits.substring(0, 2) : '';
    final p1 = digits.isNotEmpty ? digits[0] : '';
    if (p2 == '18' || p2 == '19' || p1 == '0') return '서울';
    if (p2 == '38' || p2 == '39' || p1 == '2') return '경기·인천';
    if (p2 == '48' || p2 == '49' || p1 == '4') return '강원';
    if (p2 == '58' || p2 == '59' || p1 == '5') return '충청권';
    if (p2 == '68' || p2 == '69' || p1 == '6') return '경북권';
    if (p2 == '78' || p2 == '79' || p1 == '7') return '호남권';
    if (p2 == '88' || p2 == '89' || p1 == '8') return '영남권';
    if (p2 == '98' || p2 == '99' || p1 == '9') return '제주';
    return '기타';
  }
}

// 국가승강기정보센터 번호 형식: XXXX-XXX
// 서울 0·18·19 / 경기·인천 2·38·39 / 강원 4·48·49
// 충청 5·58·59 / 경북 6·68·69 / 호남 7·78·79
// 영남 8·88·89 / 제주 9·98·99
const List<Elevator> dummyElevators = [
  Elevator(
    id: '2091-142',   // 경기·인천 (2) — 승강기
    buildingName: '신구대학교 본관',
    address: '경기도 성남시 중원구 양현로 391',
    type: '승객용',
    installYear: 2015,
    manufacturer: '현대엘리베이터',
    capacity: 15,
    lastInspectedAt: '2025-11-20',
    isOperating: true,
  ),
  Elevator(
    id: '3819-208',   // 경기·인천 (38) — 에스컬레이터
    buildingName: '신구대학교 도서관',
    address: '경기도 성남시 중원구 양현로 391',
    type: '에스컬레이터',
    installYear: 2018,
    manufacturer: '오티스엘리베이터',
    capacity: 0,
    lastInspectedAt: '2025-10-05',
    isOperating: true,
  ),
  Elevator(
    id: '0153-924',   // 서울 (0) — 승강기
    buildingName: '강남 파이낸스센터',
    address: '서울특별시 강남구 테헤란로 152',
    type: '승객용',
    installYear: 2010,
    manufacturer: '티센크루프엘리베이터',
    capacity: 20,
    lastInspectedAt: '2025-09-18',
    isOperating: false,
  ),
  Elevator(
    id: '1940-831',   // 서울 (19) — 고속 승강기
    buildingName: '롯데월드타워',
    address: '서울특별시 송파구 올림픽로 300',
    type: '고속승객용',
    installYear: 2016,
    manufacturer: '쉰들러엘리베이터',
    capacity: 26,
    lastInspectedAt: '2025-12-01',
    isOperating: true,
  ),
  Elevator(
    id: '3902-291',   // 경기·인천 (39) — 수직형리프트
    buildingName: '판교 알파돔타워',
    address: '경기도 성남시 분당구 판교역로 166',
    type: '수직형리프트',
    installYear: 2014,
    manufacturer: '현대엘리베이터',
    capacity: 17,
    lastInspectedAt: '2025-08-30',
    isOperating: true,
  ),
];
