import 'package:flutter/material.dart';
import '../models/note.dart';
import '../db/notes_database.dart';
import 'add_update_note.dart';

class ViewNote extends StatefulWidget {
  final int? noteID;
  final int? index;
  final Note? note;
  const ViewNote({
    super.key,
    required this.noteID,
    required this.index,
    required this.note,
  });

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  Note? note;
  bool isLoading = false;
  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  Future<void> refreshNotes() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteID);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: const Color.fromARGB(250, 66, 66, 66),
                ),
                child: IconButton(
                  onPressed: () async {
                    final NavigatorState navigation = Navigator.of(context);

                    navigation.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: const Color.fromARGB(250, 66, 66, 66),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final NavigatorState navigation = Navigator.of(context);
                        await NotesDatabase.instance.deleteNote(widget.noteID!);
                        navigation.pop();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: const Color.fromARGB(250, 66, 66, 66),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => AddUpdate(
                                  note: widget.note,
                                )),
                          ),
                        );

                        refreshNotes();
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                note?.title ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: "Vfont",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              title: Text(
                note?.descriptions ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "Vfont",
                ),
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
    );
  }
}
