import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadLookScreen extends StatefulWidget {
  @override
  _UploadLookScreenState createState() => _UploadLookScreenState();
}

class _UploadLookScreenState extends State<UploadLookScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  static const String API_BASE_URL = 'http://192.168.10.171:8045';
  static const String UPLOAD_ENDPOINT = '/upload-clothing/';

  String? _selectedClothingType;
  String? _selectedGender;
  String? _selectedOccasion;
  String? _selectedSeason;

  final List<String> _clothingTypes = ['shirt', 'pants', 't-shirt', 'shoe'];
  final List<String> _genders = ['male', 'female', 'unisex'];
  final List<String> _occasions = ['casual', 'formal', 'party', 'work'];
  final List<String> _seasons = ['summer', 'winter', 'monsoon', 'autumn/spring'];

  bool _isUploading = false;

  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image. Please try again.');
    }
  }

  Future<void> _uploadLookToAPI() async {
    if (_selectedImage == null) throw Exception('No image selected');
    if (_selectedClothingType == null ||
        _selectedGender == null ||
        _selectedOccasion == null ||
        _selectedSeason == null) {
      throw Exception('Please select all fields');
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$API_BASE_URL$UPLOAD_ENDPOINT'),
      );

      var imageStream = http.ByteStream(_selectedImage!.openRead());
      var imageLength = await _selectedImage!.length();
      var multipartFile = http.MultipartFile(
        'file',
        imageStream,
        imageLength,
        filename: 'clothing_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(multipartFile);

      request.fields['clothing_type'] = _selectedClothingType!;
      request.fields['gender'] = _selectedGender!;
      request.fields['occasion'] = _selectedOccasion!;
      request.fields['season'] = _selectedSeason!;

      request.headers.addAll({'Accept': 'application/json'});

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('Upload successful: $responseData');
        return;
      } else {
        var errorMessage = 'Upload failed';
        try {
          var errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorData['error'] ?? 'Upload failed';
        } catch (e) {
          errorMessage = 'Upload failed with status code: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Upload error: $e');
      rethrow;
    }
  }

  Future<void> _submitLook() async {
    if (_selectedImage == null) {
      _showErrorSnackBar('Please select an image first');
      return;
    }

    if (_selectedClothingType == null ||
        _selectedGender == null ||
        _selectedOccasion == null ||
        _selectedSeason == null) {
      _showErrorSnackBar('Please select all fields');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await _uploadLookToAPI();
      HapticFeedback.heavyImpact();
      _showSuccessSnackBar('Look uploaded successfully!');
      setState(() {
        _isUploading = false;
        _selectedImage = null;
        _selectedClothingType = null;
        _selectedGender = null;
        _selectedOccasion = null;
        _selectedSeason = null;
      });
    } catch (e) {
      String errorMessage = 'Upload failed. Please try again.';
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Upload timed out. Please try again.';
      } else if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceFirst('Exception:', '').trim();
      }
      _showErrorSnackBar(errorMessage);
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.grey[900],
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            style: TextStyle(color: Colors.white),
            items: options
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown('Clothing Type', _clothingTypes, _selectedClothingType, (val) => setState(() => _selectedClothingType = val)),
        SizedBox(height: 10),
        _buildDropdown('Gender', _genders, _selectedGender, (val) => setState(() => _selectedGender = val)),
        SizedBox(height: 10),
        _buildDropdown('Occasion', _occasions, _selectedOccasion, (val) => setState(() => _selectedOccasion = val)),
        SizedBox(height: 10),
        _buildDropdown('Season', _seasons, _selectedSeason, (val) => setState(() => _selectedSeason = val)),
      ],
    );
  }

  Widget _buildFloatingIcon(String icon, double x, double y, double delay) {
    return Positioned(
      left: MediaQuery.of(context).size.width * x,
      top: MediaQuery.of(context).size.height * y,
      child: Transform.translate(
        offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi + delay * 2 * math.pi) * 8),
        child: Opacity(
          opacity: 0.2,
          child: Text(icon, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Upload Look'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0a0a0a), Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f0f23)],
                    stops: [0.0, 0.3, 0.7, 1.0],
                    transform: GradientRotation(_floatingController.value * 0.05),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Stack(
                children: [
                  _buildFloatingIcon('🌸', 0.1, 0.2, 0.0),
                  _buildFloatingIcon('☀️', 0.8, 0.15, 0.3),
                  _buildFloatingIcon('🍂', 0.2, 0.7, 0.6),
                  _buildFloatingIcon('❄️', 0.85, 0.8, 0.9),
                  _buildFloatingIcon('✨', 0.9, 0.4, 0.4),
                ],
              );
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: _selectedImage == null
                        ? Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.image, color: Colors.white54, size: 80),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(_selectedImage!, width: 180, height: 180, fit: BoxFit.cover),
                          ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo_library),
                        label: Text('Gallery'),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildSelectors(),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _submitLook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF667eea),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: _isUploading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text('Upload Look'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

