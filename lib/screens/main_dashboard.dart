import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart'; // 추가
import '../viewmodel/story_view_model.dart';
import 'story_edit_screen.dart';

class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 로그인한 사용자의 UID 가져오기
    final user = ref.watch(authServiceProvider);
    if (user == null) {
      // 사용자가 로그인하지 않은 경우 처리
      return Scaffold(
        body: Center(child: Text('로그인이 필요합니다.')),
      );
    }

    final userId = user.uid;
    final storiesAsync = ref.watch(storiesProvider(userId)); // 현재 사용자 UID 사용

    return Scaffold(
      appBar: AppBar(
        title: const Text('파우스트의 계산기'),
        backgroundColor: Colors.redAccent,
      ),
      body: storiesAsync.when(
        data: (stories) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  onTap: () => _createStory(context, ref, userId),
                  child: const Center(child: Text('+ 새 스토리')),
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
                    MaterialPageRoute(builder: (_) =>  StoryEditScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story.title, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(story.createdAt.toDate().toString()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _createStory(BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('새 스토리'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '스토리 제목'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(storyViewModelProvider.notifier)
                    .createStory(userId, controller.text); // 현재 사용자 UID 전달
                Navigator.pop(context);
              },
              child: const Text('생성'),
            ),
          ],
        );
      },
    );
  }
}