import 'package:flutter/material.dart';
import '../services/legal_content_helper.dart';

class SimpleLegalWidget extends StatelessWidget {
  final bool showFullDisclaimer;

  const SimpleLegalWidget({
    Key? key,
    this.showFullDisclaimer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showFullDisclaimer) _buildLegalDisclaimer(context),
        _buildFreePlatforms(context),
        _buildSubscriptionPlatforms(context),
        _buildEducationalSources(context),
      ],
    );
  }

  Widget _buildLegalDisclaimer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Legal Content Only',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This app only provides access to legal content sources and links to legitimate streaming services.',
            style: TextStyle(color: Colors.green.shade700),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showFullDisclaimer(context),
            child: const Text('View Full Legal Notice'),
          ),
        ],
      ),
    );
  }

  Widget _buildFreePlatforms(BuildContext context) {
    final platforms = LegalContentHelper.getFreeLegalPlatforms();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free Legal Streaming',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ...platforms
              .map((platform) => _buildPlatformCard(platform, Colors.green)),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlatforms(BuildContext context) {
    final platforms = LegalContentHelper.getSubscriptionPlatforms();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subscription Services',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ...platforms
              .take(3)
              .map((platform) => _buildPlatformCard(platform, Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildEducationalSources(BuildContext context) {
    final sources = LegalContentHelper.getEducationalSources();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Educational Content',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ...sources
              .take(2)
              .map((source) => _buildPlatformCard(source, Colors.purple)),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(Map<String, String> platform, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.play_circle, color: color),
        title: Text(platform['name'] ?? ''),
        subtitle: Text(platform['description'] ?? ''),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            platform['type'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // In a real app, you would launch the URL
          _showPlatformInfo(platform);
        },
      ),
    );
  }

  void _showFullDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Legal Notice'),
        content: SingleChildScrollView(
          child: Text(LegalContentHelper.getLegalDisclaimer()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPlatformInfo(Map<String, String> platform) {
    // This would normally launch the URL
    // For demo purposes, we just show a message
    print('Would open: ${platform['url']}');
  }
}

// Simple legal banner widget for quick display
class LegalBannerWidget extends StatelessWidget {
  const LegalBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.green.shade50,
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Legal content only • Support creators through official channels',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
