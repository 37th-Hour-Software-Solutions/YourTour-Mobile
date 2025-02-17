import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/user.dart';
import './collection_shelf.dart';
import './achievement_popup.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ProfileStats extends StatelessWidget {
  final User user;

  const ProfileStats({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: MemoryImage(base64Decode(user.profilePictureBlob)),
                backgroundColor: Colors.grey[300],
                child: user.profilePictureBlob.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('Gems', user.gemsFound.toString()),
                    _buildStatColumn('Badges', user.badgesFound.toString()),
                    _buildStatColumn('Cities', user.citiesFound.toString()),
                    _buildStatColumn('States', user.statesFound.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${user.username}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'From ${user.homestate}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (user.interests.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: user.interests.map((interest) => 
                    Chip(
                      label: Text(interest['name'] as String),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ).toList(),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 32),
        if (user.badges.isNotEmpty)
          CollectionShelf(
            title: 'Badges',
            items: user.badges,
            itemBuilder: (badge) => InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => AchievementPopup(
                    title: badge['name'] as String,
                    description: badge['description'] as String,
                    imagePath: 'assets/images/badges/${badge['static_image_url']}',
                    animationPath: 'assets/animations/sparkle.json',
                    onShare: () => _shareBadge(context, badge),
                  ),
                );
              },
              child: Card(
                child: SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/badges/${badge['static_image_url']}',
                        height: 60,
                        width: 60,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge['name'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (user.gems.isNotEmpty)
          CollectionShelf(
            title: 'Gems',
            items: user.gems,
            itemBuilder: (gem) => InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => AchievementPopup(
                    title: '${gem['city']}, ${gem['state']}',
                    description: gem['description'] as String,
                    animationPath: 'assets/animations/gem.json',
                    onShare: () => _shareGem(context, gem),
                  ),
                );
              },
              child: Card(
                child: SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gem['city'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          gem['state'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          gem['description'] as String,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

Future<void> _shareBadge(BuildContext context, dynamic badge) async {
  final box = context.findRenderObject() as RenderBox?;
  
  try {
    // Get the asset bytes
    final ByteData bytes = await rootBundle.load('assets/images/badges/${badge['static_image_url']}');
    final Uint8List list = bytes.buffer.asUint8List();
    // Create temp file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${badge['static_image_url']}');
    await file.writeAsBytes(list);
    // Share the file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'I just earned the ${badge['name']} badge in YourTour!',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing badge: $e')),
      );
    }
  }
}

Future<void> _shareGem(BuildContext context, dynamic gem) async {
  final box = context.findRenderObject() as RenderBox?;
  
  try {
    await Share.share(
      'I found a gem in YourTour by visiting ${gem['city']}, ${gem['state']}!',
      subject: 'I found a new gem in YourTour!',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing gem: $e')),
      );
    }
  }
}