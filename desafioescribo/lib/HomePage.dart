import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Book.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> books;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    books = getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyBooks')),
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
                      title: Text(book.title!),
                      subtitle: Text(book.author!),
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
