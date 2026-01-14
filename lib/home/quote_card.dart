import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuoteCard extends StatefulWidget {
  final Map quote;
  final String userId;

  const QuoteCard({super.key, required this.quote, required this.userId});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final supabase = Supabase.instance.client;
  bool fav = false;

  @override
  void initState() {
    super.initState();
    checkFav();
  }

  Future<void> checkFav() async {
    final res = await supabase
        .from('user_favorites')
        .select()
        .eq('user_id', widget.userId)
        .eq('quote_id', widget.quote['id'])
        .maybeSingle();
    setState(() => fav = res != null);
  }

  Future<void> toggleFav() async {
    if (fav) {
      await supabase.from('user_favorites').delete().eq('quote_id', widget.quote['id']);
    } else {
      await supabase.from('user_favorites').insert({
        'user_id': widget.userId,
        'quote_id': widget.quote['id'],
      });
    }
    setState(() => fav = !fav);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.quote['text'], style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('- ${widget.quote['author']}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: toggleFav,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share('"${widget.quote['text']}" — ${widget.quote['author']}');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
