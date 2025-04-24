import 'package:flutter/material.dart';
import './Event.dart';
import '../theme/app_theme.dart';

class Detail extends StatefulWidget {
  final Event selectedEvent;

  const Detail(this.selectedEvent, {super.key});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  void _handleAdd() {
    // TODO: Implement favorites functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.selectedEvent.title} added to favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(widget.selectedEvent.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _handleAdd,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'lib/images/dance.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedEvent.title,
                    style: AppTheme.heading1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        widget.selectedEvent.location,
                        style: AppTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.selectedEvent.date} at ${widget.selectedEvent.time}',
                        style: AppTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: AppTheme.heading2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.selectedEvent.description,
                    style: AppTheme.bodyLarge,
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
