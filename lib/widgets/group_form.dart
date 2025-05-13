import 'package:flutter/material.dart';

class GroupForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: '그룹 이름',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            labelText: '멤버 목록 (쉼표로 구분)',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            labelText: '다른 그룹과의 관계',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}