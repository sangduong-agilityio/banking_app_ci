import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  final List<Map<String, dynamic>> languages = [
    {'name': 'Vietnamese', 'flag': '🇻🇳'},
    {'name': 'French', 'flag': '🇫🇷'},
    {'name': 'English', 'flag': '🇬🇧'},
    {'name': 'Japanese', 'flag': '🇯🇵'},
    {'name': 'Portuguese', 'flag': '🇵🇹'},
    {'name': 'Chinese', 'flag': '🇨🇳'},
    {'name': 'Korean', 'flag': '🇰🇷'},
    {'name': 'Spanish', 'flag': '🇪🇸'},
    {'name': 'Russian', 'flag': '🇷🇺'},
    {'name': 'German', 'flag': '🇩🇪'},
    {'name': 'Italian', 'flag': '🇮🇹'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Language',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return _buildLanguageItem(languages[index]);
        },
      ),
    );
  }

  Widget _buildLanguageItem(Map<String, dynamic> language) {
    bool isSelected = selectedLanguage == language['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language['name'];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Text(language['flag'], style: TextStyle(fontSize: 20)),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                language['name'],
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            if (isSelected) Icon(Icons.check, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }
}
