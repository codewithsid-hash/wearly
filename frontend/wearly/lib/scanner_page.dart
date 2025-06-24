

//////////////////////////////////////////

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


//////////////////////////////////////////


/////////////////////////// Good feature    ////////////////////////////////
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class ScannerPage extends StatefulWidget {
//   @override
//   _ScannerPageState createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   File? _imageFile;
//   String? _clothingType;
//   String? _gender;
//   String? _occasion;
//   String? _season;

//   final picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//         _clothingType = null;
//         _gender = null;
//         _occasion = null;
//         _season = null;
//       });
//     }
//   }

//   void _sendOutfit() {
//     if (_imageFile == null) {
//       _showSnack("Please upload an image first.");
//       return;
//     }
//     _showSnack("Matching outfit...");
//     // Add your POST request logic here if needed
//   }

//   void _uploadToCloset() {
//     if (_imageFile == null) {
//       _showSnack("Please upload an image first.");
//       return;
//     }
//     _showSnack("Uploaded to Closet!");
//     // Add your upload logic here if needed
//   }

//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   Widget _styledDropdown(String hint, List<String> options, String? value, void Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       dropdownColor: Colors.black,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFF1C1C1E),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       hint: Text(hint, style: const TextStyle(color: Colors.white54)),
//       value: value,
//       onChanged: onChanged,
//       items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       appBar: AppBar(
//         title: const Text('SnapFit'),
//         backgroundColor: Colors.black,
//         elevation: 4,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   backgroundColor: Colors.black87,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                   ),
//                   builder: (_) => SafeArea(
//                     child: Wrap(
//                       children: [
//                         ListTile(
//                           leading: const Icon(Icons.camera_alt, color: Colors.cyanAccent),
//                           title: const Text("Camera", style: TextStyle(color: Colors.white)),
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.camera);
//                           },
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.photo_library, color: Colors.cyanAccent),
//                           title: const Text("Gallery", style: TextStyle(color: Colors.white)),
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.gallery);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 220,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1F1F1F),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.grey.shade800),
//                 ),
//                 child: _imageFile == null
//                     ? const Center(child: Text("Tap to Add Image", style: TextStyle(color: Colors.white54)))
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Image.file(_imageFile!, fit: BoxFit.cover),
//                       ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Show dropdowns only after image upload
//             if (_imageFile != null) ...[
//               _styledDropdown("Type", ['T-Shirt', 'Shirt', 'Pants', 'Jacket'], _clothingType, (v) => setState(() => _clothingType = v)),
//               const SizedBox(height: 12),
//               _styledDropdown("Gender", ['Male', 'Female'], _gender, (v) => setState(() => _gender = v)),
//               const SizedBox(height: 12),
//               _styledDropdown("Occasion", ['Formal', 'Casual', 'Party'], _occasion, (v) => setState(() => _occasion = v)),
//               const SizedBox(height: 12),
//               _styledDropdown("Season", ['Summer', 'Winter', 'Spring', 'Autumn'], _season, (v) => setState(() => _season = v)),
//               const SizedBox(height: 24),
//             ],

