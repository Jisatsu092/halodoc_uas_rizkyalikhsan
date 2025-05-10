import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/firebase_service.dart';
import 'components/sehat_drama_chip.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFFD32F2F),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFFEBEE),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFFD32F2F),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halodoc Clone'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dan komponen lain...
            
            // Sehat Tanpa Drama
            _buildSectionHeader('Sehat Tanpa Drama'),
            _buildFirestoreList(_firebaseService.getSehatTanpaDrama()),
            
            // Produk Andalan
            _buildSectionHeader('Produk Kesehatan Andalan'),
            _buildFirestoreList(_firebaseService.getProdukAndalan(),
              color: const Color(0xFFEF9A9A)),
          ],
        ),
      ),
    );
  }

  Widget _buildFirestoreList(Stream<QuerySnapshot> stream, {Color? color}) {
    return SizedBox(
      height: 50,
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Error');
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return SehatDramaChip(
                text: data['title'],
                imagePath: data['image'] ?? 'assets/placeholder.png',
                backgroundColor: color ?? Theme.of(context).primaryColor,
              );
            },
          );
        },
      ),
    );
  }

BottomNavigationBar _buildBottomNavBar() {
  return BottomNavigationBar( // Hapus keyword const
    items: const [ // Tambahkan const disini
      BottomNavigationBarItem(
        icon: Icon(Icons.home), 
        label: 'Beranda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history), 
        label: 'Riwayat',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person), 
        label: 'Profil',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message), 
        label: 'Pesan',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings), 
        label: 'Pengaturan',
      ),
    ],
  );
}

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD32F2F),
        ),
      ),
    );
  }
}