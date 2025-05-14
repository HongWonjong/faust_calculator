import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../viewmodel/story_view_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/neon_glow_button.dart';
import '../widgets/loading_error_widget.dart';
import 'story_edit_screen.dart';

class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider);
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            '로그인이 필요합니다.',
            style: AppTheme.headline.copyWith(fontSize: 24),
          ),
        ),
      );
    }

    final userId = user.uid;
    final storiesAsync = ref.watch(storiesProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('파우스트의 계산기'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTheme.headline.copyWith(fontSize: 28),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: storiesAsync.when(
          data: (stories) => GridView.builder(
            padding: const EdgeInsets.all(24).copyWith(top: 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: stories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return CustomCard(
                  onTap: () => _createStory(context, ref, userId),
                  child: Center(
                    child: Text(
                      '+ 새 스토리',
                      style: AppTheme.bodyText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ),
                );
              }
              final story = stories[index - 1];
              return CustomCard(
                onTap: () {
                  ref.read(storyViewModelProvider.notifier).selectStory(story);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StoryEditScreen()),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: AppTheme.bodyText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.createdAt.toDate().toString(),
                      style: AppTheme.subtitle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text(
              'Error: $err',
              style: AppTheme.subtitle.copyWith(color: Colors.redAccent),
            ),
          ),
        ),
      ),
    );
  }

  void _createStory(BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: AppTheme.backgroundDark,
          title: Text(
            '새 스토리',
            style: AppTheme.headline.copyWith(fontSize: 24),
          ),
          content: TextField(
            controller: controller,
            style: AppTheme.bodyText,
            decoration: const InputDecoration(
              hintText: '스토리 제목',
              hintStyle: AppTheme.subtitle,
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white10,
            ),
          ),
          actions: [
            NeonGlowButton(
              text: '취소',
              onPressed: () => Navigator.pop(context),
              color: Colors.grey,
              fontSize: 16,
            ),
            NeonGlowButton(
              text: '생성',
              onPressed: () {
                ref
                    .read(storyViewModelProvider.notifier)
                    .createStory(userId, controller.text);
                Navigator.pop(context);
              },
              fontSize: 16,
            ),
          ],
        );
      },
    );
  }
}