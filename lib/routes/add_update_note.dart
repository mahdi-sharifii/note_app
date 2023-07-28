import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../models/note.dart';

class AddUpdate extends StatefulWidget {
  final Note? note;

  const AddUpdate({
    super.key,
    this.note,
  });

  @override
  State<AddUpdate> createState() => _AddUpdateState();
}

class _AddUpdateState extends State<AddUpdate> {
  bool val = false;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  Widget elevatedBt() {
    bool val = _title.text.isNotEmpty && _description.text.isNotEmpty;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.cyan;
            } else if (states.contains(MaterialState.disabled)) {
              return Colors.blueGrey;
            }

            return Colors.cyan;
          },
        ),
      ),
      onPressed: val
          ? () async {
              if (widget.note == null) {
                await addNote();
              } else {
                await updateNote();
              }
            }
          : null,
      child: const Text("S A V E"),
    );
  }

  Note? note;
  bool isLoading = false;
  @override
  void initState() {
    if (widget.note != null) {
      _title.text = widget.note!.title!;
      _description.text = widget.note!.descriptions!;
    }

    super.initState();
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      gapPadding: 20,
      borderRadius: BorderRadius.circular(25.0),
    );
  }

  Future addNote() async {
    final NavigatorState navigator = Navigator.of(context);
    final note = Note(
      title: _title.text,
      descriptions: _description.text,
    );
    await NotesDatabase.instance.create(note);
    navigator.pop();
  }

  updateNote() async {
    final NavigatorState navigator = Navigator.of(context);
    final note = widget.note!.copy(
      title: _title.text,
      description: _description.text,
    );
    await NotesDatabase.instance.updateNotes(note);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: const Color.fromARGB(250, 66, 66, 66),
          ),
          child: IconButton(
            onPressed: () {
              final NavigatorState navigation = Navigator.of(context);
              navigation.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),
      body: (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {});
                },
                controller: _title,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Title",
                  labelStyle: const TextStyle(color: Colors.white),
                  fillColor: Colors.white38,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(250, 70, 70, 70),
                      width: 5.0,
                    ),
                  ),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {});
                },
                maxLines: 7,
                controller: _description,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Description",
                  labelStyle: const TextStyle(color: Colors.white),
                  fillColor: Colors.white24,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(250, 70, 70, 70),
                      width: 5.0,
                    ),
                  ),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          elevatedBt()
        ],
      )),
    );
  }
}
