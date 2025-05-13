import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/story_view_model.dart';
import 'story_edit_screen.dart';

class MainDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider('testUser')); // 테스트용 userId
    return Scaffold(
      appBar: AppBar(
        title: Text('파우스트의 계산기'),
        backgroundColor: Colors.redAccent,
      ),
      body: storiesAsync.when(
        data: (stories) => GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: stories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Card(
                child: InkWell(
                  onTap: () => _createStory(context, ref),
                  child: Center(child: Text('+ 새 스토리')),
                ),
              );
            }
            final story = stories[index - 1];
            return Card(
              child: InkWell(
                onTap: () {
                  ref.read(storyViewModelProvider.notifier).selectStory(story);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StoryEditScreen()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story.title, style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text(story.createdAt.toDate().toString()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _createStory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('새 스토리'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: '스토리 제목'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(storyViewModelProvider.notifier)
                    .createStory('testUser', controller.text);
                Navigator.pop(context);
              },
              child: Text('생성'),
            ),
          ],
        );
      },
    );
  }
}