import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Function(String) onColorSelected;

  const ColorPicker({super.key, required this.onColorSelected});

  Widget buildColorOption(BuildContext context, Color color, String colorName) {
    return GestureDetector(
      onTap: () {
        onColorSelected(colorName);
        Navigator.of(context).pop();
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 630,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text('색상', style: TextStyle(fontSize: 18))),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildColorOption(context, const Color(0xFFBAF6EF), 'BAF6EF'),
                buildColorOption(context, const Color(0xFFAFA7FF), 'AFA7FF'),
                buildColorOption(context, const Color(0xFFC0D4DF), 'C0D4DF'),
                buildColorOption(context, const Color(0xFFD7D2FF), 'D7D2FF'),
                buildColorOption(context, const Color(0xFFCCEEFF), 'CCEEFF'),
                buildColorOption(context, const Color(0xFF9AE1FF), '9AE1FF'),
                buildColorOption(context, const Color(0xFFFF8C39), 'FF8C39'),
                buildColorOption(context, const Color(0xFFF7D5FC), 'F7D5FC'),
                buildColorOption(context, const Color(0xFF5BEC61), '5BEC61'),
                buildColorOption(context, const Color(0xFF3FBFFF), '3FBFFF'),
                buildColorOption(context, const Color(0xFFFFE600), 'FFE600'),
                buildColorOption(context, const Color(0xFFFF6262), 'FF6262'),
                buildColorOption(context, const Color(0xFF6B8BD0), '6B8BD0'),
                buildColorOption(context, const Color(0xFFC898D7), 'C898D7'),
                buildColorOption(context, const Color(0xFFD3FF8A), 'D3FF8A'),
                buildColorOption(context, const Color(0xFF89E9E7), '89E9E7'),
                buildColorOption(context, const Color(0xFFF7FF99), 'F7FF99'),
                buildColorOption(context, const Color(0xFFFF6AA9), 'FF6AA9'),
                buildColorOption(context, const Color(0xFFA8EC9A), 'A8EC9A'),
                buildColorOption(context, const Color(0xFF8D8BFF), '8D8BFF'),
                buildColorOption(context, const Color(0xFF55CFC0), '55CFC0'),
                buildColorOption(context, const Color(0xFFFFADD9), 'FFADD9'),
                buildColorOption(context, const Color(0xFFFF97CF), 'FF97CF'),
                buildColorOption(context, const Color(0xFFFFCFE0), 'FFCFE0'),
                buildColorOption(context, const Color(0xFF9FC29D), '9FC29D'),
                buildColorOption(context, const Color(0xFF8CBE74), '8CBE74'),
                buildColorOption(context, const Color(0xFF559F76), '559F76'),
                buildColorOption(context, const Color(0xFF1FC671), '1FC671'),
                buildColorOption(context, const Color(0xFFCCFF61), 'CCFF61'),
                buildColorOption(context, const Color(0xFF5DC947), '5DC947'),
                buildColorOption(context, const Color(0xFF86C3D0), '86C3D0'),
                buildColorOption(context, const Color(0xFFF2CCCC), 'F2CCCC'),
                buildColorOption(context, const Color(0xFF9CB1BB), '9CB1BB'),
                buildColorOption(context, const Color(0xFFE9CFB6), 'E9CFB6'),
                buildColorOption(context, const Color(0xFFC2A88F), 'C2A88F'),
                buildColorOption(context, const Color(0xFF9A8265), '9A8265'),

                // 추가 색상 옵션
              ],
            ),
          ),
        ],
      ),
    );
  }
}
