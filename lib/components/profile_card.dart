import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/profile_image_circle.dart';
import 'package:mentorx_mvp/models/user.dart';
import '../constants.dart';

class ProfileCard extends StatefulWidget {
  myUser user;
  String profilePicture;

  ProfileCard({
    Key key,
    @required this.user,
    @required this.profilePicture,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 1),
                color: Colors.grey[500],
              ),
            ],
            color: Colors.grey.shade200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: CircleAvatar(
                      backgroundColor: kMentorXPSecondary,
                      radius: 38,
                      child: Container(
                        child: widget.profilePicture == null ||
                                widget.profilePicture.isEmpty ||
                                widget.profilePicture == ""
                            ? ProfileImageCircle(
                                circleColor: Colors.grey,
                                iconSize: 30,
                                iconColor: Colors.white,
                                circleSize: 50,
                              )
                            : CircleAvatar(
                                radius: 35,
                                child: CachedNetworkImage(
                                  imageUrl: widget.profilePicture,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250,
                          child: Text(
                            '${widget.user.firstName} ${widget.user.lastName}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            '${widget.user.email}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          height: 100,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
