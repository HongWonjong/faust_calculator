import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/story_view_model.dart';
import '../widgets/background_form.dart';
import '../widgets/group_form.dart';
import '../widgets/individual_form.dart';
import '../widgets/visualization.dart';

class StoryEditScreen extends ConsumerStatefulWidget {
  @override
  _StoryEditScreenState createState() => _StoryEditScreenState();
}

class _StoryEditScreenState extends ConsumerState<StoryEditScreen> {
  String selectedMenu = 'background';

  @override
  Widget build(BuildContext context) {
    final story = ref.watch(storyViewModelProvider);
    final partsAsync = ref.watch(partsProvider({
      'userId': 'testUser',
      'storyId': story!.id,
    }));
    return Scaffold(
      appBar: AppBar(
        title: Text(story?.title ?? '스토리 편집'),
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
                  title: Text('스토리 개요'),
                  onTap: () => setState(() => selectedMenu = 'overview'),
                ),
                ListTile(
                  title: Text('태그'),
                  onTap: () => setState(() => selectedMenu = 'tags'),
                ),
                ListTile(
                  title: Text('배경'),
                  onTap: () => setState(() => selectedMenu = 'background'),
                ),
                ListTile(
                  title: Text('그룹'),
                  onTap: () => setState(() => selectedMenu = 'groups'),
                ),
                ListTile(
                  title: Text('개인'),
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
                  TabBar(
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
                          padding: EdgeInsets.all(16),
                          child: _buildForm(),
                        ),
                        // Generation Tab
                        Center(child: Text('AI 스토리 생성 (미구현)')),
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
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => ref
                        .read(storyViewModelProvider.notifier)
                        .createPart('testUser', story!.id),
                    child: Text('새 파트'),
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
                    loading: () => Center(child: CircularProgressIndicator()),
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
        return TextField(
          maxLines: null,
          decoration: InputDecoration(
            hintText: '스토리 개요 입력',
            border: OutlineInputBorder(),
          ),
        );
      case 'tags':
        return TextField(
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