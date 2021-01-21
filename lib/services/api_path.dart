class APIPath {
  static String profile(String uid, String profileInfo) =>
      'users/$uid/profile/$profileInfo';

  static String mentees(String university, String status, String uid) =>
      'mentees/$university/$status/$uid';
}
