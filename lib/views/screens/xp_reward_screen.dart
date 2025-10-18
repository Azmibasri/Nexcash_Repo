import 'package:flutter/material.dart';
import 'home_screens.dart'; // BARU: Import home_screens.dart

class XpRewardScreen extends StatefulWidget {
  final int totalXp;

  const XpRewardScreen({
    super.key,
    required this.totalXp,
  });

  @override
  State<XpRewardScreen> createState() => _XpRewardScreenState();
}

class _XpRewardScreenState extends State<XpRewardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _xpAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _xpAnimation = IntTween(begin: 0, end: widget.totalXp).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // BARU: Tambahkan listener untuk mendeteksi saat animasi selesai
    _controller.addStatusListener((status) {
      // Jika animasi sudah selesai (completed)
      if (status == AnimationStatus.completed) {
        // Tunggu 1.5 detik sebelum pindah halaman
        Future.delayed(const Duration(milliseconds: 1500), () {
          // Cek apakah widget masih ada di tree sebelum navigasi
          if (mounted) {
            _navigateToHome();
          }
        });
      }
    });

    _controller.forward();
  }
  
  // BARU: Buat fungsi navigasi agar tidak duplikat kode
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreens()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19183B),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '✨ Kerja Bagus! ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _xpAnimation,
                  builder: (context, child) {
                    return Text(
                      '+${_xpAnimation.value} XP',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  // MODIFIKASI: Tombol ini sekarang juga memanggil fungsi navigasi
                  onPressed: _navigateToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF19183B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}