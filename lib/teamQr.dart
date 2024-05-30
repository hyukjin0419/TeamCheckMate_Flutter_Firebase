import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:team_check_mate/app.dart';
import 'package:team_check_mate/model/team.dart';

class TeamQRPage extends StatelessWidget {
  const TeamQRPage({super.key, required this.team});
  final Team team;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.backspace_outlined,
            semanticLabel: 'back',
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Team QR Code'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text('완료')),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: team.id,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const Text("이 코드를 사용해 팀원을 초대하세요"),
          ],
        ),
      ),
    );
  }
}
