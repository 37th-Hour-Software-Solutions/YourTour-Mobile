import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/user.dart';
import './collection_shelf.dart';

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
                // Show badge details modal
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _BadgeDetailsModal(badge: badge),
                );
              },
              child: Card(
                child: SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network("http://localhost:3000/${badge['static_image_url']}",
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
                // Show gem details modal
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _GemDetailsModal(gem: gem),
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

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    String? text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            if (text != null) ...[
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _BadgeDetailsModal extends StatelessWidget {
  final Map<String, dynamic> badge;

  const _BadgeDetailsModal({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/${badge['static_image_url']}',
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 16),
          Text(
            badge['name'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            badge['description'] as String,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _GemDetailsModal extends StatelessWidget {
  final Map<String, dynamic> gem;

  const _GemDetailsModal({required this.gem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${gem['city']}, ${gem['state']}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(gem['description'] as String),
        ],
      ),
    );
  }
} 