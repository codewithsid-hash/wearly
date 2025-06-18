// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class ScannerPage extends StatefulWidget {
//   const ScannerPage({super.key});

//   @override
//   State<ScannerPage> createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   File? _imageFile;
//   List<dynamic> _results = [];

//   final String apiUrl = "http://127.0.01:8000/analyze/"; // 👈 Replace with your IP

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//         _results = [];
//       });
//     }
//   }

//   Future<void> _analyzeImage() async {
//     if (_imageFile == null) return;

//     final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//     request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

//     final response = await request.send();
//     final responseBody = await response.stream.bytesToString();

//     if (response.statusCode == 200) {
//       final data = jsonDecode(responseBody);
//       setState(() {
//         _results = data["detections"];
//       });
//     } else {
//       Fluttertoast.showToast(msg: "Failed to analyze image");
//     }
//   }

//   Widget _buildResultBox(Map result) {
//     final color = result['dominant_color'];
//     return Card(
//       child: ListTile(
//         title: Text("${result['label']} (${result['confidence'] * 100}%)"),
//         subtitle: Text("Color: RGB(${color['r']}, ${color['g']}, ${color['b']})"),
//         leading: CircleAvatar(
//           backgroundColor: Color.fromRGBO(color['r'], color['g'], color['b'], 1),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Wearly Scanner")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (_imageFile != null)
//               Image.file(_imageFile!, height: 200),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text("Camera"),
//                   onPressed: () => _pickImage(ImageSource.camera),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.photo),
//                   label: const Text("Gallery"),
//                   onPressed: () => _pickImage(ImageSource.gallery),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _analyzeImage,
//               child: const Text("Analyze Clothing"),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: _results.isEmpty
//                   ? const Text("No results yet")
//                   : ListView(
//                       children: _results.map((r) => _buildResultBox(r)).toList(),
//                     ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wearly/homeScreen.dart';
import 'package:wearly/tag_clothing_screen.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with TickerProviderStateMixin {
  File? _imageFile;
  List<dynamic> _results = [];
  bool _isLoading = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final String apiUrl = "http://192.168.10.171:8000/analyze/";

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _results = [];
      });
      _fadeController.forward();
    }
  }

  Future<void> _analyzeImage() async {
  if (_imageFile == null) return;

  setState(() {
    _isLoading = true;
  });

  try {
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      final List detections = data["detections"];

      if (detections.isNotEmpty) {
        // 🟡 Wait for tagging to complete
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TagClothingPage(detectionResult: detections[0]),
          ),
        );

        // ✅ Check if user finished tagging
        if (result == true) {
          // Re-analyze or continue with _results
          setState(() {
            _results = detections;
          });
          _fadeController.forward();
          _slideController.forward();
        }
      } else {
        _showPremiumToast("No clothing detected.", isError: true);
      }
    } else {
      _showPremiumToast("Analysis failed. Please try again.", isError: true);
    }
  } catch (e) {
    _showPremiumToast("Network error. Check your connection.", isError: true);
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}



  void _showPremiumToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) {
      return Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade100,
              Colors.grey.shade200,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Select an image to analyze',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload from camera or gallery',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.file(
            _imageFile!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isPrimary
              ? LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPrimary ? null : color.withOpacity(0.1),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isPrimary ? Colors.white : color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isPrimary ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _imageFile != null
            ? LinearGradient(
                colors: [
                  Colors.deepPurple.shade600,
                  Colors.deepPurple.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: _imageFile == null ? Colors.grey.shade300 : null,
        boxShadow: _imageFile != null
            ? [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _imageFile != null && !_isLoading ? _analyzeImage : null,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: _imageFile != null ? Colors.white : Colors.grey.shade500,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Analyze Clothing',
                        style: TextStyle(
                          color: _imageFile != null ? Colors.white : Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(Map result, int index) {
    final color = result['dominant_color'];
    final confidence = (result['confidence'] * 100).toStringAsFixed(1);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(color['r'], color['g'], color['b'], 1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(color['r'], color['g'], color['b'], 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.palette,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['label'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Confidence: $confidence%',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'RGB(${color['r']}, ${color['g']}, ${color['b']})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$confidence%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    ),
        ),
        title: const Text(
          'Wearly Scanner',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
       
      ),
    
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePreview(),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onPressed: () => _pickImage(ImageSource.camera),
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onPressed: () => _pickImage(ImageSource.gallery),
                  color: Colors.purple.shade600,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnalyzeButton(),
            const SizedBox(height: 32),
            if (_results.isNotEmpty) ...[
              Text(
                'Analysis Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                _results.length,
                (index) => _buildResultCard(_results[index], index),
              ),
            ] else if (_imageFile != null && !_isLoading) ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ready to analyze',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap "Analyze Clothing" to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
