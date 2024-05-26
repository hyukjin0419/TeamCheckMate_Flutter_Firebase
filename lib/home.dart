import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: FolderCard(),
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  const FolderCard({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 화면 크기 측정
    double screenWidth = MediaQuery.of(context).size.width;

    // 가로 크기를 화면의 80%로 설정
    double cardWidth = screenWidth * 0.8;
    // 세로 크기를 가로 크기의 1/3.5로 설정
    double cardHeight = cardWidth / 3.5;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      color: const Color.fromRGBO(245, 245, 245, 1.0),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
      ),
    );
  }
}
