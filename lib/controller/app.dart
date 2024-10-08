import 'package:flutter/material.dart';
import 'package:team_check_mate/controller/member_controller.dart';
import 'package:team_check_mate/controller/team_order_controller.dart';
import 'auth_controller.dart';
import 'team_controller.dart';
import 'assignment_controller.dart';
import 'checklist_controller.dart';

class ApplicationState extends ChangeNotifier {
  final AuthController authController = AuthController();
  final TeamController teamController = TeamController();
  final AssignmentController assignmentController = AssignmentController();
  final ChecklistController checklistController = ChecklistController();
  final MemberController memberController = MemberController();
  final TeamOrderController teamOrderController = TeamOrderController();

  ApplicationState() {
    // 초기화 코드
  }

  // 전체 ApplicationState의 notifyListeners를 호출하면 각 컨트롤러의 상태 변경을 알립니다.
  @override
  void notifyListeners() {
    super.notifyListeners();
    authController.notifyListeners();
    teamController.notifyListeners();
    teamOrderController.notifyListeners();
    assignmentController.notifyListeners();
    checklistController.notifyListeners();
    memberController.notifyListeners();
  }
}
