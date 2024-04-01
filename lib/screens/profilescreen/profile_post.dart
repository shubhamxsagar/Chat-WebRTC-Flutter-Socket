import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfilePost extends StatelessWidget {
  const ProfilePost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<String> imagePaths = [
    //   'assets/images/images/image1.png'
    //   'assets/images/images/image2.png'
    //   'assets/images/images/image3.png'
    //   'assets/images/images/image4.png'

    //   // Add more image paths as needed
    // ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: MasonryGridView.builder(
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset('assets/images/images/image1.png'),
          ),
        ),
      ),
    );
  }
}
