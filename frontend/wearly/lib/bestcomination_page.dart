import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Future<void> _submit() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image first")),
      );
      return;
    }
    
    setState(() => isLoading = true);

    try {
      final uri = Uri.parse('http://192.168.31.75:8045/recommend-from-upload/');
      final request = http.MultipartRequest('POST', uri)
        ..fields['input_clothing_type'] = clothingType
        ..fields['gender'] = gender
        ..fields['occasion'] = occasion
        ..fields['season'] = season
        ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final decodedResult = jsonDecode(body);
        
        // Debug print to see the actual response
        print('API Response: $decodedResult');
        
        setState(() {
          result = decodedResult;
          isLoading = false;
        });
      } else {
        final errorBody = await response.stream.bytesToString();
        print('Error Response: $errorBody');
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get recommendation: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF667eea)),
                  SizedBox(height: 16),
                  Text(
                    'Getting recommendations...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: result != null ? _buildResultView() : _buildInputForm(),
              ),
            ),
    );
  }

  Widget _buildInputForm() {
    return Column(
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
        if (_selectedImage != null) ...[
          SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.white30,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        SizedBox(height: 20),
        _buildStyledDropdown("Gender", gender, ['male', 'female'], (v) => setState(() => gender = v!)),
        _buildStyledDropdown("Occasion", occasion, ['casual', 'formal', 'party'], (v) => setState(() => occasion = v!)),
        _buildStyledDropdown("Season", season, ['summer', 'winter', 'spring', 'fall'], (v) => setState(() => season = v!)),
        _buildStyledDropdown("Clothing Type", clothingType, ['shirt', 'tshirt', 'pants'], (v) => setState(() => clothingType = v!)),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            backgroundColor: Color(0xFF764ba2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text("Get Recommendation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStyledDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: TextStyle(color: Colors.white),
          iconEnabledColor: Colors.white70,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (result == null) return Container();
    
    final inputItem = result!['input_item'] as Map<String, dynamic>?;
    final recommendedList = result!['recommended_outfit'] as List<dynamic>?;
    
    if (inputItem == null || recommendedList == null) {
      return Center(
        child: Text(
          'Invalid response format',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    
    final recommended = recommendedList.cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Your Upload", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        _buildImageCard(
          imageBase64: inputItem['image_base64'], 
          label: inputItem['clothing_type'] ?? 'Your Item'
        ),
        SizedBox(height: 24),
        Text("Recommended Items", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recommended.length,
          itemBuilder: (context, index) {
            final item = recommended[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: _buildImageCard(
                imageBase64: item['image_base64'], 
                label: item['clothing_type'] ?? 'Item ${index + 1}'
              ),
            );
          },
        ),
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
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImageCard({String? imageBase64, required String label}) {
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
            child: imageBase64 != null && imageBase64.isNotEmpty
                ? Image.memory(
                    base64Decode(imageBase64),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50, color: Colors.white30),
                            SizedBox(height: 8),
                            Text(
                              'Image not found',
                              style: TextStyle(color: Colors.white30, fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Icon(Icons.image_not_supported, size: 100, color: Colors.white30),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}