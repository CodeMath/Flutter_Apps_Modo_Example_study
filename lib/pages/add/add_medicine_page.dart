import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMedicinepage extends StatelessWidget {
  const AddMedicinepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "어떤 약이에요?",
              style: Theme.of(context).textTheme.headline4,
            ),
            Center(
              child: CircleAvatar(
                radius: 40,
                child: CupertinoButton(
                  onPressed: () {},
                  child: const Icon(Icons.camera_alt_outlined,
                      size: 30, color: Colors.white),
                ),
              ),
            ),
            Text(
              "약 이름",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            TextFormField(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.subtitle1),
          child: const Text(
            "다음",
          ),
        ),
      ),
    );
  }
}
