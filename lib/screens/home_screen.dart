import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/car_model.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Car>?> cars;

  @override
  void initState() {
    super.initState();
    cars = apiService.getCars();
  }

  void _logout() async {
    await apiService.logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Carros"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: FutureBuilder<List<Car>?>(
        future: cars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Error al cargar los carros"));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text("No tienes carros registrados"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Car car = snapshot.data![index];
                return ListTile(
                  title: Text("${car.marca} ${car.modelo}"),
                  subtitle: Text("Año: ${car.año}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
