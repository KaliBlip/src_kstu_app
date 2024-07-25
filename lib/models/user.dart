class User {
  int? id;
  int? facultyId;
  int? deptId;
  int? programId;
  String? name;
  String? email;
  String? gender;
  String? userImg;
  int? indexNo;
  String? currentLevel;
  int? currentSem;
  int? status;
  String? yrOfAdmission;
  String? yrOfCompletion;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? facultyName;
  String? deptName;
  String? programName;
  String? token;
  String? type;
  String? state;

  User({
    this.status,
    this.id,
    this.name,
    this.email,
    this.gender,
    this.userImg,
    this.indexNo,
    this.currentLevel,
    this.currentSem,
    this.facultyId,
    this.deptId,
    this.programId,
    this.yrOfAdmission,
    this.yrOfCompletion,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.facultyName,
    this.deptName,
    this.programName,
    this.token,
    this.type,
    this.state,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        state: json['state'],
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        gender: json['user']['gender'],
        userImg: json['user']['user_img'] ?? '1',
        indexNo: json['user']['index_no'],
        currentLevel: json['user']['current_level'],
        currentSem: json['user']['current_sem'],
        facultyId: json['user']['faculty_id'],
        deptId: json['user']['dept_id'],
        programId: json['user']['program_id'],
        status: json['user']['status'],
        yrOfAdmission: json['user']['yr_of_admission'],
        yrOfCompletion: json['user']['yr_of_completion'],
        phone: json['user']['phone'],
        createdAt: json['user']['created_at'],
        updatedAt: json['user']['updated_at'],
        facultyName: json['user']['faculty_name'],
        deptName: json['user']['dept_name'],
        programName: json['user']['program_name'],
        token: json['authorisation']['token'],
        type: json['authorisation']['type']);
  }
}
