import 'package:flutter/material.dart';
import 'package:vchat/styles/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.callback,
      required this.width,
      this.height = 50.0, required this.name})
      : super(key: key);

  final VoidCallback callback;
  final double width;
  final double height;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        primary: VStyle.primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      onPressed: callback,
      child: Text(name , style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.w700, color: VStyle.white),),
    );
  }
}
