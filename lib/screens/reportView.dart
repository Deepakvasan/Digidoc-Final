import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import '../services/storage_service.dart';

class ReportView extends StatefulWidget {
  final String reportType;
  final String patientUid;

  ReportView({required this.reportType, required this.patientUid});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  String test = "";
  String down = "";
  late Storage storage;
  Future<void> _deleteConfirmation(
      BuildContext context, String name, String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to delete this report ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                storage.delete(type, name).then(
                  (value) {
                    Navigator.of(context).pop();
                    setState(() {
                      test = "";
                    });
                  },
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final Storage storage = Storage(widget.patientUid);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportType),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: GestureDetector(
        child: FutureBuilder(
          future: storage.listFiles(widget.reportType),
          builder: (BuildContext context,
              AsyncSnapshot<firebase_storage.ListResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return snapshot.data!.items.length == 0
                  ? Center(
                      child: Text("No reports uploaded in this category"),
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: snapshot.data!.items.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(12.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.95),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade800,
                                      offset: const Offset(3.0, 3.0),
                                      blurRadius: 4.0)
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text(
                                      snapshot.data!.items[index].name,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        storage.downloadFile(
                                          widget.reportType,
                                          snapshot.data!.items[index].name,
                                          context,
                                        );
                                      },
                                      child: Icon(
                                        CupertinoIcons.cloud_download_fill,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      onTap: () {
                                        _deleteConfirmation(
                                          context,
                                          snapshot.data!.items[index].name,
                                          widget.reportType,
                                        );
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              );
            }
            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 60.0,
                ),
                child: Center(
                  child: Text("No Reports found in this category"),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
