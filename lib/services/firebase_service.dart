import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase/firebase_config.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: FirebaseConfig.config['apiKey']!,
        appId: FirebaseConfig.config['appId']!,
        messagingSenderId: FirebaseConfig.config['messagingSenderId']!,
        projectId: FirebaseConfig.config['projectId']!,
        storageBucket: FirebaseConfig.config['storageBucket']!,
        authDomain: FirebaseConfig.config['authDomain']!,
      ),
    );
  }

  final CollectionReference _sehatDrama = 
    FirebaseFirestore.instance.collection('sehat_tanpa_drama');
    
  final CollectionReference _produkAndalan = 
    FirebaseFirestore.instance.collection('produk_andalan');

  Stream<QuerySnapshot> getSehatTanpaDrama() => _sehatDrama.snapshots();
  Stream<QuerySnapshot> getProdukAndalan() => _produkAndalan.snapshots();
}