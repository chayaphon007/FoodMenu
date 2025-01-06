import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Food Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Random Food Menu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _foodMenus = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _fabController;
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _menuList = [
  {"name": "Pizza", "icon": "🍕", "price": 120, "rating": 5, "ingredients": ["Cheese", "Tomato", "Olives", "Pepperoni"]},
  {"name": "Sushi", "icon": "🍣", "price": 250, "rating": 4, "ingredients": ["Rice", "Seaweed", "Fish", "Wasabi"]},
  {"name": "Burger", "icon": "🍔", "price": 80, "rating": 3, "ingredients": ["Bun", "Beef Patty", "Lettuce", "Cheese", "Tomato"]},
  {"name": "Ice Cream", "icon": "🍨", "price": 50, "rating": 5, "ingredients": ["Milk", "Sugar", "Vanilla"]},
  {"name": "Spaghetti", "icon": "🍝", "price": 150, "rating": 4, "ingredients": ["Pasta", "Tomato Sauce", "Garlic", "Cheese"]},
  {"name": "Fried Rice", "icon": "🍛", "price": 70, "rating": 3, "ingredients": ["Rice", "Egg", "Vegetables", "Soy Sauce"]},
  {"name": "Steak", "icon": "🥩", "price": 300, "rating": 5, "ingredients": ["Beef", "Butter", "Garlic", "Herbs"]},
  {"name": "Tacos", "icon": "🌮", "price": 90, "rating": 4, "ingredients": ["Tortilla", "Ground Beef", "Lettuce", "Cheese", "Salsa"]},
  {"name": "Salad", "icon": "🥗", "price": 60, "rating": 4, "ingredients": ["Lettuce", "Tomato", "Cucumber", "Dressing"]},
  {"name": "Doughnut", "icon": "🍩", "price": 40, "rating": 3, "ingredients": ["Flour", "Sugar", "Eggs", "Milk"]},
  {"name": "Ramen", "icon": "🍜", "price": 120, "rating": 4, "ingredients": ["Noodles", "Broth", "Pork", "Egg"]},
  {"name": "Hot Dog", "icon": "🌭", "price": 70, "rating": 3, "ingredients": ["Sausage", "Bun", "Mustard", "Ketchup"]},
  {"name": "Pancakes", "icon": "🥞", "price": 90, "rating": 4, "ingredients": ["Flour", "Milk", "Egg", "Syrup"]},
  {"name": "Kebab", "icon": "🥙", "price": 130, "rating": 5, "ingredients": ["Lamb", "Chicken", "Vegetables", "Sauce"]},
  {"name": "Dim Sum", "icon": "🥟", "price": 110, "rating": 4, "ingredients": ["Pork", "Shrimp", "Dough"]},
  {"name": "Soup", "icon": "🍲", "price": 80, "rating": 3, "ingredients": ["Broth", "Vegetables", "Chicken", "Tofu"]},
  {"name": "French Fries", "icon": "🍟", "price": 50, "rating": 4, "ingredients": ["Potatoes", "Oil", "Salt"]},
  {"name": "Cheese", "icon": "🧀", "price": 200, "rating": 5, "ingredients": ["Milk", "Rennet", "Salt"]},
  {"name": "Cupcake", "icon": "🧁", "price": 60, "rating": 3, "ingredients": ["Flour", "Sugar", "Eggs", "Butter"]},
  {"name": "Chocolate", "icon": "🍫", "price": 100, "rating": 5, "ingredients": ["Cocoa", "Sugar", "Milk"]},
];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _generateRandomMenu(int count) {
    final random = Random();
    int addedCount = 0;

    setState(() {
      while (addedCount < count) {
        final randomMenu = _menuList[random.nextInt(_menuList.length)];
        if (_foodMenus.any((menu) => menu["name"] == randomMenu["name"])) {
          continue; // ถ้ามีเมนูซ้ำแล้ว ข้ามไป
        }
        _foodMenus.add(randomMenu); // เพิ่มเมนูในลิสต์
        _listKey.currentState?.insertItem(_foodMenus.length - 1,
            duration: const Duration(milliseconds: 500)); // เอฟเฟกต์การเพิ่ม
        addedCount++;
      }
    });

    // แสดง SnackBar
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 New food menu added!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
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

  // ฟังก์ชันคำนวณราคาทั้งหมด
  int _getTotalPrice() {
    return _foodMenus.fold(0, (total, menu) {
      // ตรวจสอบและแปลงค่า price เป็น int
      int price = (menu["price"] is int) ? menu["price"] : int.tryParse(menu["price"].toString()) ?? 0;
      return total + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          // แสดงราคารวม
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text('Total: ${_getTotalPrice()} ฿'),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
      body: Center(
        child: _foodMenus.isEmpty
            ? const Center(child: Text("ยังไม่มีเมนู"))
            : AnimatedList(
                key: _listKey,
                controller: _scrollController,
                initialItemCount: _foodMenus.length,
                itemBuilder: (context, index, animation) {
                  final menu = _foodMenus[index];
                  return ScaleTransition(
                    scale: animation.drive(
                      Tween<double>(begin: 0.8, end: 1).chain(
                        CurveTween(curve: Curves.elasticOut),
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
                          backgroundColor: Colors.green,
                          child: Text(
                            menu["icon"]! as String,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        title: Text(
                          menu["name"]! as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                menu["rating"] as int,
                                (starIndex) => const Icon(Icons.star, color: Colors.orange, size: 18),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Ingredients: ${menu['ingredients']!.join(', ')}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${menu["price"]} ฿',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fabController.forward().then((_) => _fabController.reverse());
          _generateRandomMenu(1);
        },
        tooltip: 'Add Random Menu',
        child: AnimatedBuilder(
          animation: _fabController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + _fabController.value * 0.2,
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
