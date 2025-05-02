import 'dart:io';
import 'dart:math';

import 'package:elektrochem/plot.dart';
import 'package:elektrochem/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<File> writefile(String path, String filler) async {
  final file = File(path);

  // Write the file
  return file.writeAsString(filler);
}

class NazwaW extends StatefulWidget {
  final String title;

  const NazwaW({super.key, required this.title});

  @override
  State<NazwaW> createState() => _NazwaWState();
}

String getSupportiveComment() {
  final comments = [
    "Świetna robota! Tak trzymaj!",
    "Jesteś na dobrej drodze 💪",
    "Każdy krok się liczy – brawo!",
    "Nie poddawaj się, idzie Ci super!",
    "Twoje zaangażowanie robi wrażenie!",
    "Działasz – to najważniejsze!",
    "Masz to! Wierzę w Ciebie!",
    "Jesteś bliżej celu niż myślisz!",
    "Nie ma rzeczy niemożliwych – działaj dalej!",
    "Twój wysiłek się opłaci!",
    "Duma mnie rozpiera – super robota!",
    "Jeszcze chwila i będzie sukces!",
    "Codziennie jesteś lepszy/a!",
    "To, co robisz, ma znaczenie!",
    "Odważny krok naprzód – gratulacje!",
    "Jesteś inspiracją!",
    "Nigdy nie przestawaj wierzyć w siebie!",
    "Z każdym kliknięciem rośniesz w siłę!",
    "Robisz coś wspaniałego – nie przestawaj!",
    "Ten wysiłek to inwestycja w lepsze jutro!",
    "Twoja determinacja to Twoja supermoc!",
    "Robisz różnicę – kontynuuj to!",
    "Jesteś niesamowity/a – świat tego potrzebuje!",
  ];

  final random = Random();
  return comments[random.nextInt(comments.length)];
}

class _NazwaWState extends State<NazwaW> {
  late String pathI = ("Brak");
  late String pathO = ("Brak");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Color.fromARGB(255, 119, 117, 175),
          height: 35,
          child: Row(
            children: [
              TextButton(
                onPressed: () async {
                  //String? result = await FilePicker.platform.getDirectoryPath(
                  // dialogTitle: 'Please select a directory:',
                  // );
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(dialogTitle: 'Please select an input file:');

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    pathI = file.path.toString();
                  } else {
                    // User canceled the picker
                  }
                  setState(() {});
                },
                child: Text("Open", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () async {
                  String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: 'Please select an output file:',
                    fileName: 'output-file.txt',
                  );

                  if (outputFile == null) {
                  } else {
                    pathO = outputFile.toString();
                    writefile(pathO, "kontent");
                  }

                  setState(() {});
                },
                child: Text("Save", style: TextStyle(color: Colors.white)),
              ),
              //TextButton(
              // onPressed: () async {
              //  String? outputFile = await FilePicker.platform.saveFile(
              //    dialogTitle: 'Please select an output file:',
              //    fileName: 'output-file.pdf',
              //  );

              //  if (outputFile == null) {
              //    // User canceled the picker
              //    pathF = (" ");
              //   } else {
              //    pathF = outputFile.toString();
              // }
              //
              //  setState(() {});
              // },
              // child: Text("Export", style: TextStyle(color: Colors.white)),
              //   ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Extra",
                  style: TextStyle(color: Colors.white),
                ), // typu okno dialogowe do ręcznego wpisania wszystkiego bez konieczności wybierania plików po ściezkach
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Scaffold(body: Text(getSupportiveComment())),
                      ));
                },
                child: Text("Help", style: TextStyle(color: Colors.white)),
              ),

              Expanded(
                child: Text(
                  "Working directory: $pathI",
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(width: 7.0, height: 60),
            ],
          ),
        ),
        SizedBox(height: 7),
        Ploter(path: pathI),
      ],
    );
  }
}
