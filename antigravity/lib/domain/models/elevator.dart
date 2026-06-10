class Elevator {
  final String id;
  final String buildingName;
  final String buildingCategory; // 학교·아파트·오피스·상업시설·병원
  final String address;
  final String type;
  final int installYear;
  final String manufacturer;
  final int capacity;
  final String lastInspectedAt;
  final bool isOperating;
  final double? lat;
  final double? lng;

  const Elevator({
    required this.id,
    required this.buildingName,
    required this.buildingCategory,
    required this.address,
    required this.type,
    required this.installYear,
    required this.manufacturer,
    required this.capacity,
    required this.lastInspectedAt,
    required this.isOperating,
    this.lat,
    this.lng,
  });

  // 국가승강기정보센터 번호 형식: XXXX-XXX
  // 서울 0·18·19 / 경기·인천 2·38·39 / 강원 4·48·49
  // 충청 5·58·59 / 경북 6·68·69 / 호남 7·78·79
  // 영남 8·88·89 / 제주 9·98·99
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

class InspectionRecord {
  final String elevatorId;
  final String inspectedAt;
  final String result;
  final String inspectorName;

  const InspectionRecord({
    required this.elevatorId,
    required this.inspectedAt,
    required this.result,
    required this.inspectorName,
  });
}
