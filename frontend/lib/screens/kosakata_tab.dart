import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../api/api_service.dart';
import '../../data/kamus_model.dart';

class KamusKosakataScreen extends StatefulWidget {
  const KamusKosakataScreen({Key? key}) : super(key: key);

  @override
  State<KamusKosakataScreen> createState() => _KamusKosakataScreenState();
}

class _KamusKosakataScreenState extends State<KamusKosakataScreen> {
  late Future<List<KamusModel>> _kosakataFuture;
  List<KamusModel> _allKosakata = [];
  List<KamusModel> _filteredKosakata = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _kosakataFuture = ApiService.fetchKosakata().then((data) {
      _allKosakata = data;
      _filteredKosakata = data;
      return data;
    });
  }

  void _searchKosakata(String query) {
    setState(() {
      _filteredKosakata = _allKosakata
          .where((item) =>
              item.namaGerakan.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showImageDialog(KamusModel item) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.85),
        insetPadding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    item.urlGambar,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.namaGerakan,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    item.deskripsi,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [

            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Kamus Kosakata",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),

            // ===== SEARCH BAR =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Cari kosakata...",
                    hintStyle:
                        TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear,
                          color: Colors.white.withOpacity(0.6)),
                      onPressed: () {
                        _searchController.clear();
                        _searchKosakata('');
                        _dismissKeyboard();
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: _searchKosakata,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ===== GRID =====
            Expanded(
              child: FutureBuilder<List<KamusModel>>(
                future: _kosakataFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Gagal memuat data",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  if (_filteredKosakata.isEmpty) {
                    return const Center(
                      child: Text(
                        "Kosakata tidak ditemukan",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: 220,
                    ),
                    itemCount: _filteredKosakata.length,
                    itemBuilder: (context, index) {
                      final item = _filteredKosakata[index];

                      return FadeInUp(
                        duration:
                            Duration(milliseconds: 150 + (index * 40)),
                        child: GestureDetector(
                          onTap: () => _showImageDialog(item),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(24),
                                  child: Image.network(
                                    item.urlGambar,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.65),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Text(
                                    item.namaGerakan,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
