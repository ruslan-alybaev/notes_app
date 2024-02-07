import 'package:flutter/material.dart';
import 'package:todo_app/presentations/theme/app_colors.dart';

import '../widgets/note.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

TextEditingController _titleController = TextEditingController();
TextEditingController _contextController = TextEditingController();


@override
void initState() {
    // TODO: implement initState
if(widget.note != null) {
    _titleController = TextEditingController(text: widget.note!.title);
  _contextController = TextEditingController(text: widget.note!.content);
}


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor:AppColors.BGColor,
          body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            child: Column(
              children: [
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                      Icons.arrow_back_ios_new,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
                child: ListView(
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 30,
                        ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Title",
                        hintStyle: TextStyle(
                          color: AppColors.grey,
                          fontSize: 32,
                        )
                      ),
                    ),
                    TextField(
                      controller: _contextController,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                        ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type something here",
                        hintStyle: TextStyle(
                          color: AppColors.grey,
                         
                        )
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, [
                _titleController.text,
                _contextController.text,
              ]);
            },
            elevation: 1,
            backgroundColor: AppColors.IconBGColor,
            child: const Icon(
              Icons.save,
              color: AppColors.black,
            ),
          ),
    );
  }
}