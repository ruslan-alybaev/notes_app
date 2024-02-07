import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/presentations/screens/edit.dart';
import 'package:todo_app/presentations/theme/app_colors.dart';
import 'package:todo_app/presentations/widgets/confirmDialog.dart';
import 'package:todo_app/presentations/widgets/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotes = [];
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes;
  }

  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    // сортирует по дате создания
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;
    return notes;
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      // чтобы выдавал именно поисковые записи
      filteredNotes = sampleNotes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) {
    // метод для удаления заметки
    setState(() {
      Note note = filteredNotes[index];
      sampleNotes.remove(note);
      filteredNotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BGColor,
      body: Padding(
        // header
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      filteredNotes = sortNotesByModifiedTime(filteredNotes);
                    });
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.IconBGColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.sort,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: TextField(
                onTap: () {
                  // Снимаем фокус с TextField при нажатии вне него
                  FocusScope.of(context).unfocus();
                },
                // поисковик
                onChanged: onSearchTextChanged,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  hintText: "Search notes...",
                  hintStyle: const TextStyle(
                    color: AppColors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.grey,
                  ),
                  fillColor: AppColors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Expanded(
                // заметки
                child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  // предназначен для оформления контента в виде карточки с тенью
                  elevation: 3, // поднимает над остальным контентом
                  color: AppColors.white,
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      //  для представления информации в виде строки с иконкой, заголовком, подзаголовком и значком справа.
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditScreen(
                              note: filteredNotes[
                                  index], // открывает заметку с сохранившимися значениями
                            ),
                          ),
                        );
                        if (result != null) {
                          // для того чтобы могли вносить и сохранять изменения уже в существующих заметках

                          setState(() {
                            int originalINdex =
                                sampleNotes.indexOf(filteredNotes[index]);

                            sampleNotes[originalINdex] = Note(
                                id: sampleNotes[originalINdex].id,
                                title: result[0],
                                content: result[1],
                                modifiedTime: DateTime.now());

                            filteredNotes[index] = Note(
                                id: filteredNotes[index].id,
                                title: result[0],
                                content: result[1],
                                modifiedTime: DateTime.now());
                            filteredNotes = sampleNotes;
                          });
                        }
                      },
                      title: RichText(
                        // позволяет создавать текст с различными стилями форматирования внутри одного виджета текста. Это полезно, когда вы хотите, чтобы части текста имели разные цвета, шрифты, размеры или другие стили.
                        maxLines:
                            3, // выставляет максимальное количество строк, то есть 3 для title и 2 для content
                        overflow: TextOverflow
                            .ellipsis, // если текст не поместился, он его обрезает и за счет.ellipsis добавляет многоточие в конце
                        text: TextSpan(
                          // представляет собой отдельный сегмент текста с определенными стилями.
                          text: "${filteredNotes[index].title} :\n",
                          style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                                // представляет собой отдельный сегмент текста с определенными стилями.
                                text: filteredNotes[index].content,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.5,
                                ))
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Text(
                          "Edited: ${DateFormat("EEE MMM d, yyyy h:mm a").format(filteredNotes[index].modifiedTime)}",
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: AppColors.grey800,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () async {
                            final result = await confirmDialog(context);
                            if (result != null && result) {
                              deleteNote(index);
                            }
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  ),
                );
              }, // чтобы могли листать
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // виджет, представляющий собой круглую кнопку, обычно расположенную в нижнем правом углу экрана.
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              sampleNotes.add(Note(
                  id: sampleNotes.length,
                  title: result[0],
                  content: result[1],
                  modifiedTime: DateTime.now()));
              filteredNotes = sampleNotes;
            });
          }
        },
        backgroundColor: AppColors.IconBGColor,
        child: const Icon(
          Icons.add,
          size: 38,
          color: AppColors.black,
        ),
      ),
    );
  }
}
