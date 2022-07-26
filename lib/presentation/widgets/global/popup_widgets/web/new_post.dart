import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';

class PopupNewPost extends StatelessWidget {
  const PopupNewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size sizeOfScreen = MediaQuery.of(context).size;
    double widthOfScreen = sizeOfScreen.width;
    double heightOfScreen = sizeOfScreen.height;
    double? minimumSize;

    if (widthOfScreen / 2 < 800 || heightOfScreen / 2 < 400) {
      minimumSize = widthOfScreen / 2 > heightOfScreen / 2
          ? heightOfScreen / 2
          : widthOfScreen / 2;
      if (minimumSize < 290) minimumSize = 290;
    } else {
      minimumSize = null;
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: GestureDetector(
                    // to avoid popping the screen when tapping on the container
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: minimumSize ?? 780,
                      height: minimumSize ?? 820,
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, bottom: 8),
                              child: Text(
                                // there is no multi language in real instagram (web version)
                                'Create new post',
                                style: getMediumStyle(
                                    color: ColorManager.black, fontSize: 17),
                              ),
                            ),
                          ),
                          const Divider(color: ColorManager.grey),
                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorManager.blue)),
                                onPressed: () {},
                                child: Text(
                                  'Select from computer',
                                  style:
                                      getMediumStyle(color: ColorManager.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.close_rounded,
                      color: ColorManager.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
