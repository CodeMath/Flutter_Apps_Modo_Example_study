import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modo/components/modo_colors.dart';
import 'package:modo/pages/add/add_medicine_page.dart';
import 'package:modo/pages/history/history_page.dart';
import 'package:modo/pages/today/today_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _page = [const TodayPage(), const HistoryPage()];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        // 상단 부분 해제
        top: false,
        child: Scaffold(
          appBar: AppBar(),
          body: _page[_currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: _onAddMeicine,
            child: const Icon(CupertinoIcons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomAppBar(),
        ),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
        // 하단 부분 해제
        elevation: 0,
        child: Container(
            // 하단 권장 사이즈
            height: kBottomNavigationBarHeight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                    onPressed: () => _onTodayPage(0),
                    child: Icon(CupertinoIcons.check_mark,
                        color: _currentIndex == 0
                            ? ModoColors.primaryColor
                            : Colors.grey[400])),
                CupertinoButton(
                    child: Icon(CupertinoIcons.text_badge_checkmark,
                        color: _currentIndex == 1
                            ? ModoColors.primaryColor
                            : Colors.grey[400]),
                    onPressed: () => _onTodayPage(1))
              ],
            )));
  }

  void _onTodayPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  void _onAddMeicine() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicinepage()),
    );
  }
}
