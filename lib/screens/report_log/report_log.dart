import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/report_comment.dart';

class CommentReportLog extends StatefulWidget {
  const CommentReportLog({super.key});

  @override
  State<CommentReportLog> createState() => _CommentReportLogState();
}

class _CommentReportLogState extends State<CommentReportLog> {
  List<ReportComment> reportComments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: Text(
          'Comments Report Log',
          style: kSubTextStyle,
        ),
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('reports')
                    .doc('comments')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    reportComments = [];

                    for (var k in data.keys) {
                      // List report = (data[k])
                      ReportComment rp = ReportComment(
                        dateReported: data[k]['dateReported'],
                        key: k,
                        name: data[k]['name'],
                        profile_url: data[k]['profile_url'],
                        reportedBy: data[k]['reportedBy'],
                        comment: data[k]['comment'],
                      );

                      reportComments.add(rp);
                    }

                    reportComments.sort((a, b) {
                      DateTime dateTimeA = DateTime.parse(
                          "${a.dateReported!.split(" - ")[0]} ${a.dateReported!.split(" - ")[1]}");
                      DateTime dateTimeB = DateTime.parse(
                          "${b.dateReported!.split(" - ")[0]} ${b.dateReported!.split(" - ")[1]}");
                      return dateTimeB.compareTo(dateTimeA);
                    });

                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: reportComments.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Card(
                              color: kAccentColor,
                              shadowColor: kAccentColor,
                              elevation: 16,
                              // color: Colors.green,
                              // elevation: 16,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Wrap(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: kBGColor,
                                        borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Reported User: ',
                                                // style: kSubTextStyle,
                                                style: kSmallPrimTextStyle,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '${reportComments[index].name}',
                                                // style: kSubTextStyle,
                                                style: kSubTextStyle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Date Reported: ',
                                                // style: kSubTextStyle,
                                                style: kSmallPrimTextStyle,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '${reportComments[index].dateReported}',
                                                // style: kSubTextStyle,
                                                style: kSubTextStyle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Comment: ',
                                              style:
                                                  kSmallPrimTextStyle,
                                            ),
                                            Text(
                                              '${reportComments[index].comment}',
                                              style:
                                                  kSmallTextStyle,
                                              maxLines: 10,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                    // return ListTile(title: Card(

                    // ),);
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
