import 'package:car_manufac/car_mfr.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarManufac extends StatefulWidget {
  const CarManufac({super.key});

  @override
  State<CarManufac> createState() => _CarManufacState();
}

class _CarManufacState extends State<CarManufac> {
  late Future<CarMfr?> futureCarMfr;

  // ฟังก์ชันดึงข้อมูลจาก API
  Future<CarMfr?> getCarMfr() async {
    const url = "vpic.nhtsa.dot.gov";
    final uri =
        Uri.https(url, "/api/vehicles/getallmanufacturers", {"format": "json"});

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return carMfrFromJson(response.body);
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลเพียงครั้งเดียว
    futureCarMfr = getCarMfr();
    print("Initiated....");
  }

  @override
  Widget build(BuildContext context) {
    print("Building....");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Manufacturers"),
      ),
      body: FutureBuilder<CarMfr?>(
        future: futureCarMfr, // ใช้ Future ที่สร้างใน initState
        builder: (BuildContext context, AsyncSnapshot<CarMfr?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // แสดงโหลด
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}")); // แสดงข้อความผิดพลาด
          } else if (snapshot.hasData) {
            final results = snapshot.data?.results ?? [];
            if (results.isEmpty) {
              return const Center(child: Text("No data available"));
            }
            // แสดงข้อมูลใน ListView
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text(result.mfrName ?? "Unknown Manufacturer"),
                  subtitle: Text(result.country ?? "Unknown Country"),
                );
              },
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
