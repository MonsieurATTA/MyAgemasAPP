class ConseilAssurance {
  String bgImage;
  String icon;
  String name;
  String type;
  num score;
  num download;
  num review;
  String description;
  List<String> images;

  ConseilAssurance({
    required this.bgImage,
    required this.icon,
    required this.name,
    required this.type,
    required this.score,
    required this.download,
    required this.review,
    required this.description,
    required this.images,
  });

  static List<ConseilAssurance> sante() {
    return [
      ConseilAssurance(
        bgImage: 'assets/images/health.png',
        icon: 'assets/icons/health.png',
        name: 'Buvez 8 verres d\'eau par jour',
        type: 'Vie',
        score: 4.5,
        download: 15000,
        review: 1200,
        description:
            'AGEMAS a plus de 400 pharmacie conventionnée sur tout le teritoire ivoirien.',
        images: ['assets/images/health.png', 'assets/images/health.png'],
      ),
      ConseilAssurance(
        bgImage: 'assets/images/guard.png',
        icon: 'assets/icons/guard.png',
        name: 'Evitez l\'algool et le tabac',
        type: 'Vie',
        score: 4.5,
        download: 15000,
        review: 1200,
        description:
            'AGEMAS a plus de 400 pharmacie conventionnée sur tout le teritoire ivoirien.',
        images: ['assets/images/guard.png', 'assets/images/guard.png'],
      ),
    ];
  }
}
