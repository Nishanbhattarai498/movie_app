import 'package:flutter/material.dart';
import '../services/tmdb_service.dart';
import '../services/simple_legal_content_service.dart';
import '../services/simple_legal_content_manager.dart';

class SimpleLegalContentWidget extends StatefulWidget {
  final int? movieId;
  final bool showDisclaimer;

  const SimpleLegalContentWidget({
    Key? key,
    this.movieId,
    this.showDisclaimer = true,
  }) : super(key: key);

  @override
  State<SimpleLegalContentWidget> createState() =>
      _SimpleLegalContentWidgetState();
}

class _SimpleLegalContentWidgetState extends State<SimpleLegalContentWidget> {
  SimpleLegalContent? _legalContent;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.movieId != null) {
      _loadLegalContent();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadLegalContent() async {
    try {
      final content =
          await SimpleLegalContentManager.getLegalContent(widget.movieId!);
      setState(() {
        _legalContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showDisclaimer) _buildLegalDisclaimer(),
        if (_isLoading) _buildLoadingWidget(),
        if (_error != null) _buildErrorWidget(),
        if (_legalContent != null) _buildLegalContentWidget(),
        _buildFreePlatformsWidget(),
        _buildPublicDomainWidget(),
      ],
    );
  }

  Widget _buildLegalDisclaimer() {
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
            'This app only provides access to legal content sources including trailers, public domain movies, and licensed streaming platforms.',
            style: TextStyle(color: Colors.green.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Could not load legal sources. Showing basic content.',
        style: TextStyle(color: Colors.orange.shade800),
      ),
    );
  }

  Widget _buildLegalContentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_legalContent!.trailers.isNotEmpty) _buildTrailersSection(),
        if (_legalContent!.streamingSources.isNotEmpty)
          _buildStreamingSourcesSection(),
      ],
    );
  }

  Widget _buildTrailersSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Official Trailers',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _legalContent!.trailers.length,
              itemBuilder: (context, index) {
                final trailer = _legalContent!.trailers[index];
                return _buildTrailerCard(trailer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailerCard(TrailerInfo trailer) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Center(
                child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trailer.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'YouTube • ${trailer.type}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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

  Widget _buildStreamingSourcesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legal Streaming Sources',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ...(_legalContent!.streamingSources
              .map((source) => _buildStreamingSourceCard(source))),
        ],
      ),
    );
  }

  Widget _buildStreamingSourceCard(LegalStreamingSource source) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.play_circle),
        title: Text(source.name),
        subtitle: Text(_getSourceTypeDescription(source.type)),
        trailing: Icon(Icons.open_in_new),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Would open: ${source.url}')),
          );
        },
      ),
    );
  }

  Widget _buildFreePlatformsWidget() {
    final freePlatforms = LegalContentService.getFreePlatforms();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free Legal Streaming Platforms',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ...freePlatforms.map((platform) => _buildPlatformCard(platform)),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(StreamingPlatform platform) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.tv),
        title: Text(platform.name),
        subtitle: Text(platform.description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'FREE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Would open: ${platform.url}')),
          );
        },
      ),
    );
  }

  Widget _buildPublicDomainWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Public Domain Content',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.public, color: Colors.blue),
              title: Text('Archive.org'),
              subtitle: Text('Free public domain movies and documentaries'),
              trailing: Icon(Icons.open_in_new),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Would open: https://archive.org/details/movies')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.movie, color: Colors.green),
              title: Text('Creative Commons'),
              subtitle: Text('Open source films and animations'),
              trailing: Icon(Icons.open_in_new),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Would open Creative Commons content')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getSourceTypeDescription(String type) {
    switch (type) {
      case 'free':
        return 'Free with ads';
      case 'subscription':
        return 'Subscription required';
      case 'rental':
        return 'Pay per view';
      default:
        return 'Check availability';
    }
  }
}

// Simple streaming recommendations widget
class SimpleStreamingRecommendationsWidget extends StatelessWidget {
  const SimpleStreamingRecommendationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recommendations =
        SimpleLegalContentManager.getStreamingRecommendations();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Legal Streaming Options',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        ...recommendations.map((recommendation) =>
            _buildRecommendationCard(context, recommendation)),
      ],
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, StreamingRecommendation recommendation) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: _getCategoryIcon(recommendation.category),
        title: Text(recommendation.category),
        subtitle: Text(recommendation.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recommendation.platforms
                  .map(
                    (platform) => ListTile(
                      leading: Icon(Icons.tv),
                      title: Text(platform.name),
                      subtitle: Text(platform.description),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Would open: ${platform.url}')),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'free with ads':
        return Icon(Icons.free_breakfast, color: Colors.green);
      case 'subscription services':
        return Icon(Icons.subscriptions, color: Colors.blue);
      default:
        return Icon(Icons.movie, color: Colors.grey);
    }
  }
}
