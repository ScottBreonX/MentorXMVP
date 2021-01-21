class MentorModel {
  MentorModel({
    this.uid,
    this.availableSlots,
  });
  final int availableSlots;
  final String uid;

  factory MentorModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final int availableSlots = data['Available Slots'];
    final String uid = data['UID'];

    return MentorModel(
      availableSlots: availableSlots,
      uid: uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Available Slots': availableSlots,
      'UID': uid,
    };
  }
}
