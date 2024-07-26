import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'memo.dart';
import 'memo_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MemoProvider(),
      child: MaterialApp(
        theme: ThemeData.light(), // 기본 테마
        darkTheme: ThemeData.dark(), // 다크 모드 테마
        themeMode: ThemeMode.system, // 시스템 설정에 따라 테마 변경
        home: MemoScreen(),
      ),
    );
  }
}

class MemoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메모 앱')),
      body: Consumer<MemoProvider>(
        builder: (context, memoProvider, child) {
          return ListView.builder(
            itemCount: memoProvider.memos.length,
            itemBuilder: (context, index) {
              final memo = memoProvider.memos[index];
              return ListTile(
                title: Text(memo.content),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    memoProvider.deleteMemo(memo.id);
                  },
                ),
                onTap: () {
                  _controller.text = memo.content;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('메모 수정'),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        TextButton(
                          child: Text('취소'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text('저장'),
                          onPressed: () {
                            memoProvider.updateMemo(memo.id, _controller.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _controller.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('새 메모 추가'),
              content: TextField(
                controller: _controller,
              ),
              actions: [
                TextButton(
                  child: Text('취소'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('추가'),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<MemoProvider>(context, listen: false)
                          .addMemo(_controller.text);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
