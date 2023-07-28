import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/note.dart';
import '../db/notes_database.dart';
import 'add_update_note.dart';
import 'view_one_note.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Color> color = [
    const Color.fromARGB(250, 255, 171, 145),
    const Color.fromARGB(250, 255, 204, 128),
    const Color.fromARGB(250, 231, 237, 155),
    const Color.fromARGB(250, 129, 222, 234),
    const Color.fromARGB(250, 207, 148, 218),
    const Color.fromARGB(250, 127, 203, 195),
    const Color.fromARGB(250, 244, 143, 177),
    const Color.fromARGB(250, 239, 221, 180),
    const Color.fromARGB(250, 235, 194, 12),
    const Color.fromARGB(250, 223, 238, 98),
  ];
  int? toolVis;
  Widget tile({
    int? index,
    String? title,
    String? description,
  }) {
    final String le = index.toString();
    int i = int.parse(index.toString()[le.length - 1]);

    return GestureDetector(
      onTap: () => setState(() => toolVis = null),
      onLongPress: () => setState(() => toolVis = index),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 20,
        shadowColor: toolVis == index ? Colors.cyan : Colors.black,
        color: color[i],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    title!.length > 15
                        ? "${title.substring(0, 15)} ..."
                        : title,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontFamily: "Hfont",
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    description!.length > 30
                        ? "${description.substring(0, 30)} ..."
                        : description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontFamily: "Hfont",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: (() async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ViewNote(
                              index: index,
                              noteID: notes![index!]!.id,
                              note: notes![index],
                            ))));
                    refreshNotes();
                  }),
                  icon: const Icon(Icons.visibility),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Note?>? notes;
  Widget delete() => IconButton(
        onPressed: (() async {
          await NotesDatabase.instance.deleteNote(toolVis!);
          await refreshNotes();
        }),
        icon: const Icon(Icons.delete),
      );

  bool isLoading = false;
  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future<void> refreshNotes() async {
    setState(() => isLoading = true);
    await NotesDatabase.instance.readAllNotes().then((value) => notes = value);
    setState(() => toolVis = null);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Visibility(
            visible: toolVis != null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: const Color.fromARGB(250, 66, 66, 66),
              ),
              child: IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => AddUpdate(
                            note: notes![toolVis!],
                          )),
                    ),
                  );

                  refreshNotes();
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Visibility(
            visible: toolVis != null,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: const Color.fromARGB(250, 66, 66, 66),
                ),
                child: delete()),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0, left: 9.0),
          child: Text(
            "Notes",
            style: TextStyle(fontFamily: "Hfont", fontSize: 34),
          ),
        ),
      ),
      body: FutureBuilder(
          future: NotesDatabase.instance.readAllNotes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return isLoading
                ? const Center(child: CircularProgressIndicator())
                : notes!.isEmpty
                    ? Center(child: Image.asset("assets/images/note.png"))
                    : Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: AnimationLimiter(
                          child: GridView.custom(
                            semanticChildCount: 1,
                            gridDelegate: SliverStairedGridDelegate(
                              crossAxisSpacing: 9,
                              mainAxisSpacing: 7,
                              startCrossAxisDirectionReversed: true,
                              pattern: [
                                const StairedGridTile(0.5, 0.93),
                                const StairedGridTile(0.5, 3 / 3.5),
                                const StairedGridTile(1.0, 10 / 4),
                              ],
                            ),
                            childrenDelegate: SliverChildBuilderDelegate(
                                childCount: notes?.length ?? 0,
                                (context, index) =>
                                    AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        child: FadeInAnimation(
                                          child: tile(
                                              index: index,
                                              title: notes?[index]?.title,
                                              description:
                                                  notes?[index]?.descriptions),
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      );
          }),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: const Color.fromARGB(255, 49, 48, 48),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const AddUpdate()),
            ),
          );
          refreshNotes();
        },
        child: const Icon(
          Icons.add,
          size: 31,
        ),
      ),
    );
  }
}