//             // Buttons always visible
//             Row(
//   children: [
//     Expanded(
//       child: ElevatedButton(
//         onPressed: _sendOutfit,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.tealAccent[700], // Always teal
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: const Text("Match"),
//       ),
//     ),
//     const SizedBox(width: 16),
//     Expanded(
//       child: ElevatedButton(
//         onPressed: _uploadToCloset,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple, // Always purple
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: const Text("Closet+"),
//                 ),
//               ),
//             ],
//           ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//////////////////////

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class ScannerPage extends StatefulWidget {
//   @override
//   _ScannerPageState createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   File? _imageFile;
//   String? _clothingType;
//   String? _gender;
//   String? _occasion;
//   String? _season;

//   final picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//         _clothingType = null;
//         _gender = null;
//         _occasion = null;
//         _season = null;
//       });
//     }
//   }

//   void _sendOutfit() {
//     if (_imageFile == null) {
//       _showSnack("Please upload an image first.");
//       return;
//     }
//     _showSnack("Matching outfit...");
//     // Add your POST request logic here if needed
//   }

//   void _uploadToCloset() {
//     if (_imageFile == null) {
//       _showSnack("Please upload an image first.");
//       return;
//     }
//     _showSnack("Uploaded to Closet!");
//     // Add your upload logic here if needed
//   }

//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   Widget _styledDropdown(String hint, List<String> options, String? value, void Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       dropdownColor: Colors.black,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFF1C1C1E),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       hint: Text(hint, style: const TextStyle(color: Colors.white54)),
//       value: value,
//       onChanged: onChanged,
//       items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       appBar: AppBar(
//         title: const Text('SnapFit'),
//         backgroundColor: Colors.black,
//         elevation: 4,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   backgroundColor: Colors.black87,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                   ),
//                   builder: (_) => SafeArea(
//                     child: Wrap(
//                       children: [
//                         ListTile(
//                           leading: const Icon(Icons.camera_alt, color: Colors.cyanAccent),
//                           title: const Text("Camera", style: TextStyle(color: Colors.white)),
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.camera);
//                           },
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.photo_library, color: Colors.cyanAccent),
//                           title: const Text("Gallery", style: TextStyle(color: Colors.white)),
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.gallery);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 220,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1F1F1F),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.grey.shade800),
//                 ),
//                 child: _imageFile == null
//                     ? const Center(child: Text("Tap to Add Image", style: TextStyle(color: Colors.white54)))
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Image.file(_imageFile!, fit: BoxFit.cover),
//                       ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Show dropdowns only after image upload
//             if (_imageFile != null) ...[
//               _styledDropdown("Type", ['T-Shirt', 'Shirt', 'Pants', 'Jacket'], _clothingType, (v) => setState(() => _clothingType = v)),
//               const SizedBox(height: 12),
//               _styledDropdown("Gender", ['Male', 'Female'], _gender, (v) => setState(() => _gender = v)),
//               const SizedBox(height: 12),
//               _styledDropdown("Occasion", ['Formal', 'Casual', 'Party'], _occasion, (v) => setState(() => _occasion = v)),
//               const SizedBox(height: 12),
//               _styledDropdown("Season", ['Summer', 'Winter', 'Spring', 'Autumn'], _season, (v) => setState(() => _season = v)),
//               const SizedBox(height: 24),
//             ],

//             // Buttons always visible
//             Row(
//   children: [
//     Expanded(
//       child: ElevatedButton(
//         onPressed: _sendOutfit,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.tealAccent[700], // Always teal
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: const Text("Match"),
//       ),
//     ),
//     const SizedBox(width: 16),
//     Expanded(
//       child: ElevatedButton(
//         onPressed: _uploadToCloset,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple, // Always purple
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: const Text("Closet+"),
//                 ),
//               ),
//             ],
//           ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//////////////////// Testing 3 Reallyyy Good  ///////////////////////////////////

//////////////////// Testing 2 looks good(UI) analyzing clothing ///////////////////////////////////



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';

// class ScannerPage extends StatefulWidget {
//   @override
//   _ScannerPageState createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   File? _imageFile;
//   String? _clothingType;
//   String? _gender;
//   String? _occasion;
//   String? _season;

//   final List<String> clothingTypes = ['T-Shirt', 'Shirt', 'Pants', 'Jacket'];
//   final List<String> genders = ['Male', 'Female'];
//   final List<String> occasions = ['Formal', 'Casual', 'Party'];
//   final List<String> seasons = ['Summer', 'Winter', 'Spring', 'Autumn'];

//   final picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _submitOutfit() async {
//     if (_imageFile == null || _clothingType == null || _gender == null || _occasion == null || _season == null) {
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         SnackBar(content: Text('Please fill in all fields and upload an image.')),
//       );
//       return;
//     }

//     var uri = Uri.parse('http://127.0.0.1:8008/recommend-outfit/');
//     var request = http.MultipartRequest('POST', uri)
//       ..fields['input_clothing_type'] = _clothingType!.toLowerCase()
//       ..fields['gender'] = _gender!
//       ..fields['occasion'] = _occasion!
//       ..fields['season'] = _season!
//       ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         SnackBar(content: Text('Outfit recommendation received!')),
//       );
//     } else {
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         SnackBar(content: Text('Failed to get recommendation.')),
//       );
//     }
//   }

//   Future<void> _uploadToCollection() async {
//     // Dummy function - replace with your own collection upload endpoint
//     ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//       SnackBar(content: Text('Uploaded to your collection!')),
//     );
//   }

//   Widget _buildDropdown(String title, List<String> options, String? value, void Function(String?) onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
//         SizedBox(height: 4),
//         DropdownButtonFormField<String>(
//           value: value,
//           hint: Text("Select $title"),
//           onChanged: onChanged,
//           decoration: InputDecoration(border: OutlineInputBorder()),
//           items: options.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
//         ),
//         SizedBox(height: 16),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Outfit Scanner'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         showModalBottomSheet(
//                           context: context,
//                           builder: (_) => SafeArea(
//                             child: Wrap(
//                               children: [
//                                 ListTile(
//                                   leading: Icon(Icons.camera_alt),
//                                   title: Text('Take Photo'),
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     _pickImage(ImageSource.camera);
//                                   },
//                                 ),
//                                 ListTile(
//                                   leading: Icon(Icons.photo_library),
//                                   title: Text('Choose from Gallery'),
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     _pickImage(ImageSource.gallery);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 200,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.grey[200],
//                         ),
//                         child: _imageFile == null
//                             ? Center(child: Text("Tap to upload image"))
//                             : ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(_imageFile!, fit: BoxFit.cover),
//                               ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 24),

//                   _buildDropdown("Clothing Type", clothingTypes, _clothingType, (val) => setState(() => _clothingType = val)),
//                   _buildDropdown("Gender", genders, _gender, (val) => setState(() => _gender = val)),
//                   _buildDropdown("Occasion", occasions, _occasion, (val) => setState(() => _occasion = val)),
//                   _buildDropdown("Season", seasons, _season, (val) => setState(() => _season = val)),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: _submitOutfit,
//                           icon: Icon(Icons.recommend),
//                           label: Text("Finding matching"),
//                           style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: _uploadToCollection,
//                           icon: Icon(Icons.cloud_upload),
//                           label: Text("Upload to Collection"),
//                           style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



////////////////////// Testing 2 looks good(UI) analyzing clothing ///////////////////////////////////


// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:wearly/homeScreen.dart';

// class ScannerPage extends StatefulWidget {
//   const ScannerPage({super.key});

//   @override
//   State<ScannerPage> createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage>
//     with TickerProviderStateMixin {
//   File? _imageFile;
//   List<dynamic> _results = [];
//   bool _isLoading = false;
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   final String apiUrl = "http://192.168.10.126:8008/recommend-outfit/";

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: source,
//       maxWidth: 1024,
//       maxHeight: 1024,
//       imageQuality: 85,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//         _results = [];
//       });
//       _fadeController.forward();
//     }
//   }

//     Future<void> _analyzeImage() async {
//     if (_imageFile == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//       request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         final data = jsonDecode(responseBody);
//         final List detections = data["detections"];

//         if (detections.isNotEmpty) {
//           // ✅ Directly set results without tagging
//           setState(() {
//             _results = detections;
//           });
//           _fadeController.forward();
//           _slideController.forward();
//         } else {
//           _showPremiumToast("No clothing detected.", isError: true);
//         }
//       } else {
//         _showPremiumToast("Analysis failed. Please try again.", isError: true);
//       }
//     } catch (e) {
//       _showPremiumToast("Network error. Check your connection.", isError: true);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }



//   void _showPremiumToast(String message, {bool isError = false}) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.TOP,
//       backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
//       textColor: Colors.white,
//       fontSize: 14.0,
//     );
//   }

//   Widget _buildImagePreview() {
//     if (_imageFile == null) {
//       return Container(
//         height: 280,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.grey.shade100,
//               Colors.grey.shade200,
//             ],
//           ),
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: Colors.grey.shade300, width: 2),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.camera_alt_outlined,
//               size: 64,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Select an image to analyze',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Upload from camera or gallery',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         height: 280,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(24),
//           child: Image.file(
//             _imageFile!,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//     required Color color,
//     bool isPrimary = false,
//   }) {
//     return Expanded(
//       child: Container(
//         height: 56,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: isPrimary
//               ? LinearGradient(
//                   colors: [color, color.withOpacity(0.8)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 )
//               : null,
//           color: isPrimary ? null : color.withOpacity(0.1),
//           boxShadow: isPrimary
//               ? [
//                   BoxShadow(
//                     color: color.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 6),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(16),
//             onTap: onPressed,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   icon,
//                   color: isPrimary ? Colors.white : color,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: isPrimary ? Colors.white : color,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnalyzeAndUploadButtons() {
//   return Row(
//     children: [
//       Expanded(
//         child: Container(
//           height: 56,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: _imageFile != null
//                 ? LinearGradient(
//                     colors: [
//                       Colors.deepPurple.shade600,
//                       Colors.deepPurple.shade400,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   )
//                 : null,
//             color: _imageFile == null ? Colors.grey.shade300 : null,
//             boxShadow: _imageFile != null
//                 ? [
//                     BoxShadow(
//                       color: Colors.deepPurple.withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: _imageFile != null && !_isLoading ? _analyzeImage : null,
//               child: Center(
//                 child: _isLoading
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.auto_awesome,
//                             color: _imageFile != null ? Colors.white : Colors.grey.shade500,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Analyze',
//                             style: TextStyle(
//                               color: _imageFile != null ? Colors.white : Colors.grey.shade500,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Container(
//           height: 56,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               colors: [Colors.green.shade600, Colors.green.shade400],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.green.withOpacity(0.3),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: _imageFile != null && !_isLoading
//                   ? () => _showPremiumToast("Upload feature not implemented yet.")
//                   : null,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.upload_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Upload',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }


//   Widget _buildResultCard(Map result, int index) {
//     final color = result['dominant_color'];
//     final confidence = (result['confidence'] * 100).toStringAsFixed(1);

//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Container(
//           margin: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 16,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(color['r'], color['g'], color['b'], 1),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color.fromRGBO(color['r'], color['g'], color['b'], 0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.palette,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         result['label'],
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Confidence: $confidence%',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'RGB(${color['r']}, ${color['g']}, ${color['b']})',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     '$confidence%',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//     ),
//         ),
//         title: const Text(
//           'Wearly Scanner',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//           ),
//         ),
       
//       ),
    
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildImagePreview(),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 _buildActionButton(
//                   icon: Icons.camera_alt,
//                   label: 'Camera',
//                   onPressed: () => _pickImage(ImageSource.camera),
//                   color: Colors.blue.shade600,
//                 ),
//                 const SizedBox(width: 12),
//                 _buildActionButton(
//                   icon: Icons.photo_library,
//                   label: 'Gallery',
//                   onPressed: () => _pickImage(ImageSource.gallery),
//                   color: Colors.purple.shade600,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildAnalyzeAndUploadButtons(),
//             const SizedBox(height: 32),
//             if (_results.isNotEmpty) ...[
//               Text(
//                 'Analysis Results',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ...List.generate(
//                 _results.length,
//                 (index) => _buildResultCard(_results[index], index),
//               ),
//             ] else if (_imageFile != null && !_isLoading) ...[
//               Center(
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.analytics_outlined,
//                       size: 48,
//                       color: Colors.grey.shade400,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Ready to analyze',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Tap "Analyze Clothing" to get started',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
