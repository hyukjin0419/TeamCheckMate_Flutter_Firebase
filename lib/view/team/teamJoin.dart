import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';

class TeamJoinPage extends StatefulWidget {
  const TeamJoinPage({super.key});

  @override
  _TeamJoinPageState createState() => _TeamJoinPageState();
}

class _TeamJoinPageState extends State<TeamJoinPage> {
  final GlobalKey qrKey = GlobalKey();
  Barcode? result;
  QRViewController? controller;
  bool _isJoiningTeam = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 코드 스캔'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('팀 ID: ${result!.code}')
                  : const Text('QR 코드를 스캔하세요'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    var teamController =
        Provider.of<ApplicationState>(context, listen: false).teamController;
    var userController =
        Provider.of<ApplicationState>(context, listen: false).authController;

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isJoiningTeam) return; // 이미 팀에 참여 중이면 리턴

      setState(() {
        result = scanData;
        _isJoiningTeam = true; // 팀 참여 상태로 설정
      });

      if (result != null) {
        String teamCode = result!.code!;
        try {
          await teamController.joinTeam(teamCode, userController.currentUser);
          // await Provider.of<ApplicationState>(context, listen: false).teamController
          //     .joinTeam(teamCode);
          if (mounted) {
            context.pop();
          }
        } finally {
          setState(() {
            _isJoiningTeam = false; // 팀 참여 상태 해제
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
