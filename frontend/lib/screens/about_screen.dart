// import 'package:flutter/material.dart';

// class TentangAplikasiScreen extends StatefulWidget {
//   const TentangAplikasiScreen({super.key});

//   @override
//   State<TentangAplikasiScreen> createState() => _TentangAplikasiScreenState();
// }

// class _TentangAplikasiScreenState extends State<TentangAplikasiScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fade;
//   late Animation<Offset> _slide;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _slide = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tentang Aplikasi'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: isDark ? Colors.white : const Color.fromARGB(255, 255, 255, 255),
//       ),
//       extendBodyBehindAppBar: true,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDark
//                 ? [const Color(0xFF1F1F1F), const Color(0xFF3A3A3A)]
//                 : [const Color(0xFF6A85B6), const Color(0xFFBAC8E0)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fade,
//           child: SlideTransition(
//             position: _slide,
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Card(
//                   color: isDark
//                       ? Colors.black.withOpacity(0.8)
//                       : Colors.white.withOpacity(0.95),
//                   elevation: 6,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Penerjemah Bahasa Isyarat AI',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color:
//                                 isDark ? Colors.blue[200] : const Color(0xFF3E4A89),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           'Aplikasi ini bertujuan membantu pengguna menerjemahkan '
//                           'bahasa isyarat ke teks secara otomatis menggunakan '
//                           'teknologi kecerdasan buatan (AI).',
//                           textAlign: TextAlign.justify,
//                           style: TextStyle(
//                             color: isDark ? Colors.grey[300] : Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         InfoTile(
//                             icon: Icons.app_settings_alt,
//                             title: 'Versi',
//                             value: '1.1.0',
//                             isDark: isDark),
//                         InfoTile(
//                             icon: Icons.person,
//                             title: 'Pengembang',
//                             value: 'Agus Purwanto',
//                             isDark: isDark),
//                         InfoTile(
//                             icon: Icons.android,
//                             title: 'Platform',
//                             value: 'Android',
//                             isDark: isDark),
//                         InfoTile(
//                             icon: Icons.calendar_today,
//                             title: 'Tahun',
//                             value: '2025',
//                             isDark: isDark),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class InfoTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//   final bool isDark;
//   const InfoTile({
//     required this.icon,
//     required this.title,
//     required this.value,
//     required this.isDark,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(icon, color: isDark ? Colors.blue[300] : Colors.blueGrey),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: isDark ? Colors.grey[200] : Colors.black,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: isDark ? Colors.grey[400] : Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
