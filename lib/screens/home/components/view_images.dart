// import 'package:flutter/material.dart';
// import 'package:rent_house/constant.dart';

// class ViewImages extends StatelessWidget {
//   List<dynamic> images;
//   ViewImages({super.key, required this.images});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kBGColor,
//         elevation: 0.0,
//         iconTheme: IconThemeData(
//           color: kPrimaryColor,
//         ),
//         // title: Text(
//         //   widget.item.title!,
//         //   style: kSubTextStyle,
//         // ),
//       ),
//       backgroundColor: kBGColor,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView.builder(
//           itemCount: images.length,
//           shrinkWrap: true,
//           scrollDirection: Axis.vertical,
//           physics: const BouncingScrollPhysics(),
//           itemBuilder: (context, index) {
//             return Image.network(images[index]);
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class ViewImages extends StatefulWidget {
  List<dynamic> images;
  ViewImages({super.key, required this.images});

  @override
  State<ViewImages> createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBGColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        title: const Text('View Images', style: kSubTextStyle,),
      ),
      backgroundColor: kBGColor,
      body: (widget.images.isNotEmpty) ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: widget.images.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                // Add a border color here
                side: BorderSide(
                  color: kPrimaryColor,
                  width: 5.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ) : Text("There are no pictures.", style: kSubTextStyle,),
    );
  }
}
