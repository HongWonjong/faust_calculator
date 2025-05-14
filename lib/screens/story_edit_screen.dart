import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart'; // 추가
import '../viewmodel/story_view_model.dart';
import '../widgets/background_form.dart';
import '../widgets/group_form.dart';
import '../widgets/individual_form.dart';
import '../widgets/visualization.dart';

class StoryEditScreen extends ConsumerStatefulWidget {
  const StoryEditScreen({super.key});

  @override
  _StoryEditScreenState createState() => _StoryEditScreenState();
}

class _StoryEditScreenState extends ConsumerState<StoryEditScreen> {
  String selectedMenu = 'background';

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보 가져오기
    final user = ref.watch(authServiceProvider);
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('로그인이 필요합니다.')),
      );
    }

    final userId = user.uid;
    final story = ref.watch(storyViewModelProvider);

    // story가 null일 경우 처리
    if (story == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('스토리 편집'),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(child: Text('스토리를 선택해주세요.')),
      );
    }

    final partsAsync = ref.watch(partsProvider({
      'userId': userId, // 현재 사용자 UID 사용
      'storyId': story.id,
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        backgroundColor: Colors.redAccent,
      ),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 200,
            color: Colors.grey[900],
            child: ListView(
              children: [
                ListTile(
                  title: const Text('스토리 개요'),
                  onTap: () => setState(() => selectedMenu = 'overview'),
                ),
                ListTile(
                  title: const Text('태그'),
                  onTap: () => setState(() => selectedMenu = 'tags'),
                ),
                ListTile(
                  title: const Text('배경'),
                  onTap: () => setState(() => selectedMenu = 'background'),
                ),
                ListTile(
                  title: const Text('그룹'),
                  onTap: () => setState(() => selectedMenu = 'groups'),
                ),
                ListTile(
                  title: const Text('개인'),
                  onTap: () => setState(() => selectedMenu = 'individuals'),
                ),
              ],
            ),
          ),
          // Central Panel
          Expanded(
            flex: 3,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: '편집'),
                      Tab(text: '생성'),
                    ],
                    labelColor: Colors.redAccent,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Editing Tab
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _buildForm(),
                        ),
                        // Generation Tab
                        const Center(child: Text('AI 스토리 생성 (미구현)')),
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
            color: Colors.grey[900],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => ref
                        .read(storyViewModelProvider.notifier)
                        .createPart(userId, story.id), // 현재 사용자 UID 사용
                    child: const Text('새 파트'),
                  ),
                ),
                Expanded(
                  child: partsAsync.when(
                    data: (parts) => ListView.builder(
                      itemCount: parts.length,
                      itemBuilder: (context, index) {
                        final part = parts[index];
                        return ListTile(
                          title: Text('파트 ${index + 1}'),
                          subtitle:
                          Text(part.story.isEmpty ? '내용 없음' : part.story),
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('Error: $err')),
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
    );
  }

  Widget _buildForm() {
    switch (selectedMenu) {
      case 'overview':
        return const TextField(
          maxLines: null,
          decoration: InputDecoration(
            hintText: '스토리 개요 입력',
            border: OutlineInputBorder(),
          ),
        );
      case 'tags':
        return const TextField(
          decoration: InputDecoration(
            hintText: '태그 입력 (쉼표로 구분)',
            border: OutlineInputBorder(),
          ),
        );
      case 'background':
        return BackgroundForm();
      case 'groups':
        return GroupForm();
      case 'individuals':
        return IndividualForm();
      default:
        return Container();
    }
  }
}