import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final supabase = Supabase.instance.client;
  List favorites = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    setState(() => loading = true);

    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('user_favorites')
        .select('id, quotes(id, text, author, category)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    setState(() {
      favorites = data;
      loading = false;
    });
  }

  Future<void> removeFavorite(String favoriteId) async {
    await supabase
        .from('user_favorites')
        .delete()
        .eq('id', favoriteId);

    fetchFavorites(); // 🔁 refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites ❤️'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchFavorites,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : favorites.isEmpty
            ? const Center(
          child: Text(
            'No favorites yet ✨',
            style: TextStyle(fontSize: 16),
          ),
        )
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: favorites.length,
          itemBuilder: (_, i) {
            final fav = favorites[i];
            final quote = fav['quotes'];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          quote['category'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '“${quote['text']}”',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '- ${quote['author']}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            removeFavorite(fav['id']),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
