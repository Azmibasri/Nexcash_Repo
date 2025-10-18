import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- API SERVICE ---
class ChatbotService {
  // The API endpoint URL for the chatbot.
  static const String apiUrl = 'https://nexcash-repo.vercel.app/chat';

  /// Sends the entire conversation history to the chatbot API and returns the reply.
  ///
  /// The [conversationHistory] is a list of maps, each containing a 'sender' and 'text'.
  /// This history is converted to the required JSON format for the API.
  static Future<String> sendMessage(
      List<Map<String, String>> conversationHistory) async {
    try {
      // Convert the internal message format to the API's expected format.
      // We map 'user' to 'user' and 'bot' to 'assistant' for standard practice.
      final apiMessages = conversationHistory.map((message) {
        return {
          'role': message['sender'] == 'user' ? 'user' : 'assistant',
          'content': message['text'],
        };
      }).toList();

      // The final request body to be sent to the API.
      final requestBody = {
        'messages': apiMessages,
      };

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15)); // Increased timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'] ?? 'Maaf, saya tidak bisa merespons saat ini.';
      } else {
        return 'Terjadi kesalahan. Status: ${response.statusCode}';
      }
    } on TimeoutException {
      return 'Waktu koneksi habis. Silakan coba lagi.';
    } catch (e) {
      return 'Koneksi gagal. Pastikan internet Anda aktif.';
    }
  }
}

// --- BAGIAN 1: MODEL DATA ---
class Decision {
  final String label;
  final bool appliesAmount;

  const Decision({required this.label, required this.appliesAmount});
}

class GameEvent {
  final int id;
  final String title;
  final String description;
  final String type;
  final Color color;
  final int amount;
  final List<Decision> decisions;

  const GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.color,
    required this.amount,
    required this.decisions,
  });
}

// --- BAGIAN 2: DATA GAME ---
final List<GameEvent> gameLevels = [
  GameEvent(
    id: 0,
    title: 'START',
    description: 'Mulai petualanganmu menuju kebebasan finansial!',
    type: 'start',
    color: Colors.green,
    amount: 0,
    decisions: [],
  ),
  GameEvent(
    id: 1,
    title: 'Bonus Gaji Bulanan',
    description: 'Kamu menerima gaji bulanan dari pekerjaan part-time.',
    type: 'income',
    color: Colors.green,
    amount: 150000,
    decisions: [
      Decision(label: 'Terima', appliesAmount: true),
      Decision(label: 'Tolak', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 2,
    title: 'Godaan Belanja Online',
    description: 'Ada promo besar-besaran untuk barang gadget terbaru.',
    type: 'spending',
    color: Colors.red,
    amount: -300000,
    decisions: [
      Decision(label: 'Beli', appliesAmount: true),
      Decision(label: 'Tahan Diri', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 3,
    title: 'Ajakan Nonton Bareng',
    description: 'Teman mengajak nonton film bioskop + makan. Rp 50.000.',
    type: 'social_spending',
    color: Colors.orange,
    amount: -50000,
    decisions: [
      Decision(label: 'Pergi', appliesAmount: true),
      Decision(label: 'Batal', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 4,
    title: 'Peluang Bisnis Sampingan',
    description: 'Menjadi reseller dan dapatkan komisi Rp 200.000/bulan.',
    type: 'income',
    color: Colors.green,
    amount: 200000,
    decisions: [
      Decision(label: 'Terima', appliesAmount: true),
      Decision(label: 'Abaikan', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 5,
    title: 'Biaya Kesehatan Darurat',
    description: 'Kamu sakit dan perlu berobat ke dokter. Rp 200.000.',
    type: 'necessary_expense',
    color: Colors.yellow,
    amount: -200000,
    decisions: [
      Decision(label: 'Bayar', appliesAmount: true),
      Decision(label: 'Tunda', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 6,
    title: 'Investasi Crypto',
    description: 'Teman menawarkan investasi cryptocurrency. Janji 100% untung.',
    type: 'risky_investment',
    color: Colors.red,
    amount: -250000,
    decisions: [
      Decision(label: 'Investasi', appliesAmount: true),
      Decision(label: 'Jangan', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 7,
    title: 'Tabungan Berbunga',
    description: 'Kamu menabung di bank dan dapat bunga Rp 100.000.',
    type: 'income',
    color: Colors.green,
    amount: 100000,
    decisions: [
      Decision(label: 'Ambil', appliesAmount: true),
      Decision(label: 'Biarkan', appliesAmount: true), 
    ],
  ),
  GameEvent(
    id: 8,
    title: 'Utang Teman',
    description: 'Teman meminjam uang Rp 150.000 dengan janji bayar minggu depan.',
    type: 'lending',
    color: Colors.orange,
    amount: -150000,
    decisions: [
      Decision(label: 'Pinjamkan', appliesAmount: true),
      Decision(label: 'Tolak', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 9,
    title: 'Kuis Berhadiah Uang',
    description: 'Menang kuis online dan dapatkan hadiah uang tunai Rp 300.000!',
    type: 'lucky_income',
    color: Colors.lightGreen,
    amount: 300000,
    decisions: [
      Decision(label: 'Terima', appliesAmount: true),
      Decision(label: 'Tidak', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 10,
    title: 'Cicilan Hutang Kartu Kredit',
    description: 'Kamu punya hutang Rp 180.000 di kartu kredit.',
    type: 'debt_payment',
    color: Colors.red,
    amount: -180000,
    decisions: [
      Decision(label: 'Bayar', appliesAmount: true),
      Decision(label: 'Tunda', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 11,
    title: 'Diskon Makan Sehat',
    description: 'Promo makanan sehat 50% off. Rp 80.000 saja.',
    type: 'mixed_expense',
    color: Colors.yellow,
    amount: -80000,
    decisions: [
      Decision(label: 'Beli', appliesAmount: true),
      Decision(label: 'Lewati', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 12,
    title: 'Kursus Online Gratis',
    description: 'Ada kursus skill gratis yang bisa tingkatkan kemampuanmu.',
    type: 'neutral',
    color: Colors.blue,
    amount: 0,
    decisions: [
      Decision(label: 'Ambil', appliesAmount: false),
      Decision(label: 'Abaikan', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 13,
    title: 'Bonus Referral',
    description:
        'Ajak teman join dan dapat bonus Rp 50.000 per referral. 3 teman!',
    type: 'income',
    color: Colors.green,
    amount: 150000,
    decisions: [
      Decision(label: 'Bagikan', appliesAmount: true),
      Decision(label: 'Jangan', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 14,
    title: 'Asuransi Kesehatan',
    description: 'Premi asuransi kesehatan Rp 100.000/bulan.',
    type: 'protection_expense',
    color: Colors.yellow,
    amount: -100000,
    decisions: [
      Decision(label: 'Ambil', appliesAmount: true),
      Decision(label: 'Lewati', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 15,
    title: 'Pinjaman Ibu',
    description:
        'Ibu meminjamkan uang untuk biaya sekolah Rp 250.000 tanpa bunga.',
    type: 'family_loan',
    color: Colors.blue,
    amount: 250000,
    decisions: [
      Decision(label: 'Ambil', appliesAmount: true),
      Decision(label: 'Tolak', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 16,
    title: 'Pulsa Berlebihan',
    description: 'Kamu sering internet berlebihan. Biaya tambahan Rp 75.000.',
    type: 'unnecessary_expense',
    color: Colors.red,
    amount: -75000,
    decisions: [
      Decision(label: 'Bayar', appliesAmount: true),
      Decision(label: 'Kurangi', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 17,
    title: 'Resep Kue Dijual',
    description: 'Kue buatan rumah laku! Pendapatan Rp 400.000 bulan ini.',
    type: 'income',
    color: Colors.green,
    amount: 400000,
    decisions: [
      Decision(label: 'Ambil Hasil', appliesAmount: true),
      Decision(label: 'Reinvestasi', appliesAmount: true), 
    ],
  ),
  GameEvent(
    id: 18,
    title: 'Parkir Sembarangan',
    description: 'Kena denda parkir ilegal Rp 100.000.',
    type: 'penalty',
    color: Colors.red,
    amount: -100000,
    decisions: [
      Decision(label: 'Bayar', appliesAmount: true),
      Decision(label: 'Protes', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 19,
    title: 'Review Produk',
    description: 'Dibayar Rp 120.000 jadi reviewer produk di media sosial.',
    type: 'income',
    color: Colors.green,
    amount: 120000,
    decisions: [
      Decision(label: 'Terima', appliesAmount: true),
      Decision(label: 'Tolak', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 20,
    title: 'Undian Berhadiah',
    description: 'Menang undian hadiah senilai Rp 500.000!',
    type: 'lucky_income',
    color: Colors.lightGreen,
    amount: 500000,
    decisions: [
      Decision(label: 'Ambil', appliesAmount: true),
      Decision(label: 'Tidak', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 21,
    title: 'Buku Pelajaran Mahal',
    description: 'Butuh buku pelajaran Rp 200.000. Beli atau pinjam?',
    type: 'education_expense',
    color: Colors.yellow,
    amount: -200000,
    decisions: [
      Decision(label: 'Beli', appliesAmount: true),
      Decision(label: 'Pinjam', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 22,
    title: 'Program Loyalitas',
    description: 'Kumpul poin dari belanja dan dapat voucher Rp 75.000!',
    type: 'reward',
    color: Colors.lightGreen,
    amount: 75000,
    decisions: [
      Decision(label: 'Gunakan', appliesAmount: true),
      Decision(label: 'Kumpul Lagi', appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 23,
    title: 'Barang Elektronik Rusak',
    description: 'Headphone rusak. Beli baru atau coba perbaiki?',
    type: 'repair_or_replace',
    color: Colors.orange,
    amount: -150000,
    decisions: [
      Decision(label: 'Beli Baru', appliesAmount: true),
      Decision(
          label: 'Perbaiki',
          appliesAmount: false),
    ],
  ),
  GameEvent(
    id: 24,
    title: 'FINISH - Selamat!',
    description: 'Kamu sampai di garis finish. Lihat hasil keuanganmu!',
    type: 'finish',
    color: Colors.amber,
    amount: 0,
    decisions: [],
  ),
];

// --- BAGIAN 3: APLIKASI UTAMA ---
void main() {
  runApp(const QuixApp());
}

class QuixApp extends StatelessWidget {
  const QuixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreens(),
    );
  }
}

class GameScreens extends StatelessWidget {
  const GameScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MonopolyBoard(),
    );
  }
}



// --- BAGIAN 4: LOGIKA & STATE UTAMA GAME ---
class MonopolyBoard extends StatefulWidget {
  const MonopolyBoard({super.key});

  @override
  State<MonopolyBoard> createState() => _MonopolyBoardState();
}

class _MonopolyBoardState extends State<MonopolyBoard> with TickerProviderStateMixin {
  int currentPosition = 0;
  int balance = 100000; 
  int diceResult = 0;
  bool isRolling = false;
  GameEvent? currentEventData;
  bool showEventDialog = false;
  final List<GameEvent> levels = gameLevels;

  late ScrollController _scrollController;
  bool _showDiceDisplay = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void rollDice() {
    if (isRolling) return;

    final random = Random();
    final result = random.nextInt(6) + 1;

    setState(() {
      isRolling = true;
      diceResult = result;
      _showDiceDisplay = true;
    });
  }

  void _processMove() {
    int newPosition = currentPosition + diceResult;

    if (newPosition >= levels.length) {
      newPosition = levels.length - 1;
    }

    double targetOffset = (levels.length - 1 - newPosition) * 106.0;

    targetOffset = targetOffset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    ).whenComplete(() {
        if (!mounted) return;
         setState(() {
            currentPosition = newPosition;
            currentEventData = levels[currentPosition];
            showEventDialog = true;
            isRolling = false;
            _showDiceDisplay = false;
         });

        if (balance < 0) {
            _showGameOverDialog();
        }
    });
  }


  void handleDecision(Decision decision) {
    int changeAmount = 0;

    if (decision.appliesAmount) {
      changeAmount = currentEventData?.amount ?? 0;
    }

    setState(() {
      showEventDialog = false;
    });


     Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted) return; 
        setState(() {
          balance += changeAmount;
          if (balance < 0) {
            _showGameOverDialog();
          }
        });
     });

  }


  void resetGame() {
    setState(() {
      currentPosition = 0;
      balance = 100000; 
      diceResult = 0;
      showEventDialog = false;
      currentEventData = null;
      _showDiceDisplay = false;
    });
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _showGameOverDialog() {
    if (!mounted) return; 


    _displayGameOver();
  }

  void _displayGameOver() {
   if (mounted) {
       showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (dialogContext) => GameOverDialog( 
            onReset: () {
              Navigator.pop(dialogContext);
              resetGame();
            },
          ),
        );
   }
}


  void _showChatbotPopup() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(77),
      builder: (BuildContext context) {
        return const ChatbotDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.blue.shade900,
              const Color(0xFF005A9C),
              Colors.lightBlue.shade300,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            BoardListView(
              levels: levels,
              currentPosition: currentPosition,
              scrollController: _scrollController,
            ),
            Positioned(
              top: 10.0,
              left: 16.0,
              child: GestureDetector(
                onTap: () {
                   if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                   }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/back.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GameControls(
                balance: balance,
                currentPosition: currentPosition,
                totalLevels: levels.length,
                isRolling: isRolling,
                onRollDice: rollDice,
                onShowChatbot: _showChatbotPopup,
              ),
            ),
            if (_showDiceDisplay)
              DiceDisplay(
                finalResult: diceResult,
                onAnimationComplete: _processMove,
              ),
            if (showEventDialog && currentEventData != null)
              EventDialog(
                event: currentEventData!,
                diceResult: diceResult,
                onDecision: (decision) {
                  handleDecision(decision);
                },
              ),
          ],
        ),
      ),
    );
  }
}


// --- BAGIAN 5: WIDGET-WIDGET YANG DIPISAH ---

class BoardListView extends StatelessWidget {
  final List<GameEvent> levels;
  final int currentPosition;
  final ScrollController scrollController;

  const BoardListView({
    super.key,
    required this.levels,
    required this.currentPosition,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(top: 60, bottom: 200, left: 10, right: 10),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final actualIndex = levels.length - 1 - index;
        final event = levels[actualIndex];
        final isCurrentPosition = actualIndex == currentPosition;
        final bool isLeftAligned = actualIndex % 2 == 0;

        return LevelTile(
          event: event,
          isCurrent: isCurrentPosition,
          isLeftAligned: isLeftAligned,
          isFirst: actualIndex == 0,
          isLast: actualIndex == levels.length - 1,
        );
      },
    );
  }
}

class LevelTile extends StatelessWidget {
  final GameEvent event;
  final bool isCurrent;
  final bool isLeftAligned;
  final bool isFirst;
  final bool isLast;

  const LevelTile({
    super.key,
    required this.event,
    required this.isCurrent,
    required this.isLeftAligned,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final double tileWidth = MediaQuery.of(context).size.width * 0.65;

    final double connectorHeight = 90.0; 
    final double connectorWidth = 90.0;  
    const String connectorAsset = 'assets/ladder1.png'; 
    final double spaceForConnector = connectorHeight / 1.6;

    return SizedBox(
      height: 90 + (isLast ? 0 : spaceForConnector), 
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (!isLast)
            Positioned(
              top: -spaceForConnector, 
              left: isLeftAligned ? tileWidth * 0.8 : null,
              right: !isLeftAligned ? tileWidth * 0.8 : null,
              child: SizedBox(
                width: connectorWidth,
                height: connectorHeight, 
                child: Image.asset(
                  connectorAsset,
                  fit: BoxFit.contain,
                 ),
              ),
            ),

          // --- TILE UTAMA ---
          Align(
            alignment: isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: tileWidth,
              height: 90,
              margin: const EdgeInsets.symmetric(vertical: 3.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: event.color.withAlpha(isCurrent ? 255 : 220),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrent ? Colors.white : Colors.black54,
                  width: isCurrent ? 4 : 2,
                ),
                boxShadow: isCurrent
                    ? [ 
                        BoxShadow(
                          color: Colors.yellow.shade600,
                          spreadRadius: 3,
                          blurRadius: 8,
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isCurrent ? 16 : 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (event.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        event.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black.withAlpha(179),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (isCurrent)
            Positioned(
              top: -8,
              left: isLeftAligned ? 5 : null,
              right: !isLeftAligned ? 5 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'POSISI KU',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DiceDisplay extends StatefulWidget {
  final int finalResult;
  final VoidCallback onAnimationComplete;

  const DiceDisplay({
    super.key,
    required this.finalResult,
    required this.onAnimationComplete,
  });

  @override
  State<DiceDisplay> createState() => _DiceDisplayState();
}

class _DiceDisplayState extends State<DiceDisplay> with TickerProviderStateMixin {
  Timer? _rollTimer;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation; 
  bool _showResultNumber = false;

  static const String _diceAssetPath = 'assets/dice1.png';

  @override
  void initState() {
    super.initState();
    _showResultNumber = false;

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 500), () {
             if (mounted) widget.onAnimationComplete();
          });
        }
      });

     _rollTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
     });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _rollTimer?.cancel();
      setState(() {
         _showResultNumber = true;
      });
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _rollTimer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(102),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
               color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.lightBlue.shade700, width: 4),
              boxShadow: const [ BoxShadow( color: Colors.black38, spreadRadius: 3, blurRadius: 10,) ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                   borderRadius: BorderRadius.circular(16.0),
                   child: Image.asset(
                    _diceAssetPath,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                   ),
                 ),
                if (_showResultNumber)
                  Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Colors.black.withAlpha(150),
                       shape: BoxShape.circle,
                     ),
                    child: Text(
                      '${widget.finalResult}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [ Shadow( blurRadius: 4.0, color: Colors.black, offset: Offset(2.0, 2.0),) ]
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

class EventDialog extends StatelessWidget {
  final GameEvent event;
  final int diceResult;
  final ValueChanged<Decision> onDecision;

  const EventDialog({
    super.key,
    required this.event,
    required this.diceResult,
    required this.onDecision,
  });

   Color _getAmountColor() {
    if (event.amount > 0) return Colors.green.shade700;
    if (event.amount < 0) return Colors.red.shade700;
    return Colors.grey.shade700;
  }

  String _formatAmount(int amount) {
    if (amount == 0) return 'Tidak Ada Perubahan';
    String prefix = amount > 0 ? '+' : '';
    return '$prefix Rp ${amount.abs().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF82D5FA).withAlpha(242),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.lightBlue.shade700,
            width: 3,
          ),
          boxShadow: const [ BoxShadow( color: Colors.black38, spreadRadius: 3, blurRadius: 10,) ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade500,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all( color: Colors.lightBlue.shade700, width: 2,),
                        ),
                        child: const Icon( Icons.monetization_on, color: Colors.amber, size: 24,),
                      ),
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle( color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dadu: $diceResult',
                    style: const TextStyle( color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600,),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white .withAlpha(230),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event.description,
                        style: const TextStyle( color: Colors.black87, fontSize: 13, height: 1.5,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (event.amount != 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white .withAlpha(217),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all( color: _getAmountColor(), width: 2,),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text( 'Dampak:', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 12,),),
                            Text( _formatAmount(event.amount), style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold, color: _getAmountColor(),),),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: event.decisions.map((decision) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => onDecision(decision),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue.shade700,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10),),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          decision.label,
                          style: const TextStyle( color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13,),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameOverDialog extends StatelessWidget {
  final VoidCallback onReset;

  const GameOverDialog({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.shade400.withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade700, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning, size: 60, color: Colors.white),
            const SizedBox(height: 16),
            const Text( 'GAME OVER', style: TextStyle( fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,),),
            const SizedBox(height: 8),
            const Text( 'Saldo kamu habis!', style: TextStyle(fontSize: 16, color: Colors.white),),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10),),
              ),
              child: const Text( 'Main Lagi', style: TextStyle( color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16,),),
            ),
          ],
        ),
      ),
    );
  }
}

class GameControls extends StatelessWidget {
  final int balance;
  final int currentPosition;
  final int totalLevels;
  final bool isRolling;
  final VoidCallback onRollDice;
  final VoidCallback onShowChatbot;

  const GameControls({
    super.key,
    required this.balance,
    required this.currentPosition,
    required this.totalLevels,
    required this.isRolling,
    required this.onRollDice,
    required this.onShowChatbot,
  });

  String _formatBalance(int amount) {
    if (amount < 0) {
      return '-Rp ${amount.abs().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
    }
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  @override
  Widget build(BuildContext context) {
    const double navBarHeight = 80.0;
    const double buttonOverlap = 40.0;

    return SizedBox(
      height: navBarHeight + buttonOverlap,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size.fromHeight(navBarHeight),
              painter: NavbarPainter(),
              child: SizedBox(
                height: navBarHeight,
                child: _buildBottomMenuContent(),
              ),
            ),
          ),
          Positioned(
            top: -buttonOverlap,
            child: _buildGoButton(),
          ),
        ],
      ),
    );
  }

   Widget _buildGoButton() {
    const double buttonWidth = 120;
    const double buttonHeight = 120;

    return GestureDetector(
      onTap: isRolling ? null : onRollDice,
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: Image.asset('assets/gobutton.png'),
      ),
    );
  }

  Widget _buildBottomMenuContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onShowChatbot,
                child: Center( child: SizedBox( width: 60, height: 60, child: Image.asset('assets/chatbot.png'),),),
              ),
              const SizedBox(width: 25),
              Transform.scale(
                scale: 1.25,
                child: Center( child: SizedBox( width: 64, height: 64, child: Image.asset('assets/coins.png'),),),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.lightBlue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( 'Balance: ${_formatBalance(balance)}', style: const TextStyle(color: Colors.white, fontSize: 11),),
                Text( 'Posisi: ${currentPosition + 1}/$totalLevels', style: const TextStyle(color: Colors.lightBlue, fontSize: 11),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- CHATBOT DIALOG DENGAN API ---
class ChatbotDialog extends StatefulWidget {
  const ChatbotDialog({super.key});

  @override
  State<ChatbotDialog> createState() => _ChatbotDialogState();
}

class _ChatbotDialogState extends State<ChatbotDialog> {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {'sender': 'bot', 'text': 'Halo! Apa yang bisa saya bantu?'}
  ];
  
  // Variabel baru untuk melacak status loading
  bool _isLoading = false;

  // Fungsi _sendMessage yang sudah dimodifikasi
  void _sendMessage() async {
    final userMessageText = messageController.text;
    // Jangan kirim jika kosong atau sedang loading
    if (userMessageText.isEmpty || _isLoading) return;

    // 1. Update UI dengan pesan pengguna & set status loading
    setState(() {
      _isLoading = true;
      messages.add({'sender': 'user', 'text': userMessageText});
      messageController.clear();
    });

    // 2. Panggil API dengan seluruh riwayat percakapan
    // Kita menggunakan try-catch di sini untuk menangani error dari service
    String botReply;
    try {
      // 'messages' sekarang berisi pesan pengguna yang baru
      botReply = await ChatbotService.sendMessage(messages);
    } catch (e) {
      botReply = "Oops, terjadi error: $e";
    }

    // 3. Update UI dengan respon bot & matikan status loading
    setState(() {
      messages.add({'sender': 'bot', 'text': botReply});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        height: 450,
        decoration: BoxDecoration(
          color: const Color(0xFF82D5FA).withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.lightBlue.shade700,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2,
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade400.withAlpha(179),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.lightBlue.shade700,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.chat_bubble,
                      color: Colors.lightBlue,
                      size: 20,
                    ),
                  ),
                  const Text(
                    'Panduan Finansial',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isBot = msg['sender'] == 'bot';
                    return Align(
                      alignment:
                          isBot ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isBot
                              ? Colors.white.withAlpha(230)
                              : Colors.lightBlue.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            color: isBot ? Colors.black87 : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      // Nonaktifkan textfield saat loading
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: _isLoading ? 'Menunggu balasan...' : 'Ketik pesan...',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: Colors.white.withAlpha(204),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Modifikasi Tombol Kirim
                  GestureDetector(
                    // Nonaktifkan onTap saat loading
                    onTap: _isLoading ? null : _sendMessage,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        // Ubah warna saat loading
                        color: _isLoading
                            ? Colors.grey
                            : Colors.lightBlue.shade700,
                        shape: BoxShape.circle,
                      ),
                      // Tampilkan spinner atau ikon kirim
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 16,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavbarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = getPath(size);

    final fillPaint = Paint()
      ..color = const Color(0xFF82D5FA)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = Colors.lightBlue.shade700
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  Path getPath(Size size) {
    final path = Path();
    const double cornerRadius = 10.0;
    const double topEdgeY = 2.0;
    const double notchWidth = 70.0;

    path.moveTo(0, size.height);
    path.lineTo(0, topEdgeY + cornerRadius);
    path.quadraticBezierTo(0, topEdgeY, cornerRadius, topEdgeY);
    path.lineTo((size.width / 2) - (notchWidth / 2), topEdgeY);
    path.lineTo(size.width / 2, 0);
    path.lineTo((size.width / 2) + (notchWidth / 2), topEdgeY);
    path.lineTo(size.width - cornerRadius, topEdgeY);
    path.quadraticBezierTo( size.width, topEdgeY, size.width, topEdgeY + cornerRadius);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}