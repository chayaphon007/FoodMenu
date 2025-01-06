import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gen Prime Number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<int> _primeNumbers = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _fabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _generatePrimeNumbers(10); // สร้าง 10 Prime Numbers เริ่มต้น
  }

  void _generatePrimeNumbers(int count) {
  int startNum = _primeNumbers.isEmpty ? 2 : _primeNumbers.last + 1;
  int addedCount = 0;

  while (addedCount < count) {
    if (_isPrime(startNum)) {
      _primeNumbers.add(startNum);
      _listKey.currentState?.insertItem(_primeNumbers.length - 1,
          duration: const Duration(milliseconds: 500)); // เอฟเฟกต์การเพิ่ม
      addedCount++;
    }
    startNum++;
  }

  // เรียก SnackBar หลังจาก Tree สมบูรณ์แล้ว
  Future.delayed(Duration.zero, () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🎉 Prime number added!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  });

  // เลื่อนหน้าจอไปยังรายการสุดท้าย
  Future.delayed(const Duration(milliseconds: 300), () {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  });
}


  bool _isPrime(int number) {
    if (number < 2) return false;
    for (int i = 2; i <= number ~/ 2; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedList(
          key: _listKey,
          controller: _scrollController,
          initialItemCount: _primeNumbers.length,
          itemBuilder: (context, index, animation) {
            return ScaleTransition(
              scale: animation.drive(
                Tween<double>(begin: 0.8, end: 1).chain(
                  CurveTween(curve: Curves.elasticOut), // เอฟเฟกต์ซูมแบบยืดหยุ่น
                ),
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(Icons.numbers, color: Colors.white),
                  ),
                  title: Text(
                    'Item $index',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Prime number is ${_primeNumbers[index]}'),
                  trailing: const Icon(Icons.star, color: Colors.orange),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fabController.forward().then((_) => _fabController.reverse());
          _generatePrimeNumbers(1);
        },
        tooltip: 'Add Prime Number',
        child: AnimatedBuilder(
          animation: _fabController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + _fabController.value * 0.2, // เอฟเฟกต์สั่น
              child: child,
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
