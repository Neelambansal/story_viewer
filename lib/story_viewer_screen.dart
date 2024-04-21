import 'package:flutter/material.dart';
import 'package:story_viewer/repository/story_repository.dart';
import 'util.dart';
import 'package:story_view/story_view.dart';
import 'dart:core';

class StoryViewerScreen extends StatelessWidget {
  String? userImage = "";
  StoryViewerScreen({super.key, this.userImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserStory>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StoryViewDelegate(
                stories: snapshot.data, userImage: userImage);
          }

          if (snapshot.hasError) {
            return const Text("data not available");
          }

          return const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          );
        },
        future: Repository.getUserStories(),
      ),
    );
  }
}

class StoryViewDelegate extends StatefulWidget {
  final List<UserStory>? stories;
  final String? userImage;

  const StoryViewDelegate({super.key, this.stories, this.userImage});

  @override
  State<StoryViewDelegate> createState() => _StoryViewDelegateState();
}

class _StoryViewDelegateState extends State<StoryViewDelegate> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  String? when = "";

  @override
  void initState() {
    super.initState();
    for (var story in widget.stories!) {
      if (story.mediaType == MediaType.text) {
        storyItems.add(
          StoryItem.text(
            title: story.caption!,
            backgroundColor: HexColor(story.color!),
            duration: Duration(
              milliseconds: (story.duration! * 1000).toInt(),
            ),
          ),
        );
      }

      if (story.mediaType == MediaType.image) {
        storyItems.add(StoryItem.pageImage(
          url: story.media!,
          controller: controller,
          caption: Text(story.caption!),
          duration: Duration(
            milliseconds: (story.duration! * 1000).toInt(),
          ),
        ));
      }

      if (story.mediaType == MediaType.video) {
        storyItems.add(
          StoryItem.pageVideo(
            story.media!,
            controller: controller,
            duration: Duration(milliseconds: (story.duration! * 1000).toInt()),
            caption: Text(story.caption!),
          ),
        );
      }
    }

    when = widget.stories![0].when;
  }

  Widget _buildProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(widget.userImage!.toString())),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Hana_564",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                when!,
                style: const TextStyle(
                  color: Colors.white38,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StoryView(
            storyItems: storyItems,
            controller: controller,
            onComplete: () {
              Navigator.of(context).pop();
            },
            onVerticalSwipeComplete: (v) {
              if (v == Direction.down) {
                Navigator.pop(context);
              }
            }),
        Container(
          padding: const EdgeInsets.only(
            top: 48,
            left: 16,
            right: 16,
          ),
          child: _buildProfileView(),
        )
      ],
    );
  }
}
