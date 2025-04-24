import 'package:flutter/material.dart';
import './Event.dart';
import './Detail.dart';
import './MapScreen.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class HomeExplore extends StatefulWidget {
  const HomeExplore({super.key});

  @override
  _HomeExploreState createState() => _HomeExploreState();
}

class _HomeExploreState extends State<HomeExplore> {
  final TextEditingController _searchController = TextEditingController();
  Set<String> selectedCategories = {};
  DateTime? startDate;
  DateTime? endDate;
  String selectedTimeRange = 'All Day';
  final List<String> timeRanges = ['All Day', 'Morning (6AM-12PM)', 'Afternoon (12PM-5PM)', 'Evening (5PM-12AM)'];

  // Sample events data
  final List<Event> allEvents = [
    Event(
      "Summer Music Festival",
      "Central Park",
      "2024-07-15",
      category: EventCategories.music,
      time: "7:00 PM",
      address: "Central Park, New York, NY 10024",
      description: "Join us for an amazing night of live music featuring top artists from around the world.",
      imageUrl: "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=500&auto=format&fit=crop",
    ),
    Event(
      "Tech Innovation Summit",
      "Convention Center",
      "2024-04-05",
      category: EventCategories.tech,
      time: "9:00 AM",
      address: "655 W 34th St, New York, NY 10001",
      description: "Learn about the latest technologies and network with industry leaders.",
      imageUrl: "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500&auto=format&fit=crop",
    ),
    Event(
      "Food & Wine Festival",
      "Hudson Yards",
      "2024-05-20",
      category: EventCategories.food,
      time: "12:00 PM",
      address: "20 Hudson Yards, New York, NY 10001",
      description: "Experience the finest culinary delights from around the world.",
      imageUrl: "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500&auto=format&fit=crop",
    ),
    Event(
      "Contemporary Art Exhibition",
      "Museum of Modern Art",
      "2024-06-10",
      category: EventCategories.art,
      time: "10:00 AM",
      address: "11 W 53rd St, New York, NY 10019",
      description: "Explore groundbreaking contemporary art from emerging artists.",
      imageUrl: "https://images.unsplash.com/photo-1501084817091-a4f3d1d19e07?w=500&auto=format&fit=crop",
    ),
    Event(
      "Marathon Championship",
      "Brooklyn Bridge",
      "2024-09-22",
      category: EventCategories.sports,
      time: "6:00 AM",
      address: "Brooklyn Bridge, New York, NY",
      description: "Annual marathon championship with participants from around the globe.",
      imageUrl: "https://images.unsplash.com/photo-1517649763962-0c623066013b?w=500&auto=format&fit=crop",
    ),
    Event(
      "Jazz Night",
      "Blue Note Jazz Club",
      "2024-08-15",
      category: EventCategories.music,
      time: "8:00 PM",
      address: "131 W 3rd St, New York, NY 10012",
      description: "An evening of smooth jazz with world-renowned musicians.",
      imageUrl: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500&auto=format&fit=crop",
    ),
    Event(
      "Startup Pitch Competition",
      "WeWork Labs",
      "2024-07-30",
      category: EventCategories.tech,
      time: "2:00 PM",
      address: "115 W 18th St, New York, NY 10011",
      description: "Watch innovative startups pitch their ideas to investors.",
      imageUrl: "https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&auto=format&fit=crop",
    ),
    Event(
      "Sushi Masterclass",
      "Sushi Academy",
      "2024-06-25",
      category: EventCategories.food,
      time: "6:00 PM",
      address: "88 9th Ave, New York, NY 10011",
      description: "Learn the art of sushi making from master chefs.",
      imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500&auto=format&fit=crop",
    ),
  ];

  List<Event> get filteredEvents {
    List<Event> filtered = allEvents;

    // Apply category filter
    if (selectedCategories.isNotEmpty) {
      filtered = filtered.where((event) => selectedCategories.contains(event.category)).toList();
    }

    // Apply date range filter
    if (startDate != null && endDate != null) {
      filtered = filtered.where((event) {
        final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
        return eventDate.isAfter(startDate!.subtract(Duration(days: 1))) && 
               eventDate.isBefore(endDate!.add(Duration(days: 1)));
      }).toList();
    }

    // Apply time range filter
    if (selectedTimeRange != 'All Day') {
      filtered = filtered.where((event) {
        if (event.time.isEmpty) return false;
        
        final time = event.time.split(' ')[0];
        final hour = int.parse(time.split(':')[0]);
        final isPM = event.time.contains('PM');

        switch (selectedTimeRange) {
          case 'Morning (6AM-12PM)':
            return !isPM && hour >= 6;
          case 'Afternoon (12PM-5PM)':
            return (isPM && hour < 5) || (!isPM && hour == 12);
          case 'Evening (5PM-12AM)':
            return (isPM && hour >= 5) || (!isPM && hour == 12);
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? DateTime.now() : (endDate ?? DateTime.now()),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025, 12, 31),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover Events',
                    style: AppTheme.heading1.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find the best events happening around you',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search and Filter Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Range Filter
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text(startDate == null 
                            ? 'Start Date' 
                            : DateFormat('MMM dd, yyyy').format(startDate!)),
                          onPressed: () => _selectDate(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text(endDate == null 
                            ? 'End Date' 
                            : DateFormat('MMM dd, yyyy').format(endDate!)),
                          onPressed: () => _selectDate(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Time Range Filter
                  DropdownButtonFormField<String>(
                    value: selectedTimeRange,
                    decoration: InputDecoration(
                      labelText: 'Time Range',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: timeRanges.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedTimeRange = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: AppTheme.heading2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard('Music', Icons.music_note),
                        _buildCategoryCard('Sports', Icons.sports_soccer),
                        _buildCategoryCard('Art', Icons.palette),
                        _buildCategoryCard('Food', Icons.restaurant),
                        _buildCategoryCard('Tech', Icons.computer),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Events Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Events',
                        style: AppTheme.heading2,
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.map, color: AppTheme.primaryColor),
                        label: Text('View on Map', style: TextStyle(color: AppTheme.primaryColor)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MapScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return _buildEventCard(
                        event.title,
                        event.location,
                        'lib/images/dance.jpg',
                        event,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    final isSelected = selectedCategories.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategories.remove(title);
          } else {
            selectedCategories.add(title);
          }
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, 
              color: isSelected ? Colors.white : AppTheme.primaryColor, 
              size: 32
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppTheme.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String location, String imagePath, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(event)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                event.imageUrl ?? imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.heading3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: AppTheme.subtitleColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.subtitleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 