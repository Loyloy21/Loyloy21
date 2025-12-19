import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:developer' as devtools;
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:share_plus/share_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Uncomment after running 'flutterfire configure':
// import 'firebase_options.dart';

// Theme Constants - Consistent Colors & Styles
class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color accentColor = Color(0xFFA855F7);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFA855F7),
  ];
  
  static const List<Color> lightGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];
  
  // Background Colors
  static const Color backgroundColor = Colors.white;
  static Color lightBackground = const Color(0xFF6366F1).withOpacity(0.1);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textWhite = Colors.white;
  
  // Border Radius
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 18.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusXLarge = 25.0;
  static const double borderRadiusButton = 35.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 32.0;
  
  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 5),
    ),
  ];
  
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  // Gradient Decoration
  static BoxDecoration primaryGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: lightGradient,
    ),
  );
  
  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(borderRadiusLarge),
    boxShadow: cardShadow,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // After running 'flutterfire configure', replace with:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car part Identifying',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primaryColor,
          brightness: Brightness.light,
          primary: AppTheme.primaryColor,
          secondary: AppTheme.secondaryColor,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // List of car part images from assets
  final List<Map<String, String>> carParts = const [
    {'image': 'assets/steering wheel.jpg', 'name': 'Steering Wheel'},
    {'image': 'assets/car dashboard.jpg', 'name': 'Car Dashboard'},
    {'image': 'assets/speedometer.jpg', 'name': 'Speedometer'},
    {'image': 'assets/car seat.jpg', 'name': 'Car Seat'},
    {'image': 'assets/gear shift.jpg', 'name': 'Gear Shift'},
    {'image': 'assets/car key.jpg', 'name': 'Car Key'},
    {'image': 'assets/air vent.jpg', 'name': 'Air Vent'},
    {'image': 'assets/seatbelt.jpg', 'name': 'Seatbelt'},
    {'image': 'assets/touchscreen display.jpg', 'name': 'Touchscreen Display'},
    {'image': 'assets/reareview mirror.jpg', 'name': 'Rearview Mirror'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/background.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.primaryGradient.map((c) => c.withOpacity(0.7)).toList(),
          ),
        ),
        child: SafeArea(
              child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Column(
                children: [
                  // App Icon/Logo
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.9),
                                  ],
                                ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                    spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.build_circle,
                                size: 70,
                                color: AppTheme.primaryColor,
                    ),
                            ),
                          );
                        },
                  ),
                      const SizedBox(height: 24),
                  // App Title
                  const Text(
                        'Car Part Identifier',
                        textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                          fontWeight: FontWeight.w900,
                      color: Colors.white,
                          letterSpacing: 1.0,
                    ),
                  ),
                      const SizedBox(height: 12),
                  // Description
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Identify car parts instantly using AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    ),
                  ),
                
                // Scanner Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusButton),
                      boxShadow: AppTheme.buttonShadow,
                    ),
                    child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScannerPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                          vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusButton),
                      ),
                        elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          Icon(Icons.qr_code_scanner_rounded, size: 26),
                          SizedBox(width: 12),
                        Text(
                            'Start Scanning',
                          style: TextStyle(
                              fontSize: 20,
                            fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                          ),
                        ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward_rounded, size: 24),
                      ],
                    ),
                  ),
                  ),
                ),

                // Car Parts Gallery Section
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.grid_view_rounded,
                                color: Colors.white.withOpacity(0.9),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Car Parts Gallery',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.95),
                                  letterSpacing: 0.5,
                      ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                      ),
                            itemCount: carParts.length,
                            itemBuilder: (context, index) {
                              final part = carParts[index];
                              return _CarPartCard(
                                imagePath: part['image']!,
                                name: part['name']!,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Car Part Card Widget
class _CarPartCard extends StatelessWidget {
  final String imagePath;
  final String name;

  const _CarPartCard({
    required this.imagePath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Label
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// Database Helper Class
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scan_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = path_package.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT NOT NULL,
        confidence REAL NOT NULL,
        image_path TEXT NOT NULL,
        date_time TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertScan(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('scan_history', row);
  }

  Future<List<Map<String, dynamic>>> getAllScans() async {
    final db = await instance.database;
    return await db.query('scan_history', orderBy: 'id DESC');
  }

  Future<int> deleteScan(int id) async {
    final db = await instance.database;
    return await db.delete('scan_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllScans() async {
    final db = await instance.database;
    return await db.delete('scan_history');
  }

  // Get statistics for charts
  Future<Map<String, int>> getLabelCounts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT label, COUNT(*) as count 
      FROM scan_history 
      GROUP BY label 
      ORDER BY count DESC
    ''');
    
    Map<String, int> labelCounts = {};
    for (var row in results) {
      labelCounts[row['label']] = row['count'] as int;
    }
    return labelCounts;
  }

  Future<Map<String, double>> getAverageConfidence() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT label, AVG(confidence) as avg_confidence 
      FROM scan_history 
      GROUP BY label 
      ORDER BY avg_confidence DESC
    ''');
    
    Map<String, double> avgConfidence = {};
    for (var row in results) {
      avgConfidence[row['label']] = row['avg_confidence'] as double;
    }
    return avgConfidence;
  }
}

// Scanner Page (Main scanning functionality)
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  File? filePath;
  String label = "";
  double confidence = 0.0;
  bool _isProcessing = false;
  List<Map<String, dynamic>> _allPredictions = [];
  int _currentIndex = 0;

  Future<void> _tfiteInit() async {
    try {
      await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    } catch (e) {
      devtools.log("Error loading model: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading AI model. Please restart the app.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveToHistory() async {
    if (filePath != null && label.isNotEmpty) {
      final timestamp = DateTime.now();
      
      // Save to local SQLite database
      await DatabaseHelper.instance.insertScan({
        'label': label,
        'confidence': confidence,
        'image_path': filePath!.path,
        'date_time': timestamp.toIso8601String(),
      });

      // Save to Firestore (Cloud)
      try {
        final firestore = FirebaseFirestore.instance;
        await firestore.collection('Consistente_VehicleParts').add({
          'Accuracy_rate': confidence,
          'Class_type': label,
          'Time': Timestamp.fromDate(timestamp),
        });
        devtools.log('✅ Scan saved to Firestore successfully');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Saved to cloud successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        devtools.log('❌ Error saving to Firestore: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚠️ Cloud save failed: ${e.toString()}'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
      _isProcessing = true;
      label = "";
      confidence = 0.0;
      _allPredictions = [];
    });

    try {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
        numResults: 10, // Get top 10 predictions
        threshold: 0.0, // show all predictions so user sees every percent
      asynch: true,
    );

      if (recognitions == null || recognitions.isEmpty) {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not identify the tool. Please try another image.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      return;
    }

    devtools.log(recognitions.toString());

      // Process all predictions
      final List<Map<String, dynamic>> predictions = [];
      for (var recognition in recognitions) {
        final rawConfidence = recognition['confidence'] as double;
        final calculatedConfidence = rawConfidence * 100;
        predictions.add({
          'label': recognition['label'].toString(),
          'confidence': calculatedConfidence,
        });
      }

      // Get top prediction
      final topPrediction = predictions[0];
      final rawConfidence = recognitions[0]['confidence'] as double;
      final calculatedConfidence = rawConfidence * 100;

    setState(() {
        _allPredictions = predictions;
        confidence = calculatedConfidence;
        label = topPrediction['label'].toString();
        _isProcessing = false;
    });

    // Save to history
    await _saveToHistory();
    } catch (e) {
      devtools.log("Error during recognition: $e");
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
      _isProcessing = true;
      label = "";
      confidence = 0.0;
      _allPredictions = [];
    });

    try {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
        numResults: 10, // Get top 10 predictions
        threshold: 0.0, // show all predictions so user sees every percent
      asynch: true,
    );

      if (recognitions == null || recognitions.isEmpty) {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not identify the tool. Please try another image.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      return;
    }

    devtools.log(recognitions.toString());

      // Process all predictions
      final List<Map<String, dynamic>> predictions = [];
      for (var recognition in recognitions) {
        final rawConfidence = recognition['confidence'] as double;
        final calculatedConfidence = rawConfidence * 100;
        predictions.add({
          'label': recognition['label'].toString(),
          'confidence': calculatedConfidence,
        });
      }

      // Get top prediction
      final topPrediction = predictions[0];
      final rawConfidence = recognitions[0]['confidence'] as double;
      final calculatedConfidence = rawConfidence * 100;

    setState(() {
        _allPredictions = predictions;
        confidence = calculatedConfidence;
        label = topPrediction['label'].toString();
        _isProcessing = false;
    });

    // Save to history
    await _saveToHistory();
    } catch (e) {
      devtools.log("Error during recognition: $e");
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    );
  }

  void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StatisticsPage()),
    );
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    if (index == 1) {
      // History tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryPage()),
      ).then((_) {
        // Reset to home when coming back
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 2) {
      // Statistics tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatisticsPage()),
      ).then((_) {
        // Reset to home when coming back
        setState(() {
          _currentIndex = 0;
        });
      });
    }
    // index == 0 is Home, which is already the current page
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    _tfiteInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Home',
        ),
        title: const Text(
          "Car Part Scanner",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.95),
                AppTheme.secondaryColor.withOpacity(0.95),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.bar_chart_rounded, size: 22),
            onPressed: _navigateToStatistics,
            tooltip: 'View Statistics',
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
          ),
            child: IconButton(
              icon: const Icon(Icons.history_rounded, size: 22),
            onPressed: _navigateToHistory,
            tooltip: 'View History',
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/scanning_background.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
                      const SizedBox(height: 20),
                      // Image Card with glassmorphism
              Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, Colors.grey.shade50],
                              ),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                                // Image Container
                        Container(
                                  height: 320,
                                  width: double.infinity,
                          decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                            ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                          child: filePath == null
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.asset(
                                                'assets/upload.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                ),
                          child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                                    Icon(
                                                      Icons.add_photo_alternate_rounded,
                                                      size: 60,
                                                      color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(height: 12),
                              Text(
                                                      'Upload an image',
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.9),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.file(
                                                filePath!,
                                                fit: BoxFit.cover,
                                              ),
                                              if (_isProcessing)
                                                Container(
                                                  color: Colors.black.withOpacity(
                                                    0.5,
                                                  ),
                                                  child: const Center(
                          child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                                        CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                        ),
                                                        SizedBox(height: 16),
                              Text(
                                                          'Identifying tool...',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                                if (label.isNotEmpty && _allPredictions.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  // Top Prediction Class (orange card)
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.orange.shade400,
                                          Colors.orange.shade600,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.25),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(18),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _allPredictions.isNotEmpty 
                                                    ? _allPredictions[0]['label'].toString()
                                                    : label,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _allPredictions.isNotEmpty
                                                    ? "${(_allPredictions[0]['confidence'] as double).toStringAsFixed(2)}%"
                                                    : "${confidence.toStringAsFixed(2)}%",
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Prediction Breakdown Card
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.yellow.shade300,
                                          Colors.yellow.shade400,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.25),
                                          blurRadius: 20,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.bar_chart_rounded,
                                              color: Colors.pink.shade400,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                'Prediction Breakdown',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        ..._allPredictions.asMap().entries.map((entry) {
                                          final idx = entry.key;
                                          final pred = entry.value;
                                          final predConf = (pred['confidence'] as double).clamp(0, 100);
                                          final labelText = pred['label'].toString();
                                          final isTopPrediction = idx == 0;
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: idx < _allPredictions.length - 1 ? 16 : 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        labelText.toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: isTopPrediction 
                                                              ? Colors.blue.shade700
                                                              : Colors.pink.shade400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${predConf.toStringAsFixed(2)}%",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: isTopPrediction 
                                                            ? Colors.blue.shade700
                                                            : Colors.pink.shade400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(4),
                                                  child: LinearProgressIndicator(
                                                    value: predConf / 100,
                                                    minHeight: 10,
                                                    backgroundColor: Colors.grey.shade200,
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      isTopPrediction
                                                          ? Colors.blue.shade400
                                                          : Colors.pink.shade300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 32),
                                // Action Buttons
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 350),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        // Camera Button
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF6366F1).withOpacity(0.3),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton.icon(
                onPressed: () {
                  pickImageCamera();
                },
                                            icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              size: 24,
                                            ),
                                            label: const Text(
                                              "Take a Photo",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF6366F1),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 18,
                                              ),
                  shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                                              elevation: 0,
                ),
                                          ),
              ),
                                        const SizedBox(height: 16),
                                        // Gallery Button
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(
                                              color: AppTheme.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          child: ElevatedButton.icon(
                onPressed: () {
                  pickImageGallery();
                },
                                            icon: const Icon(
                                              Icons.photo_library_rounded,
                                              size: 24,
                                            ),
                                            label: const Text(
                                              "Pick From Gallery",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: AppTheme.primaryColor,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 18,
                                              ),
                  shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                                              elevation: 0,
                ),
                                          ),
              ),
            ],
          ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.95),
              AppTheme.secondaryColor.withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedFontSize: 14,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }
}

// Statistics Page
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, int> _labelCounts = {};
  Map<String, double> _avgConfidence = {};
  List<String> _labels = [];
  List<int> _counts = [];
  double _maxY = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    // Load labels from assets in the expected order (one per line)
    final labelsRaw = await rootBundle.loadString('assets/labels.txt');
    final lines = labelsRaw
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    // Each line may have a leading index like "0 Steering wheel" - strip the numeric prefix
    final parsedLabels = lines.map((l) {
      final parts = l.trim().split(RegExp(r'\s+'));
      if (parts.isEmpty) return l.trim();
      // If first token is numeric, drop it
      final first = parts.first;
      if (int.tryParse(first) != null && parts.length > 1) {
        return parts.sublist(1).join(' ');
      }
      return l.trim();
    }).toList();

    final countsMap = await DatabaseHelper.instance.getLabelCounts();
    final avgConf = await DatabaseHelper.instance.getAverageConfidence();

    // Build ordered counts aligned with _labels
    final countsList = <int>[];
    double maxY = 1;
    for (var label in parsedLabels) {
      int cnt = 0;
      if (countsMap.containsKey(label)) {
        cnt = countsMap[label]!;
      } else {
        // try to find a key that contains the label text (handles labels with numeric prefixes)
        final matchKey = countsMap.keys.firstWhere(
          (k) => k.toString().toLowerCase().contains(label.toLowerCase()),
          orElse: () => '',
        );
        if (matchKey.isNotEmpty) cnt = countsMap[matchKey]!;
      }
      countsList.add(cnt);
      if (cnt > maxY) maxY = cnt.toDouble();
    }
    
    setState(() {
      _labels = parsedLabels;
      _counts = countsList;
      _labelCounts = countsMap;
      _avgConfidence = avgConf;
      _maxY = maxY < 1 ? 1 : maxY;
      _isLoading = false;
    });
  }

  List<Color> _generateColors(int count) {
    return List.generate(count, (index) {
      final hue = (index * 360 / count) % 360;
      return HSVColor.fromAHSV(1.0, hue, 0.7, 0.9).toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Statistics',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
      ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.lightGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 22),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _loadStatistics();
              },
              tooltip: 'Refresh Statistics',
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF6366F1).withOpacity(0.1), Colors.white],
          ),
        ),
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _labelCounts.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                    'No data available yet.\nStart scanning tools!',
                    textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  ),
                )
            : RefreshIndicator(
                onRefresh: _loadStatistics,
                color: AppTheme.primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Statistics Header Cards
                      Row(
                            children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: AppTheme.lightGradient,
                                ),
                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.qr_code_scanner_rounded,
                                      size: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '${_labelCounts.values.reduce((a, b) => a + b)}',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Total Scans',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [AppTheme.secondaryColor, AppTheme.accentColor],
                                ),
                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.category_rounded,
                                      size: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '${_labelCounts.length}',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Tool Types',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    // Average Accuracy Card
                    if (_avgConfidence.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.orange.shade400,
                              Colors.orange.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.trending_up_rounded,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Average Accuracy',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${(_avgConfidence.values.reduce((a, b) => a + b) / _avgConfidence.length).toStringAsFixed(2)}%",
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Chart visualization of all accuracies
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.bar_chart_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Accuracy Chart:',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ...(_avgConfidence.entries.toList().asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final mapEntry = entry.value;
                                    final acc = mapEntry.value;
                                    final is100 = acc >= 99.9;
                                    final label = mapEntry.key;
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: index < _avgConfidence.length - 1 ? 12 : 0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    if (is100)
                                                      const Icon(
                                                        Icons.check_circle_rounded,
                                                        color: Colors.green,
                                                        size: 16,
                                                      )
                                                    else
                                                      Icon(
                                                        Icons.circle,
                                                        color: Colors.white.withOpacity(0.6),
                                                        size: 16,
                                                      ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        label.length > 20 ? '${label.substring(0, 20)}...' : label,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "${acc.toStringAsFixed(2)}%",
                                                style: TextStyle(
                                                  fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                                  color: is100 ? Colors.green.shade200 : Colors.white,
                                    ),
                                              ),
                                            ],
                                  ),
                                          const SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: acc / 100,
                                              minHeight: 8,
                                              backgroundColor: Colors.white.withOpacity(0.2),
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                is100
                                                    ? Colors.green.shade300
                                                    : acc >= 70
                                                        ? Colors.blue.shade300
                                                        : acc >= 40
                                                            ? Colors.orange.shade300
                                                            : Colors.red.shade300,
                                              ),
                                            ),
                                          ),
                                ],
                              ),
                                    );
                                  }).toList()),
                            ],
                          ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ] else
                      const SizedBox(height: 32),
                      
                    // Line Chart - Cumulative counts per class (one line across classes)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.show_chart_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    'Scans by Class (cumulative)',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                      SizedBox(
                              height: 320,
                              child: _labels.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No labels loaded',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    )
                                  : LineChart(
                                      LineChartData(
                                        minX: 0,
                                        maxX: (_labels.length - 1).toDouble(),
                                        minY: 0,
                                        maxY: _maxY < 1 ? 1 : _maxY,
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: true,
                                          getDrawingHorizontalLine: (value) =>
                                              FlLine(
                                                color: Colors.grey.shade200,
                                                strokeWidth: 1,
                                              ),
                                        ),
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  '${value.toInt()}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 100,
                                              getTitlesWidget: (value, meta) {
                                                final idx = value.toInt();
                                                if (idx >= 0 &&
                                                    idx < _labels.length) {
                                                  final labelText =
                                                      _labels[idx];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8,
                                                        ),
                                                    child: SizedBox(
                                                      width: 80,
                                                      child: Transform.rotate(
                                                        angle:
                                                            -math.pi /
                                                            6, // rotate -30 degrees
                                                        child: Text(
                                                          labelText.length > 12 
                                                              ? '${labelText.substring(0, 12)}...'
                                                              : labelText,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey
                                                                .shade700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return const Text('');
                                              },
                                            ),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: List.generate(
                                              _counts.length,
                                              (i) => FlSpot(
                                                i.toDouble(),
                                                _counts[i].toDouble(),
                                              ),
                                            ),
                                            isCurved: false,
                                            color: AppTheme.primaryColor,
                                            barWidth: 3,
                                            dotData: FlDotData(show: true),
                                            belowBarData: BarAreaData(
                                              show: false,
                                            ),
                                          ),
                                        ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLegend(),
                          ],
                        ),
                      ),
                    ),
                      
                      const SizedBox(height: 32),
                      
                      // Bar Chart - Average Confidence
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.bar_chart_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                      const Text(
                        'Average Accuracy by Tool',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                        ),
                      ),
                              ],
                            ),
                            const SizedBox(height: 24),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barGroups: _buildBarGroups(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}%',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade600,
                                            ),
                                          );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                          if (value.toInt() <
                                              _avgConfidence.length) {
                                            final label = _avgConfidence.keys
                                                .toList()[value.toInt()];
                                      return Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                        child: Text(
                                                label.length > 10
                                                    ? '${label.substring(0, 10)}...'
                                                    : label,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade700,
                                                ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.shade200,
                                        strokeWidth: 1,
                                      );
                                    },
                            ),
                            borderData: FlBorderData(show: false),
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
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.95),
              AppTheme.secondaryColor.withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 2, // Statistics is selected
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ScannerPage()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedFontSize: 14,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Statistics',
            ),
          ],
        ),
        ),
      );
  }

  // Pie chart removed; using line chart for scan counts per class.

  Widget _buildLegend() {
    if (_labels.isEmpty) return const SizedBox.shrink();
    final colors = _generateColors(_labels.length);
    
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: List.generate(_labels.length, (index) {
        final label = _labels[index];
        final count = index < _counts.length ? _counts[index] : 0;
        final color = colors[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25), width: 1),
          ),
          child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
              Text(
                '$label ($count)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
          ],
          ),
        );
      }),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final colors = _generateColors(_avgConfidence.length);
    
    return _avgConfidence.entries.map((entry) {
      final index = _avgConfidence.keys.toList().indexOf(entry.key);
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: colors[index],
            width: 24,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            backDrawRodData: BackgroundBarChartRodData(show: true, toY: 100),
          ),
        ],
      );
    }).toList();
  }
}

