import 'package:flutter/material.dart';
import 'package:simplexe/page/PageOfTableau/pagetable.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simplex',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController label1Controler = TextEditingController();

  final TextEditingController label2Controler = TextEditingController();
  String errorTexts = ' ';

  String dropdownValue = '>=';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00214F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SIMPLEX',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                controller: label1Controler,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  counterStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  hintStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                  hoverColor: Color.fromARGB(255, 0, 0, 0),
                  hintText:
                      'Quantas variáveis de decisão tem o problema? Ex: 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                controller: label2Controler,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true, 
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  counterStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  hintStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                  hoverColor: Color.fromARGB(255, 0, 0, 0),
                  hintText: 'Quantas restrições? Ex: 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (label2Controler.text == '' ||
                            label1Controler.text == '') {
                          setState(() {
                            errorTexts = '*Preencha todos os campos';
                          });
                        } else {
                          setState(
                            () {
                              errorTexts = ' ';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PageTable(
                                    qntResticoes:
                                        int.parse(label2Controler.text),
                                    qntVariavel:
                                        int.parse(label1Controler.text),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC),
                        shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    errorTexts,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 253, 253, 253),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}