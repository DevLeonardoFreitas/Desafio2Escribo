import 'dart:convert';

import 'package:desafioescribo/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class CardBook extends StatelessWidget {
  Book book;

  CardBook(this.book);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white38,
      child: Column(
        children: [
          GestureDetector(
            child: Image.network(
              book.coverUrl.toString(),
            ),
            onLongPress: () {
              downloadBook(book);
            },
            onTap: () {
              openBook(
                  '/storage/emulated/0/Download/${book.title.toString()}.epub');
            },
          ),
          Text(
            book.title.toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            book.author.toString(),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void downloadBook(book) {
    FileDownloader.downloadFile(
      url: book.downloadUrl.toString(),
      name: '${book.title.toString()}.epub',
      downloadDestination: DownloadDestinations.publicDownloads,
      onDownloadCompleted: (String path) {
        print('FILE DOWNLOADED TO PATH: $path');
      },
      notificationType: NotificationType.all,
    );
  }

  void openBook(String localpath) {
    VocsyEpub.setConfig(
      // themeColor: Theme.of(context).primaryColor,
      identifier: "Book",
      scrollDirection: EpubScrollDirection.HORIZONTAL,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );
    VocsyEpub.open(
      localpath,
      lastLocation: EpubLocator.fromJson({
        "bookId": "2239",
        "href": "/OEBPS/ch06.xhtml",
        "created": 1539934158390,
        "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
      }),
    );
    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
    });
  }
}
