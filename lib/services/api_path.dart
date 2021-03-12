class APIPath {
  static String profile(String uid, String profileInfo) =>
      'users/$uid/profile/$profileInfo';

  static String workExperience(String uid, String profileInfo, String field) =>
      'users/$uid/profile/$profileInfo/workexperience/$field';

  static String mentorInfo(String uid, String profileInfo) =>
      'users/$uid/mentorInfo/$profileInfo';

  static String mentoring(String university, String availability, String uid) =>
      'mentoring/$university/$availability/$uid';

  static String mentorMatch(String university, String uid, String mentorUID) =>
      'mentoring/$university/matches/$uid$mentorUID';
}
