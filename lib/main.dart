import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/firebase_service.dart';
import 'components/sehat_drama_chip.dart';

void main() async {
  debugDisableShadows = false;
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
        appBarTheme: const AppBarTheme(color: Color(0xFFD32F2F)),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halodoc Clone'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(),
              const SizedBox(height: 20),

              // Quick Access Grid
              _buildQuickAccessGrid(),
              const SizedBox(height: 20),

              // Promo Slider
              _buildSectionHeader('Promo Menarik'),
              _buildPromoSlider(),
              const SizedBox(height: 20),

              // Sehat Tanpa Drama Section
              _buildSectionHeader('Sehat Tanpa Drama'),
              _buildFirestoreList(_firebaseService.getSehatTanpaDrama()),
              const SizedBox(height: 20),

              // Produk Andalan Section
              _buildSectionHeader('Produk Kesehatan Andalan'),
              _buildFirestoreList(
                _firebaseService.getProdukAndalan(),
                color: const Color(0xFFEF9A9A),
              ),
              const SizedBox(height: 20),

              // Artikel Section
              _buildSectionHeader('Baca 100+ Artikel Baru'),
              _buildArtikelList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildQuickAccessGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.8,
      padding: EdgeInsets.zero,
      children: const [
        _GridItem(icon: Icons.chat, label: 'Chat dengan Dokter'),
        _GridItem(icon: Icons.local_pharmacy, label: 'Toko Kesehatan'),
        _GridItem(icon: Icons.home_work, label: 'Homecare'),
        _GridItem(icon: Icons.health_and_safety, label: 'Asuransiku'),
      ],
    );
  }

  Widget _buildPromoSlider() {
    final List<Map<String, String>> promos = [
      {
        'title': 'Solusi Tepat untuk Kulit Sehatmu',
        'price': 'Mulai dari Rp 100.000',
      },
      {'title': 'Vitamin Imunitas Terbaik', 'price': 'Diskon 30% Hari Ini'},
      {'title': 'Konsultasi Dokter Online', 'price': 'Gratis Biaya Admin'},
    ];

    return SizedBox(
      height: 140,
      child: PageView.builder(
        itemCount: promos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/placeholder.svg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    left: 15,
                    bottom: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promos[index]['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          promos[index]['price']!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage('assets/images/placeholder.svg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay gelap
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Konten teks
          Positioned(
            left: 15,
            bottom: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solusi Tepat untuk Kulit Sehatmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mulai dari Rp 100.000',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirestoreList(Stream<QuerySnapshot> stream, {Color? color}) {
    return SizedBox(
      height: 40, // Diperkecil ukurannya
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Error');
          if (!snapshot.hasData)
            return const SizedBox(
              height: 40,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return SehatDramaChip(
                text: data['title'],
                imagePath: data['image'] ?? 'assets/images/placeholder.svg',
                backgroundColor: color ?? Theme.of(context).primaryColor,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildArtikelList() {
  List<String> artikelItems = [
    'Hernia Diafragmatika',
    'Kista Baker',
    'Jenis Penyakit yang Bisa Terdeteksi',
    'Tes Hematologi',
  ];

  return SizedBox(
    height: 160, // Tinggi disesuaikan
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: artikelItems.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 150,
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 90, // Tinggi gambar dikurangi
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/placeholder.svg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 50, // Fixed height untuk text area
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artikelItems[index],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Lihat',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Pesan'),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD32F2F),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Lihat Semua',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFFD32F2F),
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rizky Al Ikhsan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Politeknik...',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            const Text(
              'halocohs Saldo : 0 Koin',
              style: TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _GridItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFD32F2F), size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
