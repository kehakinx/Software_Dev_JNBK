import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Closet Wishlist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WishlistPage(),
    );
  }
}

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<WishlistItem> _wishlistItems = [
    WishlistItem(
      name: 'Vintage Leather Jacket',
      description: 'Classic brown leather jacket',
    ),
    WishlistItem(
      name: 'Designer Sneakers',
      description: 'Limited edition white sneakers',
    ),
    WishlistItem(
      name: 'Cashmere Scarf',
      description: 'Soft grey cashmere scarf',
    ),
  ];

  void _addNewItem() {
    if (_itemNameController.text.isNotEmpty) {
      setState(() {
        _wishlistItems.add(
          WishlistItem(
            name: _itemNameController.text,
            description: _descriptionController.text,
          ),
        );
        _itemNameController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _wishlistItems.removeAt(index);
    });
  }

  void _markAsPurchased(int index) {
    setState(() {
      // In a real app, you might move this to a "purchased" list
      _wishlistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Closet Wishlist'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add New Item Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Item',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _itemNameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'e.g., Blue Denim Jeans',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'e.g., High-waisted, straight leg',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addNewItem,
                      child: const Text('Add to Wishlist'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // My Wishlist Items Section
            const Text(
              'My Wishlist Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _wishlistItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = _wishlistItems[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: item.description.isNotEmpty
                      ? Text(item.description)
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _markAsPurchased(index),
                        tooltip: 'Mark as Purchased',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(index),
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WishlistItem {
  final String name;
  final String description;

  WishlistItem({
    required this.name,
    this.description = '',
  });
}