
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wearly/homeScreen.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  File? _imageFile;
  bool _isLoading = false;

  String? _clothingType;
  String? _gender;
  String? _occasion;
  String? _season;

  final List<String> clothingTypes = ['T-Shirt', 'Shirt', 'Pants', 'Jacket'];
  final List<String> genders = ['Male', 'Female'];
  final List<String> occasions = ['Formal', 'Casual', 'Party'];
  final List<String> seasons = ['Summer', 'Winter', 'Spring', 'Autumn'];

  final String apiUrl = "http://192.168.31.75:8045/recommend-from-upload/";

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;

    if (_clothingType == null || _gender == null || _occasion == null || _season == null) {
      _showToast("Fill all tag fields first", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
      request.fields['input_clothing_type'] = _clothingType!;
      request.fields['gender'] = _gender!;
      request.fields['occasion'] = _occasion!;
      request.fields['season'] = _season!;

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _showToast("Analysis complete");
        // handle response logic here
      } else {
        _showToast("Analysis failed", isError: true);
      }
    } catch (e) {
      _showToast("Connection error", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showToast(String msg, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: isError ? Colors.redAccent : Colors.tealAccent.shade700,
      textColor: Colors.black,
      gravity: ToastGravity.TOP,
      fontSize: 14,
    );
  }

  Widget _buildImageContainer() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: _imageFile == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 60, color: Colors.grey.shade600),
                  const SizedBox(height: 10),
                  Text("No Image Selected", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(_imageFile!, fit: BoxFit.cover),
            ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool loading = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: color != null ? [color, color.withOpacity(0.8)] : [Colors.teal, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Center(
            child: loading
                ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _darkDropdown(String hint, List<String> options, String? value, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      hint: Text(hint, style: const TextStyle(color: Colors.white60)),
      value: value,
      onChanged: onChanged,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );

},
        ),
        title: const Text(
          "SCNR",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildImageContainer(),
            const SizedBox(height: 20),

            if (_imageFile != null) ...[
              _darkDropdown("Clothing Type", clothingTypes, _clothingType, (v) => setState(() => _clothingType = v)),
              const SizedBox(height: 12),
              _darkDropdown("Gender", genders, _gender, (v) => setState(() => _gender = v)),
              const SizedBox(height: 12),
              _darkDropdown("Occasion", occasions, _occasion, (v) => setState(() => _occasion = v)),
              const SizedBox(height: 12),
              _darkDropdown("Season", seasons, _season, (v) => setState(() => _season = v)),
              const SizedBox(height: 20),
            ],

            Row(
              children: [
                _buildButton(
                  label: 'Camera',
                  icon: Icons.camera_alt,
                  onPressed: () => _pickImage(ImageSource.camera),
                  color: Colors.tealAccent,
                ),
                const SizedBox(width: 12),
                _buildButton(
                  label: 'Gallery',
                  icon: Icons.photo_library_outlined,
                  onPressed: () => _pickImage(ImageSource.gallery),
                  color: Colors.cyanAccent,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildButton(
                  label: 'Match',
                  icon: Icons.analytics_outlined,
                  onPressed: _imageFile != null && !_isLoading ? _analyzeImage : () {},
                  loading: _isLoading,
                ),
                const SizedBox(width: 12),
                _buildButton(
                  label: 'Closet+',
                  icon: Icons.save_alt,
                  onPressed: _imageFile != null ? () => _showToast("Saved to collection") : () {},
                  color: Colors.amberAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

