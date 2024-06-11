import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RFinalOtimo extends StatelessWidget {
  RFinalOtimo(
      {required this.matrizb,
      required this.matrizVari,
      required this.qntVariavel,
      required this.qntRestricao,
      required this.asteriskFO,
      super.key});

  
  var matrizb;
  
  var matrizVari;
  
  var asteriskFO;
  int qntVariavel;
  int qntRestricao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 33, 79, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'SIMPLEX REVISADO',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color(0xFF00214F),
      ),
      body: Resultado(
          asteriskFO: asteriskFO,
          matrizVari: matrizVari,
          matrizb: matrizb,
          qntRestricao: qntRestricao,
          qntVariavel: qntVariavel,
        ),
    );
  }
}

// ignore: must_be_immutable
class RFinalMultipla extends StatelessWidget {
  RFinalMultipla(
      {required this.matrizb,
      required this.matrizbcopia,
      required this.matrizVari,
      required this.matrizVaricopia,
      required this.qntVariavel,
      required this.qntRestricao,
      required this.asteriskFO,
      super.key});

  // ignore: prefer_typing_uninitialized_variables
  var matrizb;
  // ignore: prefer_typing_uninitialized_variables
  var matrizbcopia;
  // ignore: prefer_typing_uninitialized_variables
  var matrizVari;
  // ignore: prefer_typing_uninitialized_variables
  var matrizVaricopia;
  // ignore: prefer_typing_uninitialized_variables
  var asteriskFO;
  int qntVariavel;
  int qntRestricao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromRGBO(0, 33, 79, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'SIMPLEX REVISADO',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color(0xFF00214F),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PPL DE MÚLTIPLAS SOLUÇÕES',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Resultado(
                      asteriskFO: asteriskFO,
                      matrizVari: matrizVari,
                      matrizb: matrizb,
                      qntRestricao: qntRestricao,
                      qntVariavel: qntVariavel),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Uma Segunda Solução',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Resultado(
                      asteriskFO: asteriskFO,
                      matrizVari: matrizVaricopia,
                      matrizb: matrizbcopia,
                      qntRestricao: qntRestricao,
                      qntVariavel: qntVariavel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Resultado extends StatelessWidget {
  Resultado(
      {required this.matrizb,
      required this.matrizVari,
      required this.qntVariavel,
      required this.qntRestricao,
      required this.asteriskFO,
      super.key});

  // ignore: prefer_typing_uninitialized_variables
  var matrizb;
  // ignore: prefer_typing_uninitialized_variables
  var matrizVari;
  // ignore: prefer_typing_uninitialized_variables
  var asteriskFO;
  int qntVariavel;
  int qntRestricao;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(104, 1, 49, 117)),
      height: calcular(),
      width: 400,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < qntVariavel; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '-> X${matrizVari[i]} = 0,',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    for (int i = qntVariavel, j = 0; j < qntRestricao; i++, j++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '-> X${matrizVari[i]} = ${matrizb[j][0]}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  'Resultando em ${asteriskFO[0][0]}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calcular() {
    var mul = qntRestricao + qntVariavel + 1;
    if (mul < 8) return mul * 48;
    return 500;
  }
}

class RFinalIlimitado extends StatelessWidget {
  const RFinalIlimitado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 33, 79, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'SIMPLEX REVISADO',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color(0xFF00214F),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PPL ILIMITADO !',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 40,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}
