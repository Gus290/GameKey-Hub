import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const GameKeyApp());

const bg = Color(0xFF0C1020);
const panel = Color(0xFF181D31);
const purple = Color(0xFF9B7BFF);

class Game {
  final String title, platform, description, imagePath;
  final List<String> keys;

  Game(this.title, this.platform, this.description, this.imagePath, this.keys);

  List<String> get screenshots {
    final base = imagePath.replaceFirst('.jpg', '');

    return [
      imagePath,
      for (int i = 2; i <= 5; i++) '${base}_$i.jpg',
    ];
  }
}

  

class GameKeyApp extends StatelessWidget {
  const GameKeyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GameKey Hub',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(primary: purple, surface: panel),
      appBarTheme: const AppBarTheme(backgroundColor: bg, centerTitle: false),
    ),
    home: const GameHome(),
  );
}

class GameHome extends StatefulWidget {
  const GameHome({super.key});
  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  int tab = 0;
  final games = <Game>[
    Game('The Blood of Dawnwalker', 'Steam', 'เกมแอ็กชัน RPG ดาร์กแฟนตาซีในโลกของแวมไพร์', 'assets/images/dawnwalker.jpg', ['DEMO-DAWN-0001', 'DEMO-DAWN-0002', 'DEMO-DAWN-0003']),
    Game('Onimusha: Way of the Sword — Deluxe Edition', 'Steam', 'เกมแอ็กชันซามูไร ต่อสู้กับเหล่าปีศาจ', 'assets/images/onimusha.jpg', ['DEMO-ONIMUSHA-0001', 'DEMO-ONIMUSHA-0002']),
    Game('Monster Hunter Wilds', 'Steam', 'ออกล่าเหล่ามอนสเตอร์ในดินแดนกว้างใหญ่', 'assets/images/monster_hunter_wilds.jpg', ['DEMO-MHWILDS-0001']),
  ];
  final Map<String, String> claimed = {};

  void claim(Game game) {
    if (claimed.containsKey(game.title)) {
      showKey(game.title, claimed[game.title]!);
      return;
    }
    if (game.keys.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('คีย์เกมนี้หมดแล้ว')),
      );
      return;
    }
    final key = game.keys.removeAt(0);
    setState(() => claimed[game.title] = key);
    showKey(game.title, key);
  }

  void showKey(String title, String key) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: panel,
        title: const Text('🎉 รับคีย์สำเร็จ!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 14),
            SelectableText(key, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: purple)),
            const SizedBox(height: 10),
            const Text('คีย์นี้เป็น DEMO สำหรับทดสอบเท่านั้น', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: key));
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('คัดลอกคีย์แล้ว')));
            },
            child: const Text('คัดลอกคีย์'),
          ),
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('ปิด')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('◈ GAMEKEY HUB', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1))),
    body: SafeArea(child: tab == 0 ? homeView() : keysView()),
    bottomNavigationBar: NavigationBar(
      selectedIndex: tab,
      onDestinationSelected: (i) => setState(() => tab = i),
      backgroundColor: panel,
      indicatorColor: purple.withValues(alpha: .25),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.sports_esports_outlined), selectedIcon: Icon(Icons.sports_esports), label: 'รับคีย์เกม'),
        NavigationDestination(icon: Icon(Icons.key_outlined), selectedIcon: Icon(Icons.key), label: 'คีย์ของฉัน'),
      ],
    ),
  );

  Widget homeView() => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF3A2B68), Color(0xFF182B45)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('✦ FREE GAME KEY GIVEAWAYS', style: TextStyle(color: Color(0xFFCDB8FF), fontSize: 12, letterSpacing: 1)),
          SizedBox(height: 10),
          Text('เกมดี ๆ รับฟรี\nได้ที่นี่ 🎮', style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold, height: 1.3)),
          SizedBox(height: 10),
          Text('เลือกเกมที่ชอบ แล้วกดรับคีย์ได้ทันที', style: TextStyle(color: Colors.white70)),
        ]),
      ),
      const SizedBox(height: 26),
      const Text('เกมที่กำลังแจก', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      ...games.map(gameCard),
      const SizedBox(height: 16),
      const Text('หมายเหตุ: นี่คือแอป DEMO คีย์ใช้เปิดเกมจริงไม่ได้ และข้อมูลจะรีเซ็ตเมื่อปิดแอป', style: TextStyle(color: Colors.white54, fontSize: 12)),
    ],
  );
void openGameDetail(Game game) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GameDetailPage(
        game: game,
        onClaim: () => claim(game),
        isClaimed: () => claimed.containsKey(game.title),
      ),
    ),
  ).then((_) {
    if (mounted) setState(() {});
  });
}
  Widget gameCard(Game game) {
    final hasClaimed = claimed.containsKey(game.title);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
  onTap: () => openGameDetail(game),
  child: Image.asset(
    game.imagePath,
    height: 180,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => const SizedBox(
      height: 180,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: Colors.white54,
        ),
      ),
    ),
  ),
),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(game.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              Text(game.platform, style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ]),
            const SizedBox(height: 5),
            Text(game.description, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(child: Text(hasClaimed ? '✓ รับแล้ว' : 'คีย์คงเหลือ ${game.keys.length}', style: TextStyle(color: hasClaimed ? Colors.greenAccent : Colors.white70, fontSize: 13))),
              FilledButton(
                onPressed: hasClaimed || game.keys.isNotEmpty ? () => claim(game) : null,
                child: Text(hasClaimed ? 'ดูคีย์' : game.keys.isEmpty ? 'คีย์หมด' : 'รับคีย์ฟรี'),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget keysView() => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const Text('คีย์ของฉัน', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      if (claimed.isEmpty)
        const Card(child: Padding(padding: EdgeInsets.all(28), child: Text('ยังไม่มีคีย์ที่ได้รับ\nกลับไปหน้าแรกเพื่อรับคีย์เกม', textAlign: TextAlign.center))),
      ...claimed.entries.map((e) => Card(child: ListTile(
        leading: const Icon(Icons.vpn_key, color: purple),
        title: Text(e.key),
        subtitle: SelectableText(e.value),
        trailing: IconButton(icon: const Icon(Icons.visibility_outlined), onPressed: () => showKey(e.key, e.value)),
      ))),
    ],
  );
}
class GameDetailPage extends StatefulWidget {
  final Game game;
  final VoidCallback onClaim;
  final bool Function() isClaimed;

  const GameDetailPage({
    super.key,
    required this.game,
    required this.onClaim,
    required this.isClaimed,
  });

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
final images = game.screenshots;
final hasClaimed = widget.isClaimed();

    return Scaffold(
      appBar: AppBar(title: const Text('รายละเอียดเกม')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          GestureDetector(
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => GameGalleryPage(
                  images: images,
                  initialIndex: selectedImage,
                ),
              ),
            ),
            child: _detailImage(images[selectedImage], 230),
          ),
          Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'ภาพตัวอย่างเกม',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        '${selectedImage + 1} / ${images.length}',
        style: const TextStyle(
          color: purple,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),
          const SizedBox(height: 12),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) => InkWell(
                onTap: () => setState(() => selectedImage = index),
                child: Container(
                  width: 128,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedImage == index ? purple : Colors.white24,
                      width: 2,
                    ),
                  ),
                  child: _detailImage(images[index], 88),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.title,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(game.description,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                const Text('เกี่ยวกับเกม',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(_gameDetails(game.title),
                    style: const TextStyle(
                        fontSize: 15, height: 1.6, color: Colors.white70)),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _infoRow('แพลตฟอร์ม', game.platform),
                      const Divider(color: Colors.white12),
                      _infoRow('ประเภทเกม', _gameGenre(game.title)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text('แตะรูปใหญ่เพื่อเปิดแกลเลอรีและเลื่อนดูรูป',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 12),
                const Text('คีย์ทั้งหมดเป็น DEMO ไม่สามารถใช้เปิดเกมจริงได้',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: panel,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hasClaimed ? '✓ รับแล้ว' : 'คีย์คงเหลือ ${game.keys.length}',
                  style: TextStyle(
                    color: hasClaimed ? Colors.greenAccent : Colors.white70,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: hasClaimed || game.keys.isNotEmpty
                    ? () {
                        widget.onClaim();
                        setState(() {});
                      }
                    : null,
                icon: Icon(hasClaimed ? Icons.visibility : Icons.vpn_key),
                label: Text(hasClaimed
                    ? 'ดูคีย์'
                    : game.keys.isEmpty
                        ? 'คีย์หมด'
                        : 'รับ DEMO Key'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailImage(String path, double height) => Image.asset(
        path,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: height,
          color: panel,
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_outlined,
              color: Colors.white54, size: 40),
        ),
      );

  Widget _infoRow(String label, String value) => Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(label,
                style: const TextStyle(color: Colors.white54)),
          ),
          Expanded(child: Text(value)),
        ],
      );

  String _gameGenre(String title) {
    if (title.contains('Dawnwalker')) return 'Action RPG / Dark Fantasy';
    if (title.contains('Onimusha')) return 'Action / Samurai';
    return 'Action RPG / Hunting';
  }

  String _gameDetails(String title) {
    if (title.contains('Dawnwalker')) {
      return 'The Blood of Dawnwalker เป็นเกมแอ็กชัน RPG แนวดาร์กแฟนตาซี '
          'สำรวจโลกที่เต็มไปด้วยแวมไพร์และการตัดสินใจที่ส่งผลต่อการผจญภัย';
    }
    if (title.contains('Onimusha')) {
      return 'Onimusha: Way of the Sword เป็นเกมแอ็กชันต่อสู้ด้วยดาบซามูไร '
          'เผชิญหน้ากับศัตรูเหนือธรรมชาติในบรรยากาศญี่ปุ่นแฟนตาซี';
    }
    return 'Monster Hunter Wilds เป็นเกม Action RPG ที่เน้นการล่ามอนสเตอร์ '
        'สำรวจธรรมชาติ รวบรวมวัตถุดิบ และสร้างอุปกรณ์สำหรับการล่าครั้งต่อไป';
  }
}

class GameGalleryPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const GameGalleryPage({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<GameGalleryPage> createState() => _GameGalleryPageState();
}

class _GameGalleryPageState extends State<GameGalleryPage> {
  late final PageController controller;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    controller = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('${currentIndex + 1} / ${widget.images.length}'),
        ),
        body: PageView.builder(
          controller: controller,
          itemCount: widget.images.length,
          onPageChanged: (index) => setState(() => currentIndex = index),
          itemBuilder: (context, index) => InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: Image.asset(
                widget.images[index],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Text(
                  'ยังไม่มีรูปภาพนี้',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
        ),
      );
}


