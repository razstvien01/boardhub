import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UserImage extends StatefulWidget {
  final Function(String imageURL) onFileChanged;
  
  UserImage({super.key, required this.onFileChanged});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ImagePicker _picker = ImagePicker();
  
  String? imageURL;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(imageURL == null)
          Icon(Icons.person, size: 60),
          
        if(imageURL != null)
          InkWell(
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