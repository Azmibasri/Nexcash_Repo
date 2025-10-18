import 'package:flutter/material.dart';
import '../widgets/button_home.dart';

class KatruQuiz extends StatelessWidget {
  final String bagian;
  final String judul;
  final String keterangan;
  final VoidCallback onPressed;

  const KatruQuiz({
    super.key,
    required this.bagian,
    required this.judul,
    required this.keterangan,
    required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bagian,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 25, 24, 59),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      judul,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 25, 24, 59),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(judul),
                    SizedBox(height: 5),
                    ButtonHome(
                      keterangan: keterangan,
                      onPressed: onPressed, 
                    ),
                  ],
                ),
              ),
            ),
            Flexible(child: Image.asset("assets/money.png")),
          ],
        ),
      ),
    );
  }
}