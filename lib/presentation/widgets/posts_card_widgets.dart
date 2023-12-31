import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media/application/providers.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/domain/models/user_model.dart' as model;
import 'package:social_media/presentation/screens/profiles/screen_profile.dart';
import 'package:social_media/presentation/widgets/comments_screen.dart';
import 'package:social_media/presentation/widgets/like_animation.dart';
import 'package:social_media/services/firestore_methods.dart';
import 'package:social_media/utils/utils.dart';


class PostsCardWidgets extends StatefulWidget {
  final snap;
  const PostsCardWidgets({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostsCardWidgets> createState() => _PostsCardWidgetsState();
}

class _PostsCardWidgetsState extends State<PostsCardWidgets> {
  int commentLn = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    fetchcomment();
    super.initState();
  }

  fetchcomment() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLn = snap.docs.length;
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.UserModel user = Provider.of<UserProvider>(context).getUser;
    return GestureDetector(
        onTap: () {
          Get.to(ProfileBaseScreen(uid: widget.snap['uid'].toString()));
        },
        child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(children: [
              // HEADER SECTION OF THE POST
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ).copyWith(right: 0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        widget.snap['profImage'].toString(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.snap['username'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.snap['uid'].toString() == user.uid
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: ListView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shrinkWrap: true,
                                        children: [
                                          'Delete',
                                        ]
                                            .map(
                                              (e) => InkWell(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                    child: Text(e),
                                                  ),
                                                  onTap: () {
                                                    deletePost(
                                                      widget.snap['postId']
                                                          .toString(),
                                                    );
                                                    // remove the dialog box
                                                    Navigator.of(context).pop();
                                                  }),
                                            )
                                            .toList()),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.more_vert),
                          )
                        : Container(),
                  ],
                ),
              ),
              // IMAGE SECTION OF THE POST
              GestureDetector(
                  onDoubleTap: () {
                    FireStoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      user.uid,
                      widget.snap['likes'],
                    );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      //height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['postUrl'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                            duration: const Duration(milliseconds: 400),
                            isAnimating: isLikeAnimating,
                            child: const Icon(Icons.favorite,
                                color: kwhitecolor, size: 100),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            }))
                  ])),
              // LIKE, COMMENT SECTION OF THE POST
              Row(
                children: <Widget>[
                  LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                          icon: widget.snap['likes'].contains(user.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                ),
                          onPressed: () => FireStoreMethods().likePost(
                              widget.snap['postId'].toString(),
                              user.uid,
                              widget.snap['likes']))),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.send,
                      ),
                      onPressed: () {}),
                  Expanded(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () {})))
                ],
              ),
              //DESCRIPTION AND NUMBER OF COMMENTS
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DefaultTextStyle(
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.w800),
                            child: Text(
                              '${widget.snap['likes'].length} likes',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 8),
                            child: RichText(
                                text: TextSpan(
                                    style: const TextStyle(color: kblackcolor),
                                    children: [
                                  TextSpan(
                                      text: widget.snap['username'].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: ' ${widget.snap['description']}')
                                ]))),
                        InkWell(
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text('View all $commentLn comments',
                                    style: const TextStyle(
                                        fontSize: 16, color: kblackcolor))),
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: ((context) {
                                  return CommentsScreen(
                                      postId: widget.snap['postId'].toString());
                                }),
                              );
                              // } Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => CommentsScreen(
                              //       postId: widget.snap['postId'].toString(),
                              //     ),
                              //   ),
                              // ),
                            }),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                                DateFormat.yMMMd().format(
                                    widget.snap['datePublished'].toDate()),
                                style: const TextStyle(color: kblackcolor)))
                      ]))
            ])));
  }
}
