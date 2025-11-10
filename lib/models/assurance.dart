//LES OBJET QUE J'UTILISE POUR POUR LE BODY DU BOUTON PHARMACIE DANS PRODUIT.DART

class Assurance {
  String bgImage;
  String icon;
  String name;
  String type;
  num score;
  num download;
  num review;
  String description;
  List<String> images;

  Assurance({
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

  static List<Assurance> assurances() {
    return [
      Assurance(
        bgImage: 'assets/images/Logo-Pharmacie.jpg',
        icon: 'assets/icons/Logo-Pharmacie.jpg',
        name: 'Votre pharmacie à coeur ouvert',
        type: 'Vie',
        score: 4.5,
        download: 15000,
        review: 1200,
        description:
            'AGEMAS a plus de 400 pharmacie conventionnée sur tout le teritoire ivoirien.',
        images: [
          'assets/images/Logo-Pharmacie.jpg',
          'assets/images/Logo-Pharmacie.jpg',
        ],
      ),
      /* Assurance(
        bgImage: 'assets/images/Img-AGEMAS-0.jpg',
        icon: 'assets/icons/Img-AGEMAS-0.jpg',
        name: 'Moka Santé',
        type: 'Pharmacie',
        score: 4.7,
        download: 20000,
        review: 1800,
        description: "Votre produit qui vous couvre à 100% en pharmacie.",
        images: [
          'assets/images/Img-AGEMAS-0.jpg',
          'assets/images/Img-AGEMAS-0.jpg',
        ],
      ), */
      /* Assurance(
        bgImage: 'assets/images/Img-AGEMAS-1.jpg',
        icon: 'assets/icons/Img-AGEMAS-1.jpg',
        name: 'Santé Sécurisée',
        type: 'Santé',
        score: 4.7,
        download: 20000,
        review: 1800,
        description:
            "Une assurance santé abordable couvrant une large gamme de soins médicaux.",
        images: [
          'assets/images/Img-AGEMAS-0.jpg',
          'assets/images/Img-AGEMAS-0.jpg',
        ],
      ), */
    ];
  }
}
