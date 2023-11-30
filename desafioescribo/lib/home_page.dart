import 'dart:convert';
import 'package:desafioescribo/card_book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/book.dart';
// import 'package:vocsy_epub_viewer/epub_viewer.dart';

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
    List<Book> favourites = [];
    return Scaffold(
      appBar: AppBar(title: const Text('MyBooks')),
      body: Container(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: null, child: Text('Livros')),
                ElevatedButton(onPressed: null, child: Text('Favoritos')),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Book book = snapshot.data![index];
                          return CardBook(book);
                        });
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
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

// ListTile(
//                             leading: Image.network(book.coverUrl.toString()),
//                             title: Text(book.title!),
//                             subtitle: Text(book.author!),
//                             onLongPress: () {
//                               downloadBook(book);
//                             },
//                             onTap: () {
//                               openBook(
//                                   '/storage/emulated/0/Download/${book.title}.epub');
//                             },
//                           );
