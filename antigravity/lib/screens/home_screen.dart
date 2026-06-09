import 'package:flutter/material.dart';
import '../models/elevator.dart';
import 'search_result_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final List<String> _recentQueries = ['신구대학교', '강남 파이낸스', '롯데월드타워'];

  void _search(String query) {
    final q = query.trim();
    if (q.isEmpty) return;

    final results = dummyElevators
        .where((e) =>
            e.buildingName.contains(q) ||
            e.address.contains(q) ||
            e.id.contains(q))
        .toList();

    setState(() {
      if (!_recentQueries.contains(q)) {
        _recentQueries.insert(0, q);
        if (_recentQueries.length > 5) _recentQueries.removeLast();
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(query: q, results: results),
      ),
    );
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
            const SizedBox(height: 32),
            const Text(
              '빠른 조회',
              style: TextStyle(
                color: Color(0xFF9198a1),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: dummyElevators.take(3).length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final e = dummyElevators[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailScreen(elevator: e)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0f3460).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: const Color(0xFF0f3460)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.elevator,
                              color: Color(0xFFe94560), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.buildingName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  e.address,
                                  style: const TextStyle(
                                      color: Color(0xFF9198a1),
                                      fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: e.isOperating
                                  ? const Color(0xFF3fb950).withOpacity(0.15)
                                  : const Color(0xFFf85149).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              e.isOperating ? '운행중' : '정지',
                              style: TextStyle(
                                color: e.isOperating
                                    ? const Color(0xFF3fb950)
                                    : const Color(0xFFf85149),
                                fontSize: 11,
                              ),
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
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;

  const _SearchBar({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: '건물명·주소·승강기 번호로 검색',
        hintStyle: const TextStyle(color: Color(0xFF9198a1)),
        prefixIcon:
            const Icon(Icons.search, color: Color(0xFF9198a1)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_forward,
              color: Color(0xFFe94560)),
          onPressed: () => onSearch(controller.text),
        ),
        filled: true,
        fillColor: const Color(0xFF0f3460).withOpacity(0.5),
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
