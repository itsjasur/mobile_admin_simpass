double desktopBreakPoint = 700;

Map<String, List> rolePathAccessInfo = {
  "/profile": ["ALL"],
  "/manage-users": ["ROLE_SUPER", "ROLE_ADMIN"],
  "/manage-plans": ['ROLE_SUPER', 'ROLE_ADMIN', 'ROLE_MANAGER', 'ROLE_OPEN_ADMIN'],
  "/applications": ['ROLE_SUPER', 'ROLE_ADMIN', 'ROLE_MANAGER', 'ROLE_OPEN_ADMIN', 'ROLE_OPEN_MANAGER'],
  "/retailers": ['ROLE_SUPER', 'ROLE_ADMIN', 'ROLE_MANAGER', 'ROLE_OPEN_ADMIN'],
  "/customer-requests": ['ALL'],
};

const List countryNameCodelist = [
  {"code": 'CN', "label": '중국'},
  {"code": 'VN', "label": '베트남'},
  {"code": 'ID', "label": '인도네시아'},
  {"code": 'KH', "label": '캄보디아'},
  {"code": 'MN', "label": '몽골'},
  {"code": 'MM', "label": '미얀마'},
  {"code": 'TH', "label": '태국'},
  {"code": 'PH', "label": '필리핀'},
  {"code": 'HK', "label": '홍콩'},
  {"code": 'NP', "label": '네팔'},
  {"code": 'TW', "label": '대만'},
  {"code": 'BD', "label": '방글라데시'},
  {"code": 'LK', "label": '스리랑카'},
  {"code": 'ID', "label": '인도'},
  {"code": 'MY', "label": '말레이시아'},
  {"code": 'UZ', "label": '우즈베키스탄'},
  {"code": 'KZ', "label": '카자흐스탄'},
  {"code": 'RU', "label": '러시아'},
  {"code": 'US', "label": '미국'},
  {"code": 'KR', "label": '대한민국'},
  {"code": 'EN', "label": '영어권 국가'},
];

const List applicationsSearchTypeList = [
  {"code": 'applyDate', "label": '접수일자'},
  {"code": 'regisDate', "label": '개통일자'},
  {"code": 'status', "label": '상태'},
];
final List<int> perPageCounts = [50, 100, 250, 500];

final List<Map<String, dynamic>> userRolesList = [
  {
    "id": 1,
    "label": "관리자",
    "code": "ROLE_ADMIN",
    "state": 'active',
    "checked": false,
    "high": [],
    "low": ["ALL"]
  },
  {
    "id": 2,
    "label": "담당자",
    "code": "ROLE_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_USER", "ROLE_OPEN_MANAGER", "ROLE_OPEN_MEMBER", "ROLE_EXP_MANAGER", "ROLE_EXP_MEMBER", "ROLE_MALL_MANAGER", "ROLE_MALL_MEMBER"]
  },
  {
    "id": 3,
    "label": "사용자",
    "code": "ROLE_USER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER"],
    "low": ["ROLE_OPEN_MEMBER", "ROLE_EXP_MEMBER", "ROLE_MALL_MEMBER"]
  },

  //
  //개통
  {
    "id": 4,
    "label": "개통관리자",
    "code": "ROLE_OPEN_ADMIN",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_OPEN_MANAGER", "ROLE_OPEN_MEMBER"]
  },
  {
    "id": 5,
    "label": "개통담당자",
    "code": "ROLE_OPEN_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_OPEN_ADMIN"],
    "low": ["ROLE_OPEN_MEMBER"]
  },
  {
    "id": 6,
    "label": "개통사용자",
    "code": "ROLE_OPEN_MEMBER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_USER", "ROLE_OPEN_ADMIN", "ROLE_OPEN_MANAGER"],
    "low": []
  },

  //
  //해외배송
  {
    "id": 7,
    "label": "해외배송관리자",
    "code": "ROLE_EXP_ADMIN",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_EXP_MANAGER", "ROLE_EXP_MEMBER"]
  },
  {
    "id": 8,
    "label": "해외배송담당자",
    "code": "ROLE_EXP_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_EXP_ADMIN"],
    "low": ["ROLE_EXP_MEMBER"]
  },
  {
    "id": 9,
    "label": "해외배송사용자",
    "code": "ROLE_EXP_MEMBER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_USER", "ROLE_EXP_ADMIN", "ROLE_EXP_MANAGER"],
    "low": []
  },

  //
  //쇼핑몰
  {
    "id": 10,
    "label": "쇼핑몰관리자",
    "code": "ROLE_MALL_ADMIN",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_MALL_MANAGER", "ROLE_MALL_MEMBER"]
  },
  {
    "id": 11,
    "label": "쇼핑몰담당자",
    "code": "ROLE_MALL_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_MALL_ADMIN"],
    "low": ["ROLE_MALL_MEMBER"]
  },
  {
    "id": 12,
    "label": "쇼핑몰사용자",
    "code": "ROLE_MALL_MEMBER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_USER", "ROLE_MALL_ADMIN", "ROLE_MALL_MANAGER"],
    "low": []
  },
];

final List<Map<String, dynamic>> memberStatuses = [
  {"label": "사용중", "code": "Y"},
  {"label": "미사용", "code": "N"},
  {"label": "삭제", "code": "D"},
  {"label": "승인대기", "code": "W"},
];

final List manageMembersColumns = ['No.', '아이디', '이름', '국가', '휴대전화', '이매일', '상태', '시작일자', '액션'];
final List mangePlansColumns = ['No.', '상태', '요금제명', '통신사', '브랜드', '대리점', '서비스 유형', '가입대상', '기본료', '판매금액', '음성', '문자', '데이터', '영상/기타', 'QOS', '액션'];

final List applicationsColumns = ['No.', '판매점영', '상태', '접수번호', '고객명', '후대펀', '가입정보', '가입신청서', '접수일자', '개통일자', '서명여부'];

final List retailersColumns = ['No.', '상태', '만매점명', '대표자명', '연락처', '사업자번호', '접수일자', '계약일자', '상세정보'];

final List customerRequestsColumns = ['No.', '상태명', '이름', '연락처', '국가', '요금제', '가입구분명', '요청 날짜', '세부'];
