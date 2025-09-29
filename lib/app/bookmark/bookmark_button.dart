import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/t_loader.dart';
import 'package:text_reader/app/bookmark/bookmark.dart';
import 'package:text_reader/app/bookmark/bookmark_services.dart';
import 'package:text_reader/app/core/interfaces/database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/setting.dart';

class BookmarkButton extends StatefulWidget {
  Post post;
  BookmarkButton({super.key, required this.post});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> with DatabaseListener {
  @override
  void initState() {
    BookmarkServices.getDB.addListener(this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void onDatabaseChanged(DatabaseListenerTypes type, String? id) {
    if (!mounted) return;
    init();
  }

  @override
  void dispose() {
    BookmarkServices.getDB.removeListener(this);
    super.dispose();
  }

  bool isExists = false;
  bool isLoading = false;
  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      isExists = await BookmarkServices.isExists(widget.post.id);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(width: 25, height: 25, child: TLoader());
    }
    return IconButton(
      onPressed: _toggle,
      icon: Icon(
        color: isExists ? Colors.red : Colors.teal,
        isExists ? Icons.bookmark_remove : Icons.bookmark_add,
      ),
    );
  }

  void _toggle() async {
    final db = BookmarkServices.getDB;
    final book = Bookmark.create(
      title: widget.post.title,
      id: widget.post.id,
      databaseType: Setting.getAppConfig.databaseType,
    );
    if (isExists) {
      db.delete(book.id);
    } else {
      db.add(book);
    }
    isExists = !isExists;
    if (!mounted) return;
    setState(() {});
  }
}
