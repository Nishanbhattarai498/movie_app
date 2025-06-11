import 'package:flutter/material.dart';
import '../services/public_domain_service.dart';
import 'streaming_test_screen.dart';

class StreamingInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streaming Information'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.black54],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                'Real Movie Content',
                'The following movies stream actual content from public domain sources:',
                Icons.movie,
                Colors.green,
                _getRealContentList(),
              ),
              SizedBox(height: 20),
              _buildInfoCard(
                'Demo Content',
                'Other movies use demo videos for educational purposes:',
                Icons.play_circle_outline,
                Colors.orange,
                _getDemoContentList(),
              ),
              SizedBox(height: 20),
              _buildInfoCard(
                'Legal Notice',
                'All content is either public domain or used for educational demonstration. No copyrighted material is distributed.',
                Icons.info,
                Colors.blue,
                [],
              ),              SizedBox(height: 20),
              _buildHowToSection(),
              SizedBox(height: 20),
              _buildTestButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon,
      Color color, List<String> items) {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            if (items.isNotEmpty) ...[
              SizedBox(height: 12),
              ...items
                  .map((item) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: color, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHowToSection() {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.cyan, size: 24),
                SizedBox(width: 12),
                Text(
                  'How to Add Your Own Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'To add your own legal content:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 8),
            _buildStep('1. Obtain legal rights to stream content'),
            _buildStep('2. Host videos on a CDN or streaming service'),
            _buildStep('3. Update PublicDomainService with new URLs'),
            _buildStep('4. Ensure proper content licensing'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Never distribute copyrighted content without proper licensing!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String step) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.arrow_right, color: Colors.cyan, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              step,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getRealContentList() {
    return [
      'Night of the Living Dead (1968)',
      'Plan 9 from Outer Space',
      'The Cabinet of Dr. Caligari',
      'Metropolis (1927)',
      'Charade (1963)',
      'His Girl Friday',
      'The Great Dictator',
      'Phantom of the Opera (1925)',
    ];
  }

  List<String> _getDemoContentList() {
    return [
      'Big Buck Bunny',
      'Elephants Dream',
      'For Bigger Blazes',
      'Sintel',
      'Tears of Steel',
    ];
  }
}
