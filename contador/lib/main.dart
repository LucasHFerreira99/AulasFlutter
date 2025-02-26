import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    int count = 0;
    void decrement() {
      setState(() {
        count--;
      });
      print("a contagem é $count");
    }

    void increment() {
      setState(() {
        count++;
      });
      print("a contagem é $count");
    }

    bool get isEmpty => count == 0;
    bool get isFull => count == 20;
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.red,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/lanchonete.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFull ? "Lotado" : 'Pode Entrar',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  '$count',
                  style: TextStyle(fontSize: 100, color: isFull ? Colors.red : Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isEmpty ? Colors.grey : Colors.white,
                      fixedSize: const Size(100, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isEmpty ? null : decrement,
                    child: Text(
                      'Saiu',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 32),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isFull ? Colors.grey : Colors.white,
                      fixedSize: const Size(100, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isFull ? null : increment,
                    child: Text(
                      'Entrou',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

