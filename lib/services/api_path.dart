class APIPath {
  static String user(String uid) => 'users/$uid';

  static String mentorInfo(String uid, String profileInfo) =>
      'users/$uid/mentorInfo/$profileInfo';

  static String mentoring(String university, String availability, String uid) =>
      'mentoring/$university/$availability/$uid';

  static String mentorMatch(String university, String uid, String mentorUID) =>
      'mentoring/$university/matches/$uid$mentorUID';
}
