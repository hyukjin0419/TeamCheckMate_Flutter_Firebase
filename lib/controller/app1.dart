import 'package:flutter/material.dart';
import 'auth_controller.dart';
import 'team_controller.dart';
import 'assignment_controller.dart';
import 'checklist_controller.dart';

class ApplicationState extends ChangeNotifier {
  final AuthController authController = AuthController();
  final TeamController teamController = TeamController();
  final AssignmentController assignmentController = AssignmentController();
  final ChecklistController checklistController = ChecklistController();

  ApplicationState() {
    // 초기화 코드
  }

  // 전체 ApplicationState의 notifyListeners를 호출하면 각 컨트롤러의 상태 변경을 알립니다.
  @override
  void notifyListeners() {
    super.notifyListeners();
    authController.notifyListeners();
    teamController.notifyListeners();
    assignmentController.notifyListeners();
    checklistController.notifyListeners();
  }
}
