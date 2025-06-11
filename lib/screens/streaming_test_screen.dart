import 'package:flutter/material.dart';
import '../services/public_domain_service.dart';

class StreamingTestScreen extends StatefulWidget {
  @override
  _StreamingTestScreenState createState() => _StreamingTestScreenState();
}

class _StreamingTestScreenState extends State<StreamingTestScreen> {
  String _testResults = 'Tap "Run Tests" to check streaming sources...';
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streaming Test'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isRunning ? null : _runArchiveTests,
                      child: _isRunning 
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Testing...'),
                              ],
                            )
                          : Text('Test Archive IDs'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isRunning ? null : _testSpecificMovie,
                      child: Text('Test Movie ID 4 (Metropolis)'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runArchiveTests() async {
    setState(() {
      _isRunning = true;
      _testResults = 'Running archive ID tests...\n\n';
    });

    try {
      // Capture print output
      final buffer = StringBuffer();
      
      // Override print temporarily
      void captureOutput(String message) {
        buffer.writeln(message);
        setState(() {
          _testResults = buffer.toString();
        });
      }

      // Run the test with custom print capture
      await _runCustomArchiveTest(captureOutput);
      
    } catch (e) {
      setState(() {
        _testResults += '\nError running tests: $e';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  Future<void> _runCustomArchiveTest(Function(String) output) async {
    final testIds = [
      'night_of_the_living_dead_1968',
      'plan_9_from_outer_space',
      'Metropolis1927',
      'metropolis_1927',
      'Charade_Cary_Grant_Audrey_Hepburn_1963',
      'His_Girl_Friday_1940',
      'TheManWithTheMovieCamera',
      'cc_1940_the_great_dictator',
    ];

    for (final id in testIds) {
      output('\n=== Testing Archive ID: $id ===');
      try {
        final response = await http.get(
          Uri.parse('https://archive.org/metadata/$id'),
          headers: {'Accept': 'application/json'},
        );
        
        output('Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['files'] != null) {
            final files = data['files'] as Map<String, dynamic>;
            output('Found ${files.length} files');
            
            int videoCount = 0;
            files.forEach((filename, fileData) {
              final format = fileData['format']?.toString() ?? '';
              if (format.toLowerCase().contains('mp4') || 
                  format.toLowerCase().contains('mpeg4') ||
                  format.toLowerCase().contains('h.264') ||
                  filename.toLowerCase().endsWith('.mp4')) {
                videoCount++;
                output('✓ Video: $filename (${format})');
              }
            });
            output('Total video files: $videoCount');
            if (videoCount == 0) {
              output('❌ No video files found!');
            }
          } else {
            output('❌ No files metadata found');
          }
        } else {
          output('❌ Error: HTTP ${response.statusCode}');
          if (response.body.isNotEmpty) {
            output('Response: ${response.body.substring(0, 200)}...');
          }
        }
      } catch (e) {
        output('❌ Exception: $e');
      }
      
      // Small delay to update UI
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    output('\n=== Test Complete ===');
  }

  Future<void> _testSpecificMovie() async {
    setState(() {
      _isRunning = true;
      _testResults = 'Testing movie ID 4 (Metropolis)...\n\n';
    });

    try {
      final sources = await PublicDomainService.getMovieStreams(4);
      
      setState(() {
        _testResults += 'Results for Movie ID 4:\n';
        _testResults += 'Found ${sources.length} streaming sources:\n\n';
        
        for (int i = 0; i < sources.length; i++) {
          final source = sources[i];
          _testResults += '${i + 1}. Quality: ${source.quality}\n';
          _testResults += '   URL: ${source.url}\n';
          _testResults += '   Type: ${source.type}\n\n';
        }
        
        if (sources.isEmpty) {
          _testResults += '❌ No streaming sources found!\n';
        } else {
          _testResults += '✓ Ready to stream!\n';
        }
      });
      
    } catch (e) {
      setState(() {
        _testResults += 'Error testing movie: $e\n';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }
}

// Need to import http and json for the test
import 'dart:convert';
import 'package:http/http.dart' as http;
