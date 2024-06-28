import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/new_service.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  List<dynamic> newsList = []; // Updated to hold dynamic news data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      var service = NewService();
      List<dynamic> newsData = await service.getAllNews();
      setState(() {
        newsList = newsData ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Hubo un error cargando noticias: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.newspaper_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle home button pressed
              },
            ),
            const SizedBox(width: 8.0),
            Text(
              'Noticias',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: isLoading || newsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                var newsItem = newsList[index];

                List<String> imageUrls = [];
                if (newsItem.containsKey('images')) {
                  for (var image in newsItem['images']) {
                    if (image != null && image['url'] != null) {
                      imageUrls.add(image['url']);
                    }
                  }
                }

                return GestureDetector(
                  onTap: () {

                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (imageUrls.isNotEmpty)
                          SizedBox(
                            height: 200, // Adjust image slider height as needed
                            child: PageView.builder(
                              itemCount: imageUrls.length,
                              itemBuilder: (context, imageIndex) {
                                return Image.network(
                                  imageUrls[imageIndex],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsItem['description'] ?? '', // Handle null description
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        newsItem['police-name'] ?? '', // Handle null police name
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.comment, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${newsItem['comments']?.length ?? 0}',
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.date_range, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(newsItem['date']), // Ensure date formatting function handles null
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
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
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchNews();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showCommentsDialog(Map<String, dynamic> newsItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Comentarios'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var comment in newsItem['comments'])
                ListTile(
                  leading: const Icon(Icons.person), // Icon next to commenter's name
                  title: Text(comment['text']),
                  subtitle: Text(
                    '${comment['user']['firstName']} ${comment['user']['lastName']}',
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(dateString));
  }
}