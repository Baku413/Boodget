import 'package:boodget/firebase_options.dart';
import 'package:boodget/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boodget/history_screen.dart';
import 'package:boodget/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boodget',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(
              title: 'Boodget',
            ),
        '/login': (context) => const LoginScreen(
          title: 'Login',
        ),
      },
      // home: const MyHomePage(title: 'Boodget'),
    );
  }
}

// Side drawer of the app
class SideDrawer extends Drawer {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 327,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topRight: Radius.zero, bottomRight: Radius.zero),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      colorFilter:
                          ColorFilter.mode(Colors.black45, BlendMode.darken),
                      image: AssetImage('assets/hiking.jpeg'),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 69 / 2,
                          backgroundImage: AssetImage('assets/beckett.jpg'),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              'Dan McKernan',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 24, right: 24),
                  leading: const Icon(Icons.home),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Color(0xFF656565), fontSize: 14),
                  ),
                  iconColor: const Color(0xFF656565),
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
                // ListTile(
                //   contentPadding: const EdgeInsets.only(left: 24, right: 24),
                //   leading: const Icon(Icons.wallet),
                //   title: const Text(
                //     'Previous Transactions',
                //     style: TextStyle(color: Color(0xFF656565), fontSize: 14),
                //   ),
                //   iconColor: const Color(0xFF656565),
                //   onTap: () {
                //     Navigator.pushNamed(context, '/history');
                //   },
                // ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 24, right: 24),
                  leading: const Icon(Icons.history),
                  title: const Text(
                    'Budget History',
                    style: TextStyle(color: Color(0xFF656565), fontSize: 14),
                  ),
                  iconColor: const Color(0xFF656565),
                  onTap: () {
                    // Navigator.pushNamed(context, '/history');
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 24, right: 24),
                  leading: const Icon(Icons.verified_user_rounded),
                  title: const Text(
                    'Profile',
                    style: TextStyle(color: Color(0xFF656565), fontSize: 14),
                  ),
                  iconColor: const Color(0xFF656565),
                  onTap: () {
                    // Navigator.pushNamed(context, '/test');
                  },
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 24, right: 24),
            leading: const Icon(Icons.info),
            title: const Text(
              'About',
              style: TextStyle(color: Color(0xFF656565), fontSize: 14),
            ),
            iconColor: const Color(0xFF656565),
            onTap: () {},
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 24, right: 24),
            leading: const Icon(Icons.settings),
            title: const Text(
              'Settings',
              style: TextStyle(color: Color(0xFF656565), fontSize: 14),
            ),
            iconColor: const Color(0xFF656565),
            onTap: () {},
          ),
          const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'App Version - V2.0',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 12),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
