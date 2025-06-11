import 'dart:convert';
import 'dart:io';

// Quick test script to check Internet Archive API
void main() async {
  final client = HttpClient();

  // Test different archive IDs to see which ones work
  final testIds = [
    'night_of_the_living_dead_1968',
    'plan_9_from_outer_space',
    'Metropolis1927',
    'metropolis_1927',
    'MetropolisLang',
    'Charade_Cary_Grant_Audrey_Hepburn_1963',
    'His_Girl_Friday_1940',
    'TheManWithTheMovieCamera',
    'cc_1940_the_great_dictator',
  ];

  for (final id in testIds) {
    print('\n=== Testing: $id ===');
    try {
      final request =
          await client.getUrl(Uri.parse('https://archive.org/metadata/$id'));
      final response = await request.close();

      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);

        if (data['files'] != null) {
          final files = data['files'] as Map<String, dynamic>;
          print('Total files: ${files.length}');

          var videoFiles = 0;
          files.forEach((filename, fileData) {
            final format = fileData['format']?.toString() ?? '';
            if (format.toLowerCase().contains('mp4') ||
                format.toLowerCase().contains('mpeg4') ||
                filename.toLowerCase().endsWith('.mp4')) {
              videoFiles++;
              print('✓ $filename ($format)');
            }
          });

          if (videoFiles == 0) {
            print('❌ No video files found');
            // Show some file examples
            int count = 0;
            files.forEach((filename, fileData) {
              if (count < 3) {
                print('Sample file: $filename (${fileData['format']})');
                count++;
              }
            });
          } else {
            print('✅ Found $videoFiles video files');
          }
        } else {
          print('❌ No files metadata');
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }

  client.close();
  print('\n=== Test Complete ===');
}
