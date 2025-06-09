import 'package:flutter/material.dart';

class AboutUsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200, // background halaman
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade50, // kotak utama
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Center(
              child: Text(
                'About Us',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            SizedBox(height: 24),

          // Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'http://10.0.2.2:8000/images/barang/reusemart.jpg?ts=${DateTime.now().millisecondsSinceEpoch}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Visi & Misi
          _SectionTitle(title: 'Visi'),
          Text(
            'ReUseMart menjadi platform e-commerce terkemuka yang mendorong keberlanjutan dan pengurangan sampah.',
          ),
          SizedBox(height: 16),

          _SectionTitle(title: 'Misi'),
          SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Meningkatkan Aksesibilitas untuk Barang Bekas Berkualitas',
              'Mendorong Keberlanjutan',
              'Menyediakan Pilihan yang Beragam',
              'Memberdayakan Komunitas',
              'Edukasi dan Kesadaran Konsumen',
            ]
                .map(
                  (s) => Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 18, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(child: Text(s)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 24),

          // Our Values
          LayoutBuilder(
            builder: (context, constraints) {
              final double spacing = 12;
              final double cardWidth = (constraints.maxWidth - spacing) / 2;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _SectionTitle(title: 'Our Values'),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      _ValueCard(
                          icon: Icons.recycling,
                          title: 'Keberlanjutan',
                          text: 'Mendukung pengurangan sampah.',
                          width: cardWidth),
                      _ValueCard(
                          icon: Icons.verified,
                          title: 'Kualitas',
                          text: 'Hanya barang berkualitas tinggi.',
                          width: cardWidth),
                      _ValueCard(
                          icon: Icons.visibility,
                          title: 'Transparansi',
                          text: 'Deskripsi dan transaksi jelas.',
                          width: cardWidth),
                      _ValueCard(
                          icon: Icons.lightbulb,
                          title: 'Inovasi',
                          text: 'Pengalaman pengguna terus ditingkatkan.',
                          width: cardWidth),
                      _ValueCard(
                          icon: Icons.favorite,
                          title: 'Lebih Baik',
                          text: 'Akses barang terjangkau.',
                          width: cardWidth),
                      _ValueCard(
                          icon: Icons.groups,
                          title: 'Komunitas',
                          text: 'Memberdayakan komunitas lokal.',
                          width: cardWidth),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 24),

          // Contact Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Our Contact',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('📧 support@reusemart.com',
                    style: TextStyle(color: Colors.white)),
                Text('📞 +1 (123) 456-7890',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }
}

// Widget untuk judul bagian
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
    );
  }
}

// Widget kartu nilai
class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String title, text;
  final double width;
  const _ValueCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green.shade600, size: 28),
          SizedBox(height: 8),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          Divider(color: Colors.green.shade100, thickness: 1),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}