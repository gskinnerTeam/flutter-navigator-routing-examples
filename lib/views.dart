import 'package:flutter/material.dart';

class GenresListView extends StatelessWidget {
  const GenresListView({Key key, this.onGenrePressed}) : super(key: key);
  final ValueChanged<String> onGenrePressed;

  @override
  Widget build(BuildContext context) =>
      GestureDetector(onTap: () => onGenrePressed?.call("foo"), child: _Placeholder("Genres", Colors.blue.shade100));
}

class BookListView extends StatelessWidget {
  const BookListView({Key key, this.genreId, this.onBookPressed}) : super(key: key);
  final String genreId;
  final ValueChanged<String> onBookPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: _Placeholder(genreId, Colors.red.shade100),
      );
}

class BookDetailsView extends StatelessWidget {
  const BookDetailsView({Key key, this.bookId}) : super(key: key);
  final String bookId;

  @override
  Widget build(BuildContext context) => _Placeholder(bookId, Colors.red.shade100);
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title, this.color, {Key key}) : super(key: key);
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: color,
      child: Column(
        children: [
          Text(title ?? "", style: TextStyle(fontSize: 32)),
          OutlineButton(
            child: Text("showDialog"),
            onPressed: () => showDialog(
                context: context,
                builder: (c) => Dialog(
                      child: Container(
                        width: 200,
                        height: 200,
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
