class UnbordingContent {
  String image;
  String title;
  String discription;
  String discription1;
  String discription2;
  String discription4;
  String discription5;

  UnbordingContent(
      {required this.image,
      required this.title,
      required this.discription,
      required this.discription1,
      required this.discription2,
      required this.discription4,
      required this.discription5});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Welcome',
      image: 'image/logo.png',
      discription: "This mobile application is ",
      discription1: 'created to identify different kinds',
      discription2: 'of rice stemborers using image processing.',
      discription4: '',
      discription5: ''),
  UnbordingContent(
      title: 'How to use',
      image: 'image/howToUse.png',
      discription: "1. Area for previewing image",
      discription1: '2. Results of the image details',
      discription2: '3. Sample Image based on the uploaded image',
      discription4: '4. Click here to upload a photo from your gallery',
      discription5: '5. Click here to Take a photo'),
  UnbordingContent(
      title: 'Valid image',
      image: 'image/borer.png',
      discription: "\u2022 The object must be 60–80% of the image,",
      discription1: '\u2022 The image background must be green.',
      discription2: '\u2022 The phone camera must be 50mp.',
      discription4: '',
      discription5: ''),
];
