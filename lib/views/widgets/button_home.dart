import 'package:flutter/material.dart';

class ButtonHome extends StatelessWidget {
  final String keterangan;
  final VoidCallback onPressed;

  const ButtonHome({
    super.key,
    required this.keterangan,
    required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onPressed, 
      borderRadius: BorderRadius.circular(5), 
      child: Container(
        width: 100,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            keterangan,
            style: TextStyle(color: Colors.white, fontSize: 12), 
          ),
        ),
      ),
    );
  }
}