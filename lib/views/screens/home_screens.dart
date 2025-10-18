import 'package:flutter/material.dart';
import 'package:nexcash_mvp/views/screens/quix_screens.dart';
import '../widgets/katru_daily.dart';
import '../widgets/kartu_quiz.dart'; 
import 'game_screens.dart';
import 'leaderboard_screens.dart';
import 'profile_screens.dart';


class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GameScreens()),
      );
    }
    else if(index == 2){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeaderboardScreens()),
      );
    }
    else if(index == 3){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreens()),
      );
    }  
    else if(index == 11){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuixScreens()),
      );
    }  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back, user",
                          style: TextStyle(
                              color: Color.fromARGB(255, 25, 24, 59),
                              fontWeight: FontWeight.bold,
                              fontFamily: "Noto Sans Symbols")),
                      Text("Lets learn!",
                          style: TextStyle(
                              color: Color.fromARGB(255, 25, 24, 59),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Noto Sans Symbols"))
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 25, 24, 59),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                        padding: EdgeInsets.all(20), child: KatruDaily())),
                Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        //color: const Color.fromARGB(255, 255, 255, 255)
                        ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Text("Quiz of The day",
                          style: TextStyle(
                              color: Color.fromARGB(255, 25, 24, 59),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: "Noto Sans Symbols")),
                    )),
                Expanded(
                    child: SizedBox(
                        width: double.infinity,
                        //color: const Color.fromARGB(255, 255, 255, 255),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ListView(children: [
                              
                              KatruQuiz(
                                  bagian: "Part 1",
                                  judul: "Dasar Literasi Keuangan",
                                  keterangan: "Complate",
                                  onPressed: () => _onItemTapped(11),
                                  ),
                              KatruQuiz(
                                  bagian: "Part 2",
                                  judul: "Dasar Literasi Keuangan",
                                  keterangan: "Play now",
                                  onPressed: () {
                                    
                                  },                                 
                              ),
                                  
                              KatruQuiz(
                                  bagian: "Part 3",
                                  judul: "Dasar Literasi Keuangan",
                                  keterangan: "Locked",
                                  onPressed: () {
                                    
                                  },
                                  ),
                              KatruQuiz(
                                  bagian: "Part 4",
                                  judul: "Dasar Literasi Keuangan",
                                  keterangan: "Locked",
                                  onPressed: () {
                                    
                                  },
                                  ),

                            ]))))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset("assets/home.png", height: 35, width: 35),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/game.png", height: 35, width: 35),
            label: "Game",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/leader.png", height: 35, width: 35),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/people.png", height: 25, width: 25),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/settings.png", height: 30, width: 30),
            label: "home",
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}