import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color _primary = Color(0xFF5CC8CC);
const Color _primaryDark = Color(0xFF2A9DA1);
const Color _lightCyan = Color(0xFFC8F1F3);
const Color _text = Color(0xFF202124);

/// Maksimal chat yang boleh dipin.
const int kMaxPinned = 3;

// ───────────────────────── MODEL ─────────────────────────

class Contact {
  final String id;
  final String name;
  final String phone;

  const Contact({required this.id, required this.name, required this.phone});
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  /// Nama pengirim (dipakai di grup untuk pesan dari orang lain).
  final String? sender;

  ChatMessage({
    required this.text,
    required this.isMe,
    DateTime? time,
    this.sender,
  }) : time = time ?? DateTime.now();
}

class ChatItem {
  final String id;
  final String name;
  final bool isGroup;

  /// Id kontak. Chat personal berisi 1 id, grup berisi banyak id.
  final List<String> memberIds;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  int unread;
  bool isPinned;
  bool isFavorite;

  ChatItem({
    required this.id,
    required this.name,
    required this.memberIds,
    this.isGroup = false,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    this.unread = 0,
    this.isPinned = false,
    this.isFavorite = false,
  })  : messages = messages ?? [],
        createdAt = createdAt ?? DateTime.now();

  DateTime get lastTime => messages.isEmpty ? createdAt : messages.last.time;

  String get preview {
    if (messages.isEmpty) return isGroup ? 'Grup dibuat' : 'Mulai percakapan';
    final m = messages.last;
    if (!isGroup) return m.text;
    final who = m.isMe ? 'Kamu' : m.sender;
    return who == null ? m.text : '$who: ${m.text}';
  }
}

/// Filter buatan pengguna: nama + chat apa saja yang masuk.
class CustomFilter {
  final String id;
  String name;
  Set<String> chatIds;

  CustomFilter({required this.id, required this.name, required this.chatIds});
}

// ───────────────────────── STORE ─────────────────────────
// Satu sumber data untuk semua halaman chat.
// Nanti tinggal diganti dengan API / Firebase.

class ChatStore extends ChangeNotifier {
  final List<Contact> _contacts = [];
  final List<ChatItem> _chats = [];
  final List<CustomFilter> _filters = [];
  final Random _rand = Random();

  String? activeChatId;
  int _idSeq = 100;
  bool _disposed = false;

  ChatStore() {
    _seed();
  }

  String _newId() => 'id${_idSeq++}';

  void _seed() {
    final now = DateTime.now();
    ChatMessage m(String t, Duration ago, {bool me = false, String? sender}) =>
        ChatMessage(text: t, isMe: me, time: now.subtract(ago), sender: sender);

    _contacts.addAll(const [
      Contact(id: 'c1', name: 'Budi - Web Developer', phone: '+6281234567801'),
      Contact(id: 'c2', name: 'Sari Design Studio', phone: '+6281234567802'),
      Contact(id: 'c3', name: 'CyberSafe ID', phone: '+6281234567803'),
      Contact(id: 'c4', name: 'Rina Digital Marketing', phone: '+6281234567804'),
      Contact(id: 'c5', name: 'Admin MikroHub', phone: '+6281234567805'),
      Contact(id: 'c6', name: 'Toko Kopi Nusantara', phone: '+6281234567806'),
    ]);

    _chats.addAll([
      ChatItem(
        id: 'chat1',
        name: 'Budi - Web Developer',
        memberIds: ['c1'],
        unread: 2,
        messages: [
          m('Halo, saya butuh website toko online', const Duration(hours: 3), me: true),
          m('Siap kak, boleh share referensi desainnya?', const Duration(minutes: 40)),
        ],
      ),
      ChatItem(
        id: 'chat2',
        name: 'Sari Design Studio',
        memberIds: ['c2'],
        isFavorite: true,
        messages: [
          m('Logo revisi sudah saya kirim ya', const Duration(hours: 5)),
          m('Terima kasih kak, bagus!', const Duration(hours: 4), me: true),
        ],
      ),
      ChatItem(
        id: 'chat3',
        name: 'CyberSafe ID',
        memberIds: ['c3'],
        messages: [
          m('Audit keamanan selesai, laporan terlampir.',
              const Duration(days: 1, hours: 2)),
        ],
      ),
      ChatItem(
        id: 'chat4',
        name: 'Rina Digital Marketing',
        memberIds: ['c4'],
        unread: 1,
        messages: [
          m('Paket promo Instagram Ads masih tersedia kak', const Duration(days: 2)),
        ],
      ),
      ChatItem(
        id: 'chat5',
        name: 'Admin MikroHub',
        memberIds: ['c5'],
        messages: [
          m('Selamat datang di MikroHub UMKM!', const Duration(days: 5)),
        ],
      ),
      ChatItem(
        id: 'chat6',
        name: 'Toko Kopi Nusantara',
        memberIds: ['c6'],
        messages: [
          m('Kapan bisa mulai pembuatan aplikasinya?', const Duration(days: 7), me: true),
        ],
      ),
      ChatItem(
        id: 'group1',
        name: 'Proyek Toko Kopi',
        isGroup: true,
        memberIds: ['c1', 'c2', 'c6'],
        unread: 3,
        messages: [
          m('Desain halaman utama sudah siap', const Duration(hours: 1),
              sender: 'Sari Design Studio'),
          m('Oke, saya mulai coding besok', const Duration(minutes: 25),
              sender: 'Budi - Web Developer'),
        ],
      ),
    ]);
  }

  // ── Getter ──

  List<Contact> get contacts {
    final list = [..._contacts];
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  List<CustomFilter> get filters => List.unmodifiable(_filters);

  /// Pin di atas, lalu pesan terbaru di atas.
  List<ChatItem> get sorted {
    final list = [..._chats];
    list.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.lastTime.compareTo(a.lastTime);
    });
    return list;
  }

  int get pinnedCount => _chats.where((c) => c.isPinned).length;
  int get unreadChats => _chats.where((c) => c.unread > 0).length;

  ChatItem byId(String id) => _chats.firstWhere((c) => c.id == id);

  Contact? contactById(String id) {
    for (final c in _contacts) {
      if (c.id == id) return c;
    }
    return null;
  }

  Contact? contactByPhone(String phone) {
    for (final c in _contacts) {
      if (c.phone == phone) return c;
    }
    return null;
  }

  CustomFilter? filterById(String id) {
    for (final f in _filters) {
      if (f.id == id) return f;
    }
    return null;
  }

  /// Teks kecil di bawah nama pada ruang chat.
  String subtitleFor(ChatItem chat) {
    if (chat.isGroup) {
      final names = chat.memberIds
          .map((id) => contactById(id)?.name)
          .whereType<String>()
          .toList();
      return ['Kamu', ...names].join(', ');
    }
    return contactById(chat.memberIds.first)?.phone ?? '';
  }

  // ── Telepon ──

  /// "0812-3456-7890" -> "+6281234567890". Return null kalau tidak valid.
  static String? normalizePhone(String input) {
    var s = input.trim().replaceAll(RegExp(r'[\s\-().]'), '');
    if (s.startsWith('+')) {
      s = s.substring(1);
    } else if (s.startsWith('0')) {
      s = '62${s.substring(1)}';
    }
    if (!RegExp(r'^\d{9,15}$').hasMatch(s)) return null;
    return '+$s';
  }

  // ── Aksi chat ──

  /// Return false kalau melebihi batas pin.
  bool togglePin(String id) {
    final chat = byId(id);
    if (!chat.isPinned && pinnedCount >= kMaxPinned) return false;
    chat.isPinned = !chat.isPinned;
    notifyListeners();
    return true;
  }

  void toggleFavorite(String id) {
    final chat = byId(id);
    chat.isFavorite = !chat.isFavorite;
    notifyListeners();
  }

  /// Set daftar favorit sekaligus: chat di [ids] jadi favorit, sisanya tidak.
  void setFavorites(Set<String> ids) {
    for (final c in _chats) {
      c.isFavorite = ids.contains(c.id);
    }
    notifyListeners();
  }

  void markRead(String id) {
    byId(id).unread = 0;
    notifyListeners();
  }

  void send(String id, String text) {
    byId(id).messages.add(ChatMessage(text: text, isMe: true));
    notifyListeners();
  }

  void receive(String id, String text, {String? sender}) {
    final chat = byId(id);
    chat.messages.add(ChatMessage(text: text, isMe: false, sender: sender));
    if (activeChatId != id) chat.unread++;
    notifyListeners();
  }

  static const _replies = [
    'Baik kak, saya cek dulu ya.',
    'Siap, nanti saya kabari lagi.',
    'Terima kasih infonya kak!',
    'Boleh, kita lanjut besok ya.',
    'Oke noted kak.',
  ];

  /// Balasan otomatis (simulasi). Hapus kalau sudah pakai backend.
  void autoReply(String id) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_disposed) return;
      final chat = byId(id);
      String? sender;
      if (chat.isGroup && chat.memberIds.isNotEmpty) {
        final pick = chat.memberIds[_rand.nextInt(chat.memberIds.length)];
        sender = contactById(pick)?.name;
      }
      receive(id, _replies[_rand.nextInt(_replies.length)], sender: sender);
    });
  }

  // ── Kontak & grup ──

  /// Simpan kontak baru sekaligus membuat chat personalnya.
  /// [phone] harus sudah dinormalisasi lewat [normalizePhone].
  ChatItem addContact(String name, String phone) {
    final contact = Contact(id: _newId(), name: name.trim(), phone: phone);
    _contacts.add(contact);
    final chat = ChatItem(
      id: _newId(),
      name: contact.name,
      memberIds: [contact.id],
    );
    _chats.add(chat);
    notifyListeners();
    return chat;
  }

  ChatItem createGroup(String name, List<String> memberIds) {
    final chat = ChatItem(
      id: _newId(),
      name: name.trim(),
      isGroup: true,
      memberIds: List.of(memberIds),
    );
    _chats.add(chat);
    notifyListeners();
    return chat;
  }

  // ── Filter buatan sendiri ──

  CustomFilter addFilter(String name, Set<String> chatIds) {
    final f = CustomFilter(id: _newId(), name: name.trim(), chatIds: {...chatIds});
    _filters.add(f);
    notifyListeners();
    return f;
  }

  void updateFilter(String id, String name, Set<String> chatIds) {
    final f = filterById(id);
    if (f == null) return;
    f.name = name.trim();
    f.chatIds = {...chatIds};
    notifyListeners();
  }

  void deleteFilter(String id) {
    _filters.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  // ── Lifecycle ──

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

// ───────────────────────── HELPER ─────────────────────────

String _two(int n) => n.toString().padLeft(2, '0');

String formatChatTime(DateTime t) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(t.year, t.month, t.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return '${_two(t.hour)}:${_two(t.minute)}';
  if (diff == 1) return 'Kemarin';
  return '${_two(t.day)}/${_two(t.month)}/${_two(t.year % 100)}';
}

class _ChatAvatar extends StatelessWidget {
  final String name;
  final bool isGroup;
  final double radius;

  const _ChatAvatar({
    required this.name,
    this.isGroup = false,
    this.radius = 26,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    return CircleAvatar(
      radius: radius,
      backgroundColor: _lightCyan,
      child: isGroup
          ? Icon(Icons.groups_rounded, color: _primary, size: radius)
          : Text(
              trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase(),
              style: TextStyle(
                color: _primary,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.7,
              ),
            ),
    );
  }
}

// ───────────────────────── HALAMAN DAFTAR CHAT ─────────────────────────

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static const Color primaryColor = _primary;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatStore _store = ChatStore();
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  /// 'all' | 'unread' | 'favorite' | 'group' | id filter buatan sendiri
  String _filter = 'all';

  @override
  void dispose() {
    _searchCtrl.dispose();
    _store.dispose();
    super.dispose();
  }

  // ── Data tampilan ──

  List<ChatItem> _filtered() {
    final q = _query.trim().toLowerCase();

    late bool Function(ChatItem) matches;
    switch (_filter) {
      case 'all':
        matches = (_) => true;
        break;
      case 'unread':
        matches = (c) => c.unread > 0;
        break;
      case 'favorite':
        matches = (c) => c.isFavorite;
        break;
      case 'group':
        matches = (c) => c.isGroup;
        break;
      default:
        {
          final ids = _store.filterById(_filter)?.chatIds ?? <String>{};
          matches = (c) => ids.contains(c.id);
        }
    }

    return _store.sorted.where((c) {
      if (!matches(c)) return false;
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.preview.toLowerCase().contains(q);
    }).toList();
  }

  // ── Navigasi & aksi ──

  void _openRoom(ChatItem chat) {
    _store.markRead(chat.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoomPage(store: _store, chatId: chat.id),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _togglePin(ChatItem chat) {
    if (!_store.togglePin(chat.id)) {
      _snack('Maksimal $kMaxPinned chat yang bisa dipin');
    }
  }

  Future<void> _addFriend() async {
    final chat = await showDialog<ChatItem>(
      context: context,
      builder: (_) => _AddContactDialog(store: _store),
    );
    if (chat != null && mounted) _openRoom(chat);
  }

  void _createGroup() {
    if (_store.contacts.length < 2) {
      _snack('Tambahkan minimal 2 teman dulu untuk membuat grup');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateGroupPage(store: _store)),
    );
  }

  Future<void> _openFilterEditor([CustomFilter? existing]) async {
    final id = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => FilterEditorPage(store: _store, existing: existing),
      ),
    );
    if (id != null && mounted) setState(() => _filter = id);
  }

  void _pickFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FavoritePickerPage(store: _store)),
    );
  }

  Future<void> _confirmDeleteFilter(CustomFilter f) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus filter?'),
        content: Text('Filter "${f.name}" akan dihapus. Chat di dalamnya tidak ikut terhapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      _store.deleteFilter(f.id);
      if (_filter == f.id && mounted) setState(() => _filter = 'all');
    }
  }

  void _showFilterOptions(CustomFilter f) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _sheetHandle(),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: _primary),
              title: const Text('Edit filter'),
              onTap: () {
                Navigator.pop(ctx);
                _openFilterEditor(f);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Hapus filter'),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDeleteFilter(f);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(ChatItem chat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _sheetHandle(),
            ListTile(
              leading: Icon(
                chat.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                color: _primary,
              ),
              title: Text(chat.isPinned ? 'Lepas pin' : 'Pin chat'),
              onTap: () {
                Navigator.pop(ctx);
                _togglePin(chat);
              },
            ),
            ListTile(
              leading: Icon(
                chat.isFavorite ? Icons.star_border_rounded : Icons.star_rounded,
                color: _primary,
              ),
              title: Text(chat.isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit'),
              onTap: () {
                Navigator.pop(ctx);
                _store.toggleFavorite(chat.id);
              },
            ),
            if (chat.unread > 0)
              ListTile(
                leading: const Icon(Icons.mark_chat_read_outlined, color: _primary),
                title: const Text('Tandai sudah dibaca'),
                onTap: () {
                  Navigator.pop(ctx);
                  _store.markRead(chat.id);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sheetHandle() => Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pesan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'Menu',
            color: Colors.white,
            onSelected: (v) {
              switch (v) {
                case 'group':
                  _createGroup();
                  break;
                case 'friend':
                  _addFriend();
                  break;
                case 'favorite':
                  _pickFavorites();
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'group',
                child: Row(children: [
                  Icon(Icons.group_add_outlined, color: _primary),
                  SizedBox(width: 12),
                  Text('Grup baru'),
                ]),
              ),
              PopupMenuItem(
                value: 'friend',
                child: Row(children: [
                  Icon(Icons.person_add_alt_1_outlined, color: _primary),
                  SizedBox(width: 12),
                  Text('Tambah teman'),
                ]),
              ),
              PopupMenuItem(
                value: 'favorite',
                child: Row(children: [
                  Icon(Icons.star_border_rounded, color: _primary),
                  SizedBox(width: 12),
                  Text('Tambah favorit'),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterBar(),
          const SizedBox(height: 4),
          Expanded(
            child: ListenableBuilder(
              listenable: _store,
              builder: (context, _) {
                final chats = _filtered();
                if (chats.isEmpty) return _buildEmpty();
                return ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: chats.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 76, endIndent: 16),
                  itemBuilder: (_, i) => _buildTile(chats[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _query = v),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Cari nama atau pesan...',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final unread = _store.unreadChats;
        return SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _filterChip('all', 'Semua'),
              _filterChip('unread', unread > 0 ? 'Belum dibaca $unread' : 'Belum dibaca'),
              _filterChip('favorite', 'Favorit'),
              _filterChip('group', 'Grup'),
              for (final f in _store.filters) _filterChip(f.id, f.name, custom: f),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: const Icon(Icons.add, size: 18, color: _primary),
                  label: const Text('Filter'),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _openFilterEditor(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(String key, String label, {CustomFilter? custom}) {
    final selected = _filter == key;
    final chip = ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => setState(() => _filter = key),
      selectedColor: _lightCyan,
      backgroundColor: Colors.white,
      side: BorderSide(color: selected ? _primary : Colors.grey.shade300),
      labelStyle: TextStyle(
        fontSize: 13,
        color: selected ? _text : Colors.grey.shade700,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      visualDensity: VisualDensity.compact,
    );
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: custom == null
          ? chip
          : GestureDetector(
              onLongPress: () => _showFilterOptions(custom),
              child: chip,
            ),
    );
  }

  Widget _buildTile(ChatItem chat) {
    final hasUnread = chat.unread > 0;
    final indicators = <Widget>[
      if (chat.isFavorite)
        const Padding(
          padding: EdgeInsets.only(right: 4),
          child: Icon(Icons.star_rounded, size: 15, color: Colors.amber),
        ),
      if (chat.isPinned)
        const Padding(
          padding: EdgeInsets.only(right: 4),
          child: Icon(Icons.push_pin, size: 14, color: Colors.grey),
        ),
      if (hasUnread)
        Container(
          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: const BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          alignment: Alignment.center,
          child: Text(
            '${chat.unread}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    ];

    return InkWell(
      onTap: () => _openRoom(chat),
      onLongPress: () => _showChatOptions(chat),
      child: Container(
        color: chat.isPinned ? _lightCyan.withAlpha(60) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _ChatAvatar(name: chat.name, isGroup: chat.isGroup),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: hasUnread ? _text : Colors.grey,
                      fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatChatTime(chat.lastTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: hasUnread ? _primary : Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: indicators.isEmpty
                      ? const [SizedBox(height: 20)]
                      : indicators,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    late final IconData icon;
    late final String title;
    late final String message;

    if (_query.trim().isNotEmpty) {
      icon = Icons.search_off_rounded;
      title = 'Tidak ditemukan';
      message = 'Tidak ada chat yang cocok dengan "$_query".';
    } else if (_filter == 'all') {
      icon = Icons.chat_bubble_outline_rounded;
      title = 'Belum ada pesan';
      message = 'Percakapan dengan penyedia layanan MikroHub akan ditampilkan di sini.';
    } else {
      icon = Icons.filter_list_off_rounded;
      title = 'Tidak ada chat';
      switch (_filter) {
        case 'unread':
          message = 'Semua pesan sudah dibaca.';
          break;
        case 'favorite':
          message = 'Buka menu ⋮ di kanan atas lalu pilih "Tambah favorit".';
          break;
        case 'group':
          message = 'Buat grup lewat tombol + di pojok kanan atas.';
          break;
        default:
          message = 'Belum ada chat di filter ini. Tekan lama filter untuk mengeditnya.';
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: _lightCyan,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: _primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── TAMBAH TEMAN ─────────────────────────

class _AddContactDialog extends StatefulWidget {
  final ChatStore store;
  const _AddContactDialog({required this.store});

  @override
  State<_AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<_AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final phone = ChatStore.normalizePhone(_phoneCtrl.text)!;
    final chat = widget.store.addContact(_nameCtrl.text, phone);
    Navigator.pop(context, chat);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Tambah Teman'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                maxLength: 40,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person_outline),
                  counterText: '',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
                ],
                onFieldSubmitted: (_) => _save(),
                decoration: const InputDecoration(
                  labelText: 'Nomor telepon',
                  hintText: '0812 3456 7890',
                  helperText: 'Awalan 0 otomatis menjadi +62',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) {
                  final phone = ChatStore.normalizePhone(v ?? '');
                  if (phone == null) return 'Nomor tidak valid (9-15 digit)';
                  final existing = widget.store.contactByPhone(phone);
                  if (existing != null) {
                    return 'Sudah tersimpan atas nama ${existing.name}';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: _primary),
          onPressed: _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// ───────────────────────── PILIHAN (dipakai grup & filter) ─────────────────────────

class _PickItem {
  final String id;
  final String title;
  final String? subtitle;
  final bool isGroup;

  const _PickItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.isGroup = false,
  });
}

/// Kolom cari + daftar centang. Dipakai buat pilih anggota grup dan isi filter.
class _PickerBody extends StatefulWidget {
  final List<_PickItem> items;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final String searchHint;
  final String emptyText;

  const _PickerBody({
    required this.items,
    required this.selected,
    required this.onToggle,
    required this.searchHint,
    required this.emptyText,
  });

  @override
  State<_PickerBody> createState() => _PickerBodyState();
}

class _PickerBodyState extends State<_PickerBody> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim().toLowerCase();
    final shown = widget.items.where((i) {
      if (q.isEmpty) return true;
      return i.title.toLowerCase().contains(q) ||
          (i.subtitle ?? '').toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            decoration: InputDecoration(
              hintText: widget.searchHint,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: shown.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      widget.items.isEmpty ? widget.emptyText : 'Tidak ditemukan',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: shown.length,
                  itemBuilder: (_, i) {
                    final item = shown[i];
                    final checked = widget.selected.contains(item.id);
                    return ListTile(
                      onTap: () => widget.onToggle(item.id),
                      leading: _ChatAvatar(
                        name: item.title,
                        isGroup: item.isGroup,
                        radius: 22,
                      ),
                      title: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: item.subtitle == null
                          ? null
                          : Text(item.subtitle!, style: const TextStyle(fontSize: 12)),
                      trailing: Checkbox(
                        value: checked,
                        activeColor: _primary,
                        shape: const CircleBorder(),
                        onChanged: (_) => widget.onToggle(item.id),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ───────────────────────── BUAT GRUP ─────────────────────────

class CreateGroupPage extends StatefulWidget {
  final ChatStore store;
  const CreateGroupPage({super.key, required this.store});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _nameCtrl = TextEditingController();
  final Set<String> _selected = {};

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  bool get _canCreate => _nameCtrl.text.trim().isNotEmpty && _selected.length >= 2;

  void _toggle(String id) {
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
  }

  void _create() {
    final chat = widget.store.createGroup(_nameCtrl.text, _selected.toList());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChatRoomPage(store: widget.store, chatId: chat.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = widget.store.contacts;
    final items = contacts
        .map((c) => _PickItem(id: c.id, title: c.name, subtitle: c.phone))
        .toList();

    final hint = _nameCtrl.text.trim().isEmpty
        ? 'Isi nama grup'
        : _selected.length < 2
            ? 'Pilih minimal 2 anggota'
            : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grup Baru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(
              '${_selected.length} dari ${contacts.length} dipilih',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _nameCtrl,
              maxLength: 40,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Nama grup',
                counterText: '',
                prefixIcon: const Icon(Icons.groups_rounded, color: _primary),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (_selected.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final id in _selected)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InputChip(
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: Text(
                            widget.store.contactById(id)?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        backgroundColor: _lightCyan,
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                        onDeleted: () => _toggle(id),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: _PickerBody(
              items: items,
              selected: _selected,
              onToggle: _toggle,
              searchHint: 'Cari teman...',
              emptyText: 'Belum ada teman. Tambahkan teman terlebih dahulu.',
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hint != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        hint,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: _primary),
                      onPressed: _canCreate ? _create : null,
                      child: Text('Buat Grup (${_selected.length})'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── EDITOR FILTER ─────────────────────────

class FilterEditorPage extends StatefulWidget {
  final ChatStore store;
  final CustomFilter? existing;

  const FilterEditorPage({super.key, required this.store, this.existing});

  @override
  State<FilterEditorPage> createState() => _FilterEditorPageState();
}

class _FilterEditorPageState extends State<FilterEditorPage> {
  late final TextEditingController _nameCtrl;
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _selected = {...?widget.existing?.chatIds};
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  bool get _canSave => _nameCtrl.text.trim().isNotEmpty && _selected.isNotEmpty;

  void _toggle(String id) {
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
  }

  void _save() {
    final existing = widget.existing;
    if (existing == null) {
      final f = widget.store.addFilter(_nameCtrl.text, _selected);
      Navigator.pop(context, f.id);
    } else {
      widget.store.updateFilter(existing.id, _nameCtrl.text, _selected);
      Navigator.pop(context, existing.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.store.sorted
        .map((c) => _PickItem(
              id: c.id,
              title: c.name,
              subtitle: c.isGroup ? 'Grup · ${c.memberIds.length} anggota' : null,
              isGroup: c.isGroup,
            ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.existing == null ? 'Filter Baru' : 'Edit Filter',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _nameCtrl,
              maxLength: 20,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Nama filter, mis. Klien, Kerja',
                counterText: '',
                prefixIcon: const Icon(Icons.label_outline, color: _primary),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pilih chat yang masuk filter ini (${_selected.length})',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: _PickerBody(
              items: items,
              selected: _selected,
              onToggle: _toggle,
              searchHint: 'Cari chat...',
              emptyText: 'Belum ada chat.',
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: _primary),
                  onPressed: _canSave ? _save : null,
                  child: const Text('Simpan Filter'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── PILIH FAVORIT ─────────────────────────

class FavoritePickerPage extends StatefulWidget {
  final ChatStore store;
  const FavoritePickerPage({super.key, required this.store});

  @override
  State<FavoritePickerPage> createState() => _FavoritePickerPageState();
}

class _FavoritePickerPageState extends State<FavoritePickerPage> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.store.sorted
        .where((c) => c.isFavorite)
        .map((c) => c.id)
        .toSet();
  }

  void _toggle(String id) {
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
  }

  void _save() {
    widget.store.setFavorites(_selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.store.sorted
        .map((c) => _PickItem(
              id: c.id,
              title: c.name,
              subtitle: c.isGroup ? 'Grup · ${c.memberIds.length} anggota' : null,
              isGroup: c.isGroup,
            ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Favorit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(
              '${_selected.length} dipilih',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _PickerBody(
              items: items,
              selected: _selected,
              onToggle: _toggle,
              searchHint: 'Cari nama...',
              emptyText: 'Belum ada chat.',
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: _primary),
                  onPressed: _save,
                  child: const Text('Simpan Favorit'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── INFO GRUP ─────────────────────────

class GroupInfoPage extends StatelessWidget {
  final ChatStore store;
  final String chatId;

  const GroupInfoPage({super.key, required this.store, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chat = store.byId(chatId);
    final members = chat.memberIds
        .map(store.contactById)
        .whereType<Contact>()
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final total = members.length + 1; // + kamu

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Info Grup',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Center(child: _ChatAvatar(name: chat.name, isGroup: true, radius: 44)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              chat.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Grup · $total anggota',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'ANGGOTA ($total)',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              radius: 22,
              backgroundColor: _primary,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('Kamu'),
          ),
          for (final c in members)
            ListTile(
              leading: _ChatAvatar(name: c.name, radius: 22),
              title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(c.phone, style: const TextStyle(fontSize: 12)),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ───────────────────────── RUANG CHAT ─────────────────────────

class ChatRoomPage extends StatefulWidget {
  final ChatStore store;
  final String chatId;

  const ChatRoomPage({super.key, required this.store, required this.chatId});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.store.activeChatId = widget.chatId;
  }

  @override
  void dispose() {
    widget.store.activeChatId = null;
    widget.store.byId(widget.chatId).unread = 0;
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    widget.store.send(widget.chatId, text);
    widget.store.autoReply(widget.chatId); // simulasi
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.store.byId(widget.chatId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
          onTap: chat.isGroup
              ? () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupInfoPage(
                        store: widget.store,
                        chatId: widget.chatId,
                      ),
                    ),
                  )
              : null,
          child: Row(
          children: [
            _ChatAvatar(name: chat.name, isGroup: chat.isGroup, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.store.subtitleFor(chat),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: widget.store,
              builder: (context, _) {
                if (chat.messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        chat.isGroup
                            ? 'Grup "${chat.name}" dibuat.\nKirim pesan pertama!'
                            : 'Mulai percakapan dengan ${chat.name}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                final msgs = chat.messages.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) => _Bubble(
                    message: msgs[i],
                    showSender: chat.isGroup,
                  ),
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: _primary,
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: _send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage message;
  final bool showSender;

  const _Bubble({required this.message, this.showSender = false});

  @override
  Widget build(BuildContext context) {
    final me = message.isMe;
    final sender = (!me && showSender) ? message.sender : null;

    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: me ? _primary : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(me ? 16 : 4),
            bottomRight: Radius.circular(me ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sender != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  sender,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _primaryDark,
                  ),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(color: me ? Colors.white : _text, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              widthFactor: 1,
              child: Text(
                '${_two(message.time.hour)}:${_two(message.time.minute)}',
                style: TextStyle(
                  fontSize: 10,
                  color: me ? Colors.white70 : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
