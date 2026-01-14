import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../favorites/favorites_page.dart';
import '../settings/settings_page.dart';
import 'quote_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  List quotes = [];
  Map? todayQuote;

  bool loading = true;
  String selectedCategory = 'All';
  String searchText = '';

  final categories = [
    'All',
    'Motivation',
    'Love',
    'Success',
    'Wisdom',
    'Humor',
  ];

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  Future<void> fetchAll() async {
    setState(() => loading = true);

    // 🔹 Quote of the day (deterministic, changes daily)
    final allQuotes = await supabase.from('quotes').select();
    final dayIndex =
        DateTime.now().difference(DateTime(2024)).inDays % allQuotes.length;

    todayQuote = allQuotes[dayIndex];

    // 🔹 Main feed
    var query = supabase.from('quotes').select();

    if (selectedCategory != 'All') {
      query = query.eq('category', selectedCategory);
    }

    if (searchText.isNotEmpty) {
      query = query.ilike('text', '%$searchText%');
    }

    final feedQuotes = await query.order('id');

    setState(() {
      quotes = feedQuotes;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = supabase.auth.currentUser!.id;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes ✨'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: fetchAll,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // 🌟 QUOTE OF THE DAY
            if (todayQuote != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quote of the Day',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        todayQuote!['text'],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 6),
                      Text('- ${todayQuote!['author']}'),
                    ],
                  ),
                ),
              ),

            // 🔍 SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search quotes...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) {
                  searchText = v;
                  fetchAll();
                },
              ),
            ),

            const SizedBox(height: 12),

            // 🏷 CATEGORIES
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (_) {
                        setState(() => selectedCategory = cat);
                        fetchAll();
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // 📜 FEED
            if (loading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (quotes.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No quotes found')),
              )
            else
              ...quotes.map(
                    (q) => QuoteCard(
                  quote: q,
                  userId: userId,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
