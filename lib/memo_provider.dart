import 'package:flutter/material.dart';
import 'memo.dart';
import 'package:uuid/uuid.dart';

class MemoProvider with ChangeNotifier {
  List<Memo> _memos = [];

  List<Memo> get memos => _memos;

  void addMemo(String content) {
    final newMemo = Memo(id: Uuid().v4(), content: content);
    _memos.add(newMemo);
    notifyListeners();
  }

  void updateMemo(String id, String newContent) {
    final index = _memos.indexWhere((memo) => memo.id == id);
    if (index != -1) {
      _memos[index].content = newContent;
      notifyListeners();
    }
  }

  void deleteMemo(String id) {
    _memos.removeWhere((memo) => memo.id == id);
    notifyListeners();
  }
}