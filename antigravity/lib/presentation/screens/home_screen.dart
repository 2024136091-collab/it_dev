import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/elevator_providers.dart';
import 'search_result_screen.dart';
import 'favorites_screen.dart';
import 'ai_search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();
  final List<String> _recentQueries = ['신구대학교', '강남 파이낸스', '롯데월드타워'];

  Future<void> _search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    await ref.read(searchProvider.notifier).search(q);

    setState(() {
      if (!_recentQueries.contains(q)) {
        _recentQueries.insert(0, q);
        if (_recentQueries.length > 5) _recentQueries.removeLast();
      }
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SearchResultScreen(query: q)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        title: const Text(
          '승강기 정보검색',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Color(0xFFe94560)),
            tooltip: '즐겨찾기',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFe94560)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(controller: _controller, onSearch: _search),
            const SizedBox(height: 12),
            _AiSearchButton(onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AiSearchScreen()),
            )),
            const SizedBox(height: 32),
            const Text(
              '최근 조회',
              style: TextStyle(
                color: Color(0xFF9198a1),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._recentQueries.map((q) => _RecentItem(
                  query: q,
                  onTap: () {
                    _controller.text = q;
                    _search(q);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Future<void> Function(String) onSearch;

  const _SearchBar({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: '건물명·주소·승강기 번호로 검색',
        hintStyle: const TextStyle(color: Color(0xFF9198a1)),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF9198a1)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Color(0xFFe94560)),
          onPressed: () => onSearch(controller.text),
        ),
        filled: true,
        fillColor: const Color(0xFF0f3460).withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0f3460)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0f3460)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFe94560)),
        ),
      ),
      onSubmitted: onSearch,
    );
  }
}

class _AiSearchButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AiSearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF7c3aed).withValues(alpha: 0.15),
              const Color(0xFFe94560).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFF7c3aed).withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7c3aed), Color(0xFFe94560)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'AI',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '"오래된 승강기 찾아줘" 처럼 문장으로 검색',
                style:
                    TextStyle(color: Color(0xFFb39ddb), fontSize: 13),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Color(0xFF7c3aed), size: 14),
          ],
        ),
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final String query;
  final VoidCallback onTap;

  const _RecentItem({required this.query, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.history, color: Color(0xFF9198a1), size: 16),
            const SizedBox(width: 10),
            Text(query,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
