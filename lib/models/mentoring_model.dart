class MentorModel {
  MentorModel({
    this.status,
    this.openSlots,
    this.title,
  });
  final bool status;
  final int openSlots;
  final String title;

  factory MentorModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final bool status = data['status'];
    final int openSlots = data['Open Slots'];
    final String title = data['Title'];

    return MentorModel(
      status: status,
      openSlots: openSlots,
      title: title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'Open Slots': openSlots,
      'Title': title,
    };
  }
}
