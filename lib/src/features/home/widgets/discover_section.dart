import 'package:flutter/material.dart';
import '../models/city.dart';
import 'filter_button.dart';
import 'city_card.dart';

class DiscoverSection extends StatefulWidget {
  const DiscoverSection({super.key});

  @override
  State<DiscoverSection> createState() => _DiscoverSectionState();
}

class _DiscoverSectionState extends State<DiscoverSection> {
  String? _selectedState;
  final Set<String> _selectedTags = {};

  // TODO: Replace with real data from provider
  final cities = [
    City(
      name: 'New York',
      state: 'New York',
      distance: 5.2,
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Seattle_Center_as_night_falls.jpg/640px-Seattle_Center_as_night_falls.jpg',
      description: 'New York is a city in the United States.',
      tags: ['urban', 'nightlife', 'historic', 'cultural', 'family-friendly', 'cuisine', 'entertainment', 'shopping', 'sports']
    ),
    City(
      name: 'Boston', 
      state: 'Massachusetts', 
      distance: 12.8, 
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Seattle_Center_as_night_falls.jpg/640px-Seattle_Center_as_night_falls.jpg', 
      description: 'Boston is a city in the United States.',
      tags: ['historic', 'family-friendly', 'cultural', 'urban', 'education', 'nightlife', 'sports', 'cuisine']
    ),
    City(
      name: 'Philadelphia', 
      state: 'Pennsylvania', 
      distance: 15.3, 
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Seattle_Center_as_night_falls.jpg/640px-Seattle_Center_as_night_falls.jpg', 
      description: 'Philadelphia is a city in the United States.',
      tags: ['historic', 'cuisine', 'nightlife']
    ),
    City(
      name: 'Charleston',
      state: 'South Carolina', 
      distance: 10.5, 
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Seattle_Center_as_night_falls.jpg/640px-Seattle_Center_as_night_falls.jpg', 
      description: 'Charleston is a city in the United States.',
      tags: ['historic', 'rural', 'cultural', 'cuisine', 'romantic', 'southern']
    ),
    City(
      name: 'Chattanooga',
      state: 'Tennessee', 
      distance: 10.5, 
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Seattle_Center_as_night_falls.jpg/640px-Seattle_Center_as_night_falls.jpg', 
      description: 'Chattanooga is a city in the United States.',
      tags: ['rural', 'outdoors', 'adventure', 'scenic', 'nature']
    ),
  ];

  Set<String> get _allTags => cities.expand((city) => city.tags).toSet();
  Set<String> get _allStates => cities.map((city) => city.state).toSet();

  List<City> get _filteredCities => cities.where((city) {
    if (_selectedState != null && city.state != _selectedState) {
      return false;
    }
    if (_selectedTags.isNotEmpty && !_selectedTags.any((tag) => city.tags.contains(tag))) {
      return false;
    }
    return true;
  }).toList();

  void _showStateFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _StateFilterSheet(
        states: _allStates,
        selectedState: _selectedState,
        onStateSelected: (state) {
          setState(() => _selectedState = state);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showTagsFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _TagsFilterSheet(
        tags: _allTags,
        selectedTags: _selectedTags,
        onTagsChanged: (tags) {
          setState(() {
            _selectedTags.clear();
            _selectedTags.addAll(tags);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // Header and filter buttons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover Nearby',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    FilterButton(
                      label: 'Filter by State',
                      isActive: _selectedState != null,
                      onPressed: () => _showStateFilter(context),
                    ),
                    const SizedBox(width: 8),
                    FilterButton(
                      label: 'Filter by Tags',
                      isActive: _selectedTags.isNotEmpty,
                      onPressed: () => _showTagsFilter(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Cities grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => CityCard(city: _filteredCities[index]),
              childCount: _filteredCities.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _StateFilterSheet extends StatelessWidget {
  final Set<String> states;
  final String? selectedState;
  final ValueChanged<String?> onStateSelected;

  const _StateFilterSheet({
    required this.states,
    required this.selectedState,
    required this.onStateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Filter by State',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('All states'),
                selected: selectedState == null,
                onTap: () => onStateSelected(null),
              ),
              ...states.map((state) => ListTile(
                title: Text(state),
                selected: state == selectedState,
                onTap: () => onStateSelected(state),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _TagsFilterSheet extends StatefulWidget {
  final Set<String> tags;
  final Set<String> selectedTags;
  final ValueChanged<Set<String>> onTagsChanged;

  const _TagsFilterSheet({
    required this.tags,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  State<_TagsFilterSheet> createState() => _TagsFilterSheetState();
}

class _TagsFilterSheetState extends State<_TagsFilterSheet> {
  late final Set<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = Set.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Filter by Tags',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() => _selectedTags.clear());
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tags.map((tag) => FilterChip(
                label: Text(tag),
                selected: _selectedTags.contains(tag),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
              )).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onTagsChanged(_selectedTags);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 