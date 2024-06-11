import 'package:flutter/material.dart';

class RFinalOtimoBIGM extends StatelessWidget {
  RFinalOtimoBIGM(this.matriVar1, this.b1, {super.key});

  // ignore: prefer_typing_uninitialized_variables
  var matriVar1, b1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00214F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00214F),
        title: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SIMPLEX',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 252, 252, 252),
                ),
              ),
              SizedBox(
                width: 50,
              )
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'PPL SOLUÇÃO ÓTIMA',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
              ResultadoBIGM(matriVar1, b1),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultadoBIGM extends StatelessWidget {
  ResultadoBIGM(this.matriVar1, this.b1, {super.key});
  List matriVar1, b1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(104, 1, 49, 117),
      ),
      height: calcular(),
      width: 350,
      child: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < matriVar1.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          'X${matriVar1[i]} = ${b1[i]},',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  'Resultando em ${-b1[b1.length - 1]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
    var mul = matriVar1.length + 0.5;
    if (mul < 8) return mul * 45;
    return 500;
  }
}

class RFinalInviavel extends StatelessWidget {
  const RFinalInviavel({super.key});

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
              'PPL INVIÁVEL !',
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

class RFinalMultiplaBIGM extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var matriVar1, b1, matriVar2, b2;

  RFinalMultiplaBIGM(this.matriVar1, this.b1, this.matriVar2, this.b2,
      {super.key});

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
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'PPL DE MÚLTIPLAS SOLUÇÕES',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                Row(
                  children: [
                    ResultadoBIGM(matriVar1, b1),
                  ],
                ),
                const Text(
                  'Uma Segunda Solução',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                Row(
                  children: [
                    ResultadoBIGM(matriVar2, b2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
