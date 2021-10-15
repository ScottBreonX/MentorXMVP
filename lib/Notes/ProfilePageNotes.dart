//body: Container(
//decoration: BoxDecoration(
//color: Colors.white,
//),
//child: Padding(
//padding: const EdgeInsets.only(
//left: 20.0, right: 20.0, top: 10.0),
//child: Container(
//child: SizedBox(
//height: double.infinity,
//child: ListView(
//children: [
//Padding(
//padding: const EdgeInsets.only(top: 10.0),
//child: Row(
//mainAxisAlignment:
//MainAxisAlignment.spaceBetween,
//crossAxisAlignment: aboutMeEditStatus
//? CrossAxisAlignment.center
//    : CrossAxisAlignment.end,
//children: [
//Text(
//'About Me',
//style: TextStyle(
//fontSize: 25.0,
//color: kMentorXPrimary,
//fontWeight: FontWeight.w600,
//),
//),
//aboutMeEditStatus
//? Row(
//children: [
//Padding(
//padding: const EdgeInsets.only(
//right: 8.0,
//bottom: 10.0,
//),
//child: GestureDetector(
//onTap: () {
//_updateAboutMe(context);
//},
//child: Container(
//height: 40.0,
//width: 40.0,
//decoration: BoxDecoration(
//shape: BoxShape.circle,
//color: Colors.white,
//boxShadow: [
//BoxShadow(
//blurRadius: 2,
//offset: Offset(2, 2),
//color: Colors.black54,
//spreadRadius: 0.5,
//)
//],
//),
//child: Icon(
//Icons.check,
//color: Colors.green,
//),
//),
//),
//),
//Padding(
//padding: const EdgeInsets.only(
//right: 8.0, bottom: 10.0),
//child: GestureDetector(
//onTap: () {
//setState(() {
//aboutMeEditStatus = false;
//});
//},
//child: Container(
//height: 40.0,
//width: 40.0,
//decoration: BoxDecoration(
//shape: BoxShape.circle,
//color: Colors.white,
//boxShadow: [
//BoxShadow(
//blurRadius: 2,
//offset: Offset(2, 2),
//color: Colors.black54,
//spreadRadius: 0.5,
//)
//],
//),
//child: Icon(
//Icons.close,
//color: Colors.red,
//),
//),
//),
//),
//],
//)
//: Padding(
//padding: const EdgeInsets.only(
//right: 8.0),
//child: GestureDetector(
//onTap: () {
//setState(() {
//aboutMeEditStatus = true;
//});
//},
//child: IconCircle(
//width: 30.0,
//height: 30.0,
//circleColor: kMentorXPrimary,
//iconColor: Colors.white,
//iconSize: 20.0,
//iconType: Icons.edit,
//),
//),
//),
//],
//),
//),
//aboutMeEditStatus
//? _buildAboutMeTextField(context)
//: Padding(
//padding: const EdgeInsets.only(
//top: 8.0, right: 10.0),
//child: Row(
//children: [
//Flexible(
//child: Text(
//'${profileData['About Me'] ?? "<Blank>"}',
//style: TextStyle(
//fontSize: 15.0,
//color: Colors.black54,
//),
//),
//),
//],
//),
//),
//Padding(
//padding: const EdgeInsets.only(top: 40.0),
//child: Row(
//mainAxisAlignment:
//MainAxisAlignment.spaceBetween,
//crossAxisAlignment: CrossAxisAlignment.end,
//children: [
//Text(
//'Work Experience',
//style: TextStyle(
//fontSize: 25.0,
//color: kMentorXPrimary,
//fontWeight: FontWeight.w600,
//),
//),
//Padding(
//padding:
//const EdgeInsets.only(right: 8.0),
//child: GestureDetector(
//onTap: () {
//setState(() {
//_editWorkExperience(context);
//});
//},
//child: IconCircle(
//height: 30.0,
//width: 30.0,
//iconSize: 20.0,
//iconType: Icons.edit,
//circleColor: kMentorXPrimary,
//iconColor: Colors.white,
//),
//),
//),
//],
//),
//),
//Padding(
//padding: const EdgeInsets.only(top: 8.0),
//child: const Divider(
//color: Colors.white,
//),
//),
//WorkExperienceSection(
//title: 'Summer Bro Intern',
//company: 'The Walt Disney Company',
//dateRange: 'April 2019 - April 2020',
//location: 'Burbank, CA',
//description:
//profileData['About Me'] ?? "<Blank>",
//dividerColor: Colors.transparent,
//dividerHeight: 0,
//workExpEditStatus: () {
//setState(() {
//_editWorkExperience(context);
//});
//},
//),
//],
//),
//),
//),
//),
//),
