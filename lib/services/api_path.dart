class APIPath {
  static String profile(String uid, String profileInfo) =>
      'users/$uid/profile/$profileInfo';

  static String mentoring(String university, String availability, String uid) =>
      'mentoring/$university/$availability/$uid';
}
