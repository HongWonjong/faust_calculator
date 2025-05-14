import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../viewmodel/story_view_model.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_glow_button.dart';
import '../widgets/loading_error_widget.dart';
import '../widgets/background_form.dart';
import '../widgets/group_form.dart';
import '../widgets/individual_form.dart';
import '../widgets/side_bar_menu.dart';
import '../widgets/visualization.dart';

class StoryEditScreen extends ConsumerStatefulWidget {
  const StoryEditScreen({super.key});

  @override
  _StoryEditScreenState createState() => _StoryEditScreenState();
}

class _StoryEditScreenState extends ConsumerState<StoryEditScreen> {
  String selectedMenu = 'background';
  final List<String> menuItems = [
    '스토리 개요',
    '태그',
    '배경',
    '그룹',
    '개인',
  ];

  @override
  Widget build(BuildContext context) {
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
    final story = ref.watch(storyViewModelProvider);

    if (story == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('스토리 편집'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: AppTheme.headline.copyWith(fontSize: 28),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: Center(
            child: Text(
              '스토리를 선택해주세요.',
              style: AppTheme.headline.copyWith(fontSize: 24),
            ),
          ),
        ),
      );
    }

    final partsAsync = ref.watch(partsProvider({
      'userId': userId,
      'storyId': story.id,
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTheme.headline.copyWith(fontSize: 28),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Row(
          children: [
            // Left Sidebar
            SidebarMenu(
              items: menuItems,
              selectedItem: selectedMenu,
              onItemSelected: (item) => setState(() => selectedMenu = item),
            ),
            // Central Panel
            Expanded(
              flex: 3,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      child: TabBar(
                        tabs: const [
                          Tab(text: '편집'),
                          Tab(text: '생성'),
                        ],
                        labelColor: AppTheme.secondaryColor,
                        unselectedLabelColor: AppTheme.textSecondaryColor,
                        indicatorColor: AppTheme.secondaryColor,
                        labelStyle: AppTheme.bodyText.copyWith(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Editing Tab
                          Padding(
                            padding: AppTheme.pagePadding,
                            child: _buildForm(),
                          ),
                          // Generation Tab
                          Center(
                            child: Text(
                              'AI 스토리 생성 (미구현)',
                              style: AppTheme.subtitle.copyWith(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right Panel
            Container(
              width: 300,
              color: AppTheme.backgroundDark,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: NeonGlowButton(
                      text: '새 파트',
                      onPressed: () => ref
                          .read(storyViewModelProvider.notifier)
                          .createPart(userId, story.id),
                    ),
                  ),
                  Expanded(
                    child: partsAsync.when(
                      data: (parts) => ListView.builder(
                        itemCount: parts.length,
                        itemBuilder: (context, index) {
                          final part = parts[index];
                          return ListTile(
                            title: Text(
                              '파트 ${index + 1}',
                              style: AppTheme.bodyText,
                            ),
                            subtitle: Text(
                              part.story.isEmpty ? '내용 없음' : part.story,
                              style: AppTheme.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                   CustomPaint(
                    size: Size(300, 200),
                    painter: Map2DPainter(),
                  ),
                   CustomPaint(
                    size: Size(300, 200),
                    painter: RelationshipGraphPainter(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    switch (selectedMenu) {
      case '스토리 개요':
        return const TextField(
          maxLines: null,
          style: AppTheme.bodyText,
          decoration: InputDecoration(
            hintText: '스토리 개요 입력',
            hintStyle: AppTheme.subtitle,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white10,
          ),
        );
      case '태그':
        return const TextField(
          style: AppTheme.bodyText,
          decoration: InputDecoration(
            hintText: '태그 입력 (쉼표로 구분)',
            hintStyle: AppTheme.subtitle,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white10,
          ),
        );
      case '배경':
        return BackgroundForm();
      case '그룹':
        return GroupForm();
      case '개인':
        return IndividualForm();
      default:
        return Container();
    }
  }
}