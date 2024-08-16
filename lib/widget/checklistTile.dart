import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_check_mate/controller/app.dart';
import 'package:team_check_mate/model/member.dart';
import 'package:team_check_mate/widget/nameCard.dart';

class CheckListTile extends StatefulWidget {
  const CheckListTile({
    super.key,
    required this.teamId,
    required this.teamColor,
    required this.assignmentId,
  });

  final String teamId;
  final String teamColor;
  final String assignmentId;

  @override
  State<CheckListTile> createState() => _CheckListTile();
}

class _CheckListTile extends State<CheckListTile> {
  @override
  Widget build(BuildContext context) {
    var memberState =
        Provider.of<ApplicationState>(context, listen: true).memberController;
    return Expanded(
      //이름 - 체크리스트
      child: StreamBuilder<List<Member>>(
        stream: memberState.getMembersStream(widget.teamId),
        builder: (context, memberSnapshot) {
          if (memberSnapshot.hasData) {
            List<Member> members = memberSnapshot.data!;
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                Member member = members[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            child: IntrinsicWidth(
                              child: NameCardWithBtn(
                                text: member.name,
                                colorHex: widget.teamColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (memberSnapshot.hasError) {
            return Text('Error: ${memberSnapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
/*
받아와야 하는 정보
1. 팀 id, assignment id, 해당 하는 팀원 이름
2. 상태 정보 -> 지금 입력중인지 아닌지
3. 체크리스트 배열


렌더링 해야 하는 정보
1. 이름 버튼
2. 체크리스트 배열
2-1. 활성화시 입력박스 (추가)

생각해봐야할 것
1. 어떻게 정렬할 건지?



 */ 