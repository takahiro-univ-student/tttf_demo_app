import 'package:flutter/material.dart';
import 'package:tttf_demo_app/data/spots.dart';
import 'package:tttf_demo_app/screens/chat_screen.dart';
import 'package:tttf_demo_app/theme/app_theme.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  Spot? selectedSpot;
  final List<Spot> visitedSpots = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("スポットにチェックイン"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "どこから巡りますか？",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "タップしてチェックインすると、その場所専用のストーリーとクイズが届きます。",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              // スポット一覧
              Expanded(
                child: ListView.builder(
                  itemCount: demoSpots.length,
                  itemBuilder: (context, i) {
                    final spot = demoSpots[i];
                    final isSelected = selectedSpot?.id == spot.id;
                    final isVisited =
                        visitedSpots.any((s) => s.id == spot.id);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSpot = spot;
                          if (!isVisited) {
                            visitedSpots.add(spot);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(Icons.place,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    spot.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    spot.shortTagline,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      _MiniChip(label: spot.category),
                                      const SizedBox(width: 6),
                                      _MiniChip(label: spot.area),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (isVisited)
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // 訪問状況
              Text(
                visitedSpots.isEmpty
                    ? "まだ訪問スポットはありません。"
                    : "訪問スポット：${visitedSpots.length} 箇所",
                style: TextStyle(
                    fontSize: 12,
                    color: visitedSpots.isEmpty
                        ? Colors.grey[500]
                        : AppColors.primary),
              ),
              const SizedBox(height: 8),

              Center(
                child: ElevatedButton.icon(
                  onPressed: selectedSpot == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                spot: selectedSpot!,
                                visitedSpots: visitedSpots,
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("このスポットのガイドを見る"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;

  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.black54),
      ),
    );
  }
}