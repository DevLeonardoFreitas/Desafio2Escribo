import 'dart:convert';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'models/book.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyBooks')),
      body: Center(
        child: FutureBuilder<List<Book>>(
          future: books,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Book book = snapshot.data![index];
                    return ListTile(
                      leading: Image.network(book.coverUrl.toString()),
                      title: Text(book.title!),
                      subtitle: Text(book.author!),
                      onLongPress: () => {
                        FileDownloader.downloadFile(
                          url: book.downloadUrl.toString(),
                          name: book.title.toString().trim(),
                          downloadDestination:
                              DownloadDestinations.publicDownloads,
                        )
                      },
                    );
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List<Book>> getBooks() async {
    var url = Uri.parse('https://escribo.com/books.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List allBooks = json.decode(response.body);
      return allBooks.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Não foi possível carregar os livros');
    }
  }
}
