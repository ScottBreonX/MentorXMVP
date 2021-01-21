class APIPath {
  static String profile(String uid, String profileInfo) =>
      'users/$uid/profile/$profileInfo';

  static String mentees(String university, String groupType, String uid) =>
      'mentees/$university/$groupType/$uid';
}
