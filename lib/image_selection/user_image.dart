import 'package:flutter/material.dart';


class UserImage extends StatefulWidget {
  final Function(String imageURL) onFileChanged;
  
  const UserImage({super.key, required this.onFileChanged});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {

  String? imageURL;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(imageURL == null)
          const Icon(Icons.person, size: 60),
          
        if(imageURL != null)
          const InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            //onTap: () => _selectPhoto(),
            // child: AppRoundImage.url(
            //   imageURL!,
            //   width: 80,
            //   height: 80,
            // ),
          ),
        
      ],
    );
  }
}