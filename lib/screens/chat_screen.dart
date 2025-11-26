import 'package:flutter/material.dart';
import 'package:tttf_demo_app/data/spots.dart';
import 'package:tttf_demo_app/theme/app_theme.dart';
import 'package:tttf_demo_app/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final Spot spot;
  final List<Spot> visitedSpots;

  const ChatScreen({
    super.key,
    required this.spot,
    required this.visitedSpots,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController controller = TextEditingController();
  bool quizShown = false;

  @override
  void initState() {
    super.initState();
    _addInitialBotMessage();
  }

  void _addInitialBotMessage() {
    final intro =
        "ようこそ「${widget.spot.name}」へ。\n"
        "簡単に説明したあと、この場所にちなんだクイズも出します。\n\n"
        "「歴史を教えて」「雰囲気は？」「次どこがおすすめ？」など、自由に聞いてみてください。";
    messages.add({"text": intro, "user": false});
  }

  void sendMessage(String? preset) {
    final text = preset ?? controller.text.trim();
    if (text.isEmpty) return;
    controller.clear();

    setState(() {
      messages.add({"text": text, "user": true});
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      final reply = _generateBotReply(text);
      setState(() {
        messages.add({"text": reply, "user": false});
      });
      _showQuizIfNeeded();
    });
  }

  String _generateBotReply(String userText) {
    final spot = widget.spot;
    final lower = userText.toLowerCase();

    if (lower.contains("歴史") || lower.contains("history")) {
      return "歴史の話ですね。\n\n${spot.description}\n\nこの場所が今も残っていること自体が、島の人たちが大事に守ってきた証拠なんです。";
    }

    if (lower.contains("雰囲気") || lower.contains("feel") || lower.contains("どんなところ")) {
      return "雰囲気としては、\n\n・${spot.shortTagline}\n・カテゴリ：${spot.category}\n・エリア：${spot.area}\n\n人の多さや時間帯によっても印象が変わるスポットです。";
    }

    if (lower.contains("おすすめ") || lower.contains("次") || lower.contains("どこ")) {
      final others = widget.visitedSpots.isEmpty
          ? demoSpots
          : demoSpots.where((s) => s.id != spot.id).toList();
      final next = others.isNotEmpty ? others.first : spot;

      return "次に行くなら「${next.name}」もおすすめです。\n\n${next.shortTagline}\n\n実際のアプリでは、あなたの歩いたログから混雑状況や時間帯に合わせておすすめを出せるようにするイメージです。";
    }

    return "いい質問ですね。\n\n${spot.description}\n\nざっくり言うと、ここは「${spot.shortTagline}」という特徴を持った場所です。"
        "\n\nこのあと、この説明をもとにクイズも出します。";
  }

  void _showQuizIfNeeded() {
    if (quizShown) return;
    quizShown = true;

    final q = widget.spot;
    setState(() {
      messages.add({"text": "Q. ${q.quizQuestion}", "user": false});
    });
  }

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;

    return Scaffold(
      appBar: AppBar(
        title: Text(spot.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                "訪問:${widget.visitedSpots.length}箇所",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2FE), Color(0xFFF9FAFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 上部のサマリー
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                        ),
                        child: const Icon(Icons.smart_toy,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          spot.shortTagline,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // チャットウィンドウ
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    return ChatBubble(
                      text: msg["text"],
                      isUser: msg["user"],
                    );
                  },
                ),
              ),

              // クイズUI
              if (quizShown) _buildQuizArea(spot),

              // 入力欄
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizArea(Spot spot) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "選択肢を選んでください",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: List.generate(spot.choices.length, (i) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                onPressed: () {
                  final correct = i == spot.answerIndex;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(correct ? "正解！" : "不正解…"),
                      content: Text(spot.explanation),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  "${String.fromCharCode(65 + i)}. ${spot.choices[i]}",
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // クイックリプライ
          Row(
            children: [
              _QuickChip(
                label: "歴史を教えて",
                onTap: () => sendMessage("この場所の歴史を教えて"),
              ),
              const SizedBox(width: 8),
              _QuickChip(
                label: "雰囲気は？",
                onTap: () => sendMessage("この場所の雰囲気は？"),
              ),
              const SizedBox(width: 8),
              _QuickChip(
                label: "次のおすすめ",
                onTap: () => sendMessage("次におすすめのスポットは？"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "聞きたいことを入力…",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  onPressed: () => sendMessage(null),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }
}