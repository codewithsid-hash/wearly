
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class BestCombinationPage extends StatefulWidget {
  @override
  _BestCombinationPageState createState() => _BestCombinationPageState();
}

class _BestCombinationPageState extends State<BestCombinationPage> {
  File? _selectedImage;
  String gender = 'male';
  String occasion = 'casual';
  String season = 'summer';
  String clothingType = 'shirt';
  bool isLoading = false;
  Map<String, dynamic>? result;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (_selectedImage == null) return;
    setState(() => isLoading = true);

    final uri = Uri.parse('http://192.168.10.171:8045/recommend-from-upload/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['input_clothing_type'] = 'shirt'
      ..fields['gender'] = gender
      ..fields['occasion'] = occasion
      ..fields['season'] = season
      ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      setState(() {
        result = jsonDecode(body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get recommendation")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Best Combination',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF667eea)))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: result != null ? _buildResultView() : _buildInputForm(),
            ),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.photo, color: Colors.white),
            label: Text("Pick Image", style: TextStyle(color: Colors.white)),
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF667eea),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          if (_selectedImage != null)
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          _buildStyledDropdown("Gender", gender, ['male', 'female'], (v) => setState(() => gender = v!)),
          _buildStyledDropdown("Occasion", occasion, ['casual', 'formal', 'party'], (v) => setState(() => occasion = v!)),
          _buildStyledDropdown("Season", season, ['summer', 'winter', 'spring', 'fall'], (v) => setState(() => season = v!)),
          _buildStyledDropdown("Clothing Type",clothingType,['shirt', 'tshirt', 'pants'],(v) => setState(() => clothingType = v!)),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              backgroundColor: Color(0xFF764ba2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text("Get Recommendation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          dropdownColor: Color(0xFF1a1a2e),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
          style: TextStyle(color: Colors.white),
          iconEnabledColor: Colors.white70,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final inputItem = result!['input_item'];
    final recommended = List<Map<String, dynamic>>.from(result!['recommended_outfit']);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Your Upload", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _buildImageCard(imageUrl: inputItem['image_url'], label: 'You'),
          SizedBox(height: 24),
          Text("Recommended Items", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...recommended.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _buildImageCard(imageUrl: item['image_url'], label: item['clothing_type']),
              )),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => setState(() => result = null),
            icon: Icon(Icons.refresh, color: Colors.white),
            label: Text("Try Again", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF667eea),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard({String? imageUrl, required String label}) {
    return Column(
      children: [
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Icon(Icons.image_not_supported, size: 100, color: Colors.white30),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }
}


