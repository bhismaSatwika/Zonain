import 'package:flutter/material.dart';
import 'package:zonain/common/style.dart';
import 'package:zonain/model/user_details.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile_page';
  final UserDetails user;
  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(body: ProfileInner(user: user, parentContext: context)));
  }
}

class ProfileInner extends StatefulWidget {
  final UserDetails user;
  final BuildContext parentContext;

  const ProfileInner(
      {Key? key, required this.user, required this.parentContext})
      : super(key: key);

  @override
  State<ProfileInner> createState() => _ProfileInnerState();
}

class _ProfileInnerState extends State<ProfileInner> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: appBackground,
          leading: ProfileImage(imagePath: widget.user.imagePath),
          title: Text(widget.user.name),
          expandedHeight: 150,
          flexibleSpace: const Padding(
            padding: EdgeInsets.only(top: 100),
            child: Center(),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height - 150,
            decoration: BoxDecoration(
              color: appBackground,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ReactiveListItem(
                    text: "Nama",
                    secondText: widget.user.name,
                  ),
                  ReactiveListItem(
                    text: "Address",
                    secondText: widget.user.address,
                    secondColor: successColor,
                  ),
                  const Divider(height: 1),
                  const ReactiveListItem(
                    text: "Support",
                  ),
                  const Divider(height: 1),
                  const ReactiveListItem(
                    text: "Share",
                  ),
                  const ReactiveListItem(
                    text: "Terms & Condition",
                  ),
                  ReactiveListItem(
                    text: "Signout",
                    onTap: () {
                      //TODO: Add something to signout
                    },
                    color: dangerColor,
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(widget.parentContext);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: dangerColor,
                                onPrimary: Colors.white,
                                fixedSize: const Size(100, 36)),
                            child: const Text("Back"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(widget.parentContext);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: successColor,
                                onPrimary: Colors.white,
                                fixedSize: const Size(100, 36)),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ReactiveListItem extends StatefulWidget {
  final String text;
  final Function? onTap;
  final String secondText;
  final Color color;
  final Color secondColor;

  const ReactiveListItem(
      {required this.text,
      this.onTap,
      this.secondText = "",
      Key? key,
      this.color = Colors.black,
      this.secondColor = Colors.black})
      : super(key: key);

  @override
  State<ReactiveListItem> createState() => _ReactiveListItemState();
}

class _ReactiveListItemState extends State<ReactiveListItem> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Text(
        widget.text,
        style: TextStyle(fontSize: 14, color: widget.color),
      )
    ];
    if (widget.secondText.isNotEmpty) {
      _children.add(Text(
        widget.secondText,
        style: TextStyle(color: widget.secondColor),
      ));
    }

    return GestureDetector(
      onTap: () => widget.onTap,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _children),
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String imagePath;
  const ProfileImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8),
      child: ClipRRect(
        child: Image.network(
          imagePath,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