// History Page
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> _filteredHistory = [];
  String _searchQuery = '';
  String _sortBy = 'date'; // 'date', 'confidence', 'label'
  bool _sortAscending = false; // false = descending, true = ascending
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _searchController.addListener(_filterHistory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final data = await DatabaseHelper.instance.getAllScans();
    setState(() {
      _history = data;
    });
    _applySortAndFilter();
  }

  void _filterHistory() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applySortAndFilter();
    });
  }

  void _applySortAndFilter() {
    var filtered = List<Map<String, dynamic>>.from(_history);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        final label = item['label'].toString().toLowerCase();
        final confidence = item['confidence'].toString();
        return label.contains(_searchQuery) || confidence.contains(_searchQuery);
      }).toList();
    }

    // Apply sort
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'date':
          final dateA = DateTime.parse(a['date_time']);
          final dateB = DateTime.parse(b['date_time']);
          comparison = dateA.compareTo(dateB);
          break;
        case 'confidence':
          comparison = (a['confidence'] as double).compareTo(b['confidence'] as double);
          break;
        case 'label':
          comparison = a['label'].toString().compareTo(b['label'].toString());
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    setState(() {
      _filteredHistory = filtered;
    });
  }

  void _changeSort(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = false;
      }
      _applySortAndFilter();
    });
  }

  Future<void> _deleteItem(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.red.shade600,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this scan from history?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
    await DatabaseHelper.instance.deleteScan(id);
    _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.orange.shade700,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Clear All History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete all scan history? This action cannot be undone.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete All',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteAllScans();
      _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All history cleared successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showZoomableImage(BuildContext context, String? imagePath) {
    if (imagePath == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Image Preview',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Image not found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageDetails(BuildContext context, Map<String, dynamic> item) {
    final dateTime = DateTime.parse(item['date_time']);
    final formattedDate = DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                child: item['image_path'] != null && item['image_path'] is String
                    ? Image.file(
                        File(item['image_path'] as String),
                        fit: BoxFit.contain,
                        height: 300,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 300,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              // Label
              Text(
                item['label'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Accuracy Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
              colors: AppTheme.lightGradient,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Accuracy: ${((item['confidence'] as num?) ?? 0.0).toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Date
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final imagePath = item['image_path'] as String?;
                        if (imagePath != null) {
                          final imageFile = File(imagePath);
                          if (await imageFile.exists()) {
                            await Share.shareXFiles(
                              [XFile(imagePath)],
                              text: 'Tool Identifier Result:\n${item['label']}\nAccuracy: ${((item['confidence'] as num?) ?? 0.0).toStringAsFixed(2)}%\nDate: $formattedDate',
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error sharing: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Scan History',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.lightGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Sort Button
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded, color: Colors.white, size: 22),
              tooltip: 'Sort',
              color: Colors.white,
              onSelected: (value) {
                if (value == 'date' || value == 'confidence' || value == 'label') {
                  _changeSort(value);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'date',
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 20,
                        color: _sortBy == 'date' ? const Color(0xFF6366F1) : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      const Text('Sort by Date'),
                      if (_sortBy == 'date')
                        Icon(
                          _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'confidence',
                  child: Row(
                    children: [
                      Icon(
                        Icons.percent_rounded,
                        size: 20,
                        color: _sortBy == 'confidence' ? const Color(0xFF6366F1) : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      const Text('Sort by Accuracy'),
                      if (_sortBy == 'confidence')
                        Icon(
                          _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'label',
                  child: Row(
                    children: [
                      Icon(
                        Icons.text_fields_rounded,
                        size: 20,
                        color: _sortBy == 'label' ? const Color(0xFF6366F1) : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      const Text('Sort by Label'),
                      if (_sortBy == 'label')
                        Icon(
                          _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Clear All Button
          if (_history.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, size: 22),
              onPressed: _clearAll,
              tooltip: 'Clear All',
                color: Colors.white,
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF6366F1).withOpacity(0.1), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by label or accuracy...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF6366F1),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            // Results count
            if (_searchQuery.isNotEmpty || _filteredHistory.length != _history.length)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Showing ${_filteredHistory.length} of ${_history.length} items',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            // History List
            Expanded(
              child: _filteredHistory.isEmpty && _history.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try different search terms',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _filteredHistory.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                'No scan history yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
              ),
            )
            : RefreshIndicator(
                onRefresh: _loadHistory,
                color: AppTheme.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredHistory.length,
              itemBuilder: (context, index) {
                    final item = _filteredHistory[index];
                final dateTime = DateTime.parse(item['date_time']);
                  final formattedDate = DateFormat(
                    'MMM dd, yyyy hh:mm a',
                  ).format(dateTime);

                return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          // Show image in full screen or details
                          _showImageDetails(context, item);
                        },
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                  child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          isThreeLine: false,
                    leading: item['image_path'] != null && item['image_path'] is String
                              ? Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(item['image_path'] as String),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                          color: Colors.grey.shade200,
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            color: Colors.grey.shade400,
                                          ),
                                );
                              },
                                    ),
                            ),
                          )
                        : null,
                    title: Text(
                      item['label'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              letterSpacing: 0.3,
                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified_rounded,
                                        size: 14,
                                        color: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          'Accuracy: ${((item['confidence'] as num?) ?? 0.0).toStringAsFixed(2)}%',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                      ],
                    ),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _showImageDetails(context, item),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.visibility_rounded,
                                      color: AppTheme.primaryColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _deleteItem(item['id']),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red.shade600,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                );
              },
            ),
              ),
            ),
          ],
        ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.95),
              AppTheme.secondaryColor.withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 1, // History is selected
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ScannerPage()),
    );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StatisticsPage()),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedFontSize: 14,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }
}
