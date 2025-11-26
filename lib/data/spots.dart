class Spot {
  final int id;
  final String name;
  final String shortTagline;
  final String description;
  final String category; // "歴史", "景色", "市場" など
  final String area;     // 「港エリア」みたいな

  final String quizQuestion;
  final List<String> choices;
  final int answerIndex;
  final String explanation;

  Spot({
    required this.id,
    required this.name,
    required this.shortTagline,
    required this.description,
    required this.category,
    required this.area,
    required this.quizQuestion,
    required this.choices,
    required this.answerIndex,
    required this.explanation,
  });
}

final List<Spot> demoSpots = [
  Spot(
    id: 1,
    name: "港の展望台",
    shortTagline: "島と本土を一望できる絶景スポット",
    description:
        "島と本土を一望できる高台の展望スポット。昔は灯台として船の目印になり、多くの船乗りの命を守ってきました。",
    category: "景色・歴史",
    area: "港エリア",
    quizQuestion: "港の展望台が昔果たしていた役割は？",
    choices: [
      "市場として使われていた",
      "船の目印となる灯台",
      "嵐を予測する施設",
      "魚を育てる場所"
    ],
    answerIndex: 1,
    explanation: "港の展望台は、灯台として船の位置の目印になっていました。",
  ),
  Spot(
    id: 2,
    name: "古い神社",
    shortTagline: "航海と豊漁を祈る島のよりどころ",
    description:
        "島の人々が航海の安全と豊漁を祈る神社。祭りの日には島中から人が集まり、世代を超えてつながる場になっています。",
    category: "歴史・文化",
    area: "丘エリア",
    quizQuestion: "この神社で昔から祈られてきたこととして最も近いものは？",
    choices: ["受験合格", "航海の安全と豊漁", "健康祈願", "恋愛成就"],
    answerIndex: 1,
    explanation: "島では船の安全と漁の豊かさが特に祈られてきました。",
  ),
  Spot(
    id: 3,
    name: "島の市場通り",
    shortTagline: "観光客と地元がまじわる朝市ストリート",
    description:
        "朝市が開かれ、地元の魚や野菜が並ぶにぎやかな通り。観光客と地元の人が自然に言葉を交わす、島ならではの交流の場です。",
    category: "市場・交流",
    area: "中心エリア",
    quizQuestion: "市場通りの特徴として最も適切なのはどれ？",
    choices: [
      "工場が並ぶ静かな通り",
      "観光客と地元の人が交流する場所",
      "車しか通れない幹線道路",
      "夜だけ開くナイトマーケット"
    ],
    answerIndex: 1,
    explanation: "島の市場通りは、観光客と地元の人が行き交う交流の場になっています。",
  ),
];