import 'package:flutter/material.dart';
import 'package:instegram/core/resources/color_manager.dart';

class RecommendationPeople extends StatelessWidget{
  const RecommendationPeople({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        //width: 100.0,
        height: 35.0,
        width: 35,
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border.all(color: ColorManager.black12, width: 1.0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: const Center(
          child: Icon(Icons.person_add_outlined),
        ),
      ),
    );
  }

}