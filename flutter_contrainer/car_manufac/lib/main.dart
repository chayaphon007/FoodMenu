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
    futureCarMfr = getCarMfr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Manufacturers"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<CarMfr?>(
        future: futureCarMfr,
        builder: (BuildContext context, AsyncSnapshot<CarMfr?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final results = snapshot.data?.results ?? [];
            if (results.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            // ใช้ ListView กับ Card และ Icon
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.directions_car,
                        color: Colors.deepPurple, size: 36),
                    title: Text(
                      result.mfrName ?? "Unknown Manufacturer",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      "Country: ${result.country ?? "Unknown"}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // เพิ่ม action เมื่อกดรายการ
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(result.mfrName ?? "Details"),
                          content: Text(
                              "This manufacturer is located in ${result.country ?? "Unknown"}"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
