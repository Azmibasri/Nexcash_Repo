import 'package:flutter/material.dart';
import 'package:nexcash_mvp/views/screens/home_screens.dart';
import 'game_screens.dart';
import 'leaderboard_screens.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreens();
}

class _ProfileScreens extends State<ProfileScreens> {
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GameScreens()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeaderboardScreens()),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreens()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreens()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 93, 143, 230),
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.settings, color: Colors.white, size: 30),
                      onPressed: () => _onItemTapped(4),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 75.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 161, 194, 189),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 90.0),
                            Text(
                              "Rafid Khaulika",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(221, 26, 26, 26),
                              ),
                            ),
                            Text(
                              "@Rafid123",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 24),

                            _buildSectionHeader("Badges (4)"),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.0,
                                children: [
                                  _buildBadgeCard(
                                    Image.asset("assets/leader.png"),
                                    "#1",
                                    "World Rank",
                                  ),
                                  _buildBadgeCard(
                                    Image.asset(
                                      "assets/coins.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                    "1444 XP",
                                    "XP Total",
                                  ),
                                  _buildBadgeCard(
                                    Image.asset(
                                      "assets/fire.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                    "12",
                                    "Days Streak",
                                  ),
                                  _buildBadgeCard(
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    "0",
                                    "Heart Loss",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),

                            _buildSectionHeader("Friends (4)"),
                            SizedBox(height: 8),
                            _buildFriendsList(),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 161, 194, 189),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromARGB(255, 161, 194, 189),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.blueAccent,
                          size: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(221, 26, 26, 26),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard(Widget icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 50,
        child: Stack(
          children: [
            _buildFriendAvatar(Colors.blue.shade200, left: 0),
            _buildFriendAvatar(Colors.pink.shade100, left: 35),
            _buildFriendAvatar(Colors.red.shade200, left: 70),
            _buildFriendAvatar(Colors.green.shade200, left: 105),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendAvatar(Color color, {required double left}) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromARGB(255, 161, 194, 189), // Warna background hijau
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 23,
          backgroundColor: color,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ),
    );
  }
}
