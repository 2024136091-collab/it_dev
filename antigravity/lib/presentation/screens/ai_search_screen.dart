import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/elevator_providers.dart';
import '../../application/providers/favorites_providers.dart';
import '../../domain/models/elevator.dart';
import 'detail_screen.dart';

class AiSearchScreen extends ConsumerStatefulWidget {
  const AiSearchScreen({super.key});

  @override
  ConsumerState<AiSearchScreen> createState() => _AiSearchScreenState();
}

class _AiSearchScreenState extends ConsumerState<AiSearchScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _isThinking = false;
  String? _aiDescription;
  List<Elevator> _results = [];
  late final AnimationController _dotController;

  static const _examples = [
    '오래된 승강기 찾아줘',
    '장애인 접근 가능한 승강기',
    '운행 정지된 승강기',
    '전망 좋은 엘리베이터',
    '병원 승강기만 보여줘',
    '화물용 승강기 알려줘',
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _dotController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runAiSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    setState(() {
      _isThinking = true;
      _aiDescription = null;
      _results = [];
    });
    final result = await ref.read(searchProvider.notifier).aiSearch(q);
    if (mounted) {
      setState(() {
        _isThinking = false;
        _aiDescription = result.description;
        _results = result.results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            const Text('스마트 자연어 검색'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7c3aed), Color(0xFFe94560)],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AiInputField(
                  controller: _controller,
                  onSearch: _runAiSearch,
                ),
                const SizedBox(height: 12),
                const Text(
                  '예시 질문',
                  style: TextStyle(color: Color(0xFF9198a1), fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _examples
                      .map((e) => _ExampleChip(
                            text: e,
                            onTap: () {
                              _controller.text = e;
                              _runAiSearch(e);
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF0f3460), height: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isThinking) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ThinkingDots(controller: _dotController),
            const SizedBox(height: 16),
            const Text(
              '키워드를 분석 중입니다...',
              style: TextStyle(color: Color(0xFF9198a1), fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_aiDescription == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology_outlined,
                color: Color(0xFF7c3aed), size: 56),
            SizedBox(height: 16),
            Text(
              '문장으로 승강기를 검색하세요.\n예: "오래된 승강기 찾아줘"',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9198a1), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7c3aed).withOpacity(0.15),
                const Color(0xFFe94560).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFF7c3aed).withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: Color(0xFF7c3aed), size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _aiDescription!,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '승강기 ${_results.length}대',
              style: const TextStyle(
                  color: Color(0xFF9198a1), fontSize: 13),
            ),
          ),
        ),
        Expanded(
          child: _results.isEmpty
              ? const Center(
                  child: Text('조건에 맞는 승강기가 없습니다.',
                      style: TextStyle(color: Color(0xFF9198a1))),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) =>
                      _AiResultCard(elevator: _results[i]),
                ),
        ),
      ],
    );
  }
}

class _AiInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;
  const _AiInputField({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: '"오래된 승강기 찾아줘" 처럼 질문해 보세요',
        hintStyle: const TextStyle(color: Color(0xFF9198a1), fontSize: 13),
        prefixIcon: const Icon(Icons.psychology, color: Color(0xFF7c3aed)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send, color: Color(0xFF7c3aed)),
          onPressed: () => onSearch(controller.text),
        ),
        filled: true,
        fillColor: const Color(0xFF0f3460).withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7c3aed)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: const Color(0xFF7c3aed).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7c3aed), width: 2),
        ),
      ),
      onSubmitted: onSearch,
    );
  }
}

class _ExampleChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _ExampleChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF7c3aed).withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFF7c3aed).withOpacity(0.4)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Color(0xFFb39ddb), fontSize: 12),
        ),
      ),
    );
  }
}

class _ThinkingDots extends StatelessWidget {
  final AnimationController controller;
  const _ThinkingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final scale = (0.5 +
                    0.5 *
                        (1 -
                            ((t - i / 3.0).abs() % 1.0)
                                .clamp(0.0, 1.0)))
                .clamp(0.5, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.lerp(const Color(0xFF7c3aed),
                        const Color(0xFFe94560), i / 2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _AiResultCard extends ConsumerWidget {
  final Elevator elevator;
  const _AiResultCard({required this.elevator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(elevator.id);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(elevator: elevator)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0f3460).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFF7c3aed).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF7c3aed).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.elevator,
                  color: Color(0xFF7c3aed), size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(elevator.buildingName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(children: [
                    _SmallTag(elevator.type),
                    const SizedBox(width: 6),
                    _SmallTag(elevator.region),
                    const SizedBox(width: 6),
                    _SmallTag(
                      elevator.isOperating ? '운행중' : '정지',
                      color: elevator.isOperating
                          ? const Color(0xFF3fb950)
                          : const Color(0xFFf85149),
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Text(elevator.id,
                      style: const TextStyle(
                          color: Color(0xFF9198a1), fontSize: 11)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFav ? Icons.star : Icons.star_border,
                color: const Color(0xFFe94560),
                size: 20,
              ),
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(elevator.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  final String text;
  final Color color;
  const _SmallTag(this.text, {this.color = const Color(0xFF9198a1)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10)),
    );
  }
}
