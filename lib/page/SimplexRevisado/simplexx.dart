// ignore: must_be_immutable
import 'package:matrices/matrices.dart';
// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:simplexe/page/PageDoResultadoFinal/resultadofinal.dart';

// ignore: must_be_immutable
class RSimplexRevisado extends StatefulWidget {
  int qntResticao;
  int qntVariavel;
  int qntVariavelArtificial;
  Matrix matrizR;
  SquareMatrix matrizB;

  SquareMatrix? matrizBOriginal;
  Matrix matrizb;
  Matrix matrizCr;
  Matrix matrizCb;
  List<int> base = [];

  RSimplexRevisado({
    super.key,
    required this.qntVariavel,
    required this.qntVariavelArtificial,
    required this.qntResticao,
    required this.matrizR,
    required this.matrizB,
    required this.matrizb,
    required this.matrizCr,
    required this.matrizCb,
  }) {
    base = List.generate(
        matrizR.columnCount + matrizB.columnCount, (index) => index);
    List<List<double>> borigin = List.generate(
        matrizB.columnCount,
        (index) => List.generate(
            matrizB.columnCount, (linha) => matrizB[index][linha]));
    matrizBOriginal = SquareMatrix.fromList(borigin);
  }

  @override
  State<RSimplexRevisado> createState() => _RSimplexState();
}

class _RSimplexState extends State<RSimplexRevisado> {
  int posRowLess = -1;

  var asteriskFO = Matrix.fromList([
    [0.0]
  ]);

  bool atulizaPrimeiraPage = false;

  bool primeiraInteracao = false;

  // ignore: prefer_typing_uninitialized_variables
  var asteriskMatrizb;

  bool existeMenorCr(matrizCrr) {
    for (int i = 0; i < matrizCrr.columnCount; i++) {
      if (matrizCrr[0][i] < 0) {
        return true;
      }
    }
    return false;
  }

  void simplex() {
    if (existeMenorCr(widget.matrizCr)) {
      if (primeiraInteracao == false) {
        setState(() {
          primeiraVez();
        });

        primeiraInteracao = true;
        return;
      } else {
        if (verificacao() == false) {
          setState(() {
            pivotando();
          });
        }
      }
    } else {
      verificacao();
    }
  }

  int colunadoMenorCr(matriz, bool ativarMultipla) {
    // tenho certeza que tem alguem menor
    int indexMenorColuna = 0;

    for (int i = 0; i < widget.qntVariavel; i++) {
      if (matriz[0][i] < matriz[0][indexMenorColuna] ||
          (ativarMultipla == true && matriz[0][i] == 0)) {
        if (ativarMultipla == true) {
          return i;
        }
        indexMenorColuna = i;
      }
    }
    return indexMenorColuna;
  }

  int linha(matrizRa, int colunadaRazao, matrizba) {
    int indexRazaoMenor = 0;
    bool primeiraInteracao = false;
    for (int i = 0; i < widget.qntResticao; i++) {
      if (matrizRa[i][colunadaRazao] <= 0 ||
          matrizba[i][0] == 0){
          // (matrizRa[i][colunadaRazao] < 0)){
          // (matrizRa[i][colunadaRazao] > 0 && (matrizba[i][0] < 0) == true)) {
        // faz nada no momento
      } else {
        var razao = matrizba[i][0] / matrizRa[i][colunadaRazao];
        var razaoDoMenor = matrizba[indexRazaoMenor][0] /
            matrizRa[indexRazaoMenor][colunadaRazao];

        if (primeiraInteracao == false) {
          indexRazaoMenor = i;
          primeiraInteracao = true;
        }
        if (razao <= razaoDoMenor) {
          indexRazaoMenor = i;
        }
      }
    }

    return indexRazaoMenor;
  }

  int posDaColunaNaMatrizB(int linha) {
    int acharOmenorNaAntigaColunaDeUm = 0;

    for (int j = 0; j < widget.qntResticao; j++) {
      if (widget.matrizBOriginal![linha][j] == 1) {
        return j;
      }
    }
    return acharOmenorNaAntigaColunaDeUm;
  }

  void trocar(int colunaSai, int colunaEntra) {
    for (int i = 0; i < widget.qntResticao; i++) {
      var aux = widget.matrizB[i][colunaSai];
      widget.matrizB[i][colunaSai] = widget.matrizR[i][colunaEntra];
      widget.matrizR[i][colunaEntra] = aux;
    }

    var aux = widget.matrizCb[0][colunaSai];
    widget.matrizCb[0][colunaSai] = widget.matrizCr[0][colunaEntra];
    widget.matrizCr[0][colunaEntra] = aux;

    var auxSairBase = widget.base[widget.qntVariavel + colunaSai];
    widget.base[widget.qntVariavel + colunaSai] = widget.base[colunaEntra];
    widget.base[colunaEntra] = auxSairBase;
  }

  void primeiraVez() {
    if (existeMenorCr(widget.matrizCr)) {
      int indexDaColunaQueVaiEntrarNaMatrizB =
          colunadoMenorCr(widget.matrizCr, false); //  usar

      int linhaDaRazaoMenor = linha(
          widget.matrizR, indexDaColunaQueVaiEntrarNaMatrizB, widget.matrizb);

      int posDaColunaQueVaiSairDaMatrizB =
          posDaColunaNaMatrizB(linhaDaRazaoMenor); //  usar

      trocar(
          posDaColunaQueVaiSairDaMatrizB, indexDaColunaQueVaiEntrarNaMatrizB);
    }
  }

  void pivotando({bool ativarMulti = false}) {
    var inversa = widget.matrizB.inverse;
    var asteriskMatrizCr =
        widget.matrizCr - widget.matrizCb * inversa * widget.matrizR;
    asteriskMatrizb = inversa * widget.matrizb;
    var asteriskMatrizR = inversa * widget.matrizR;

    int indexDaColunaQueVaiEntrarNaMatrizB =
        colunadoMenorCr(asteriskMatrizCr, ativarMulti); //  usar

    int linhaDaRazaoMenor = linha(
        asteriskMatrizR, indexDaColunaQueVaiEntrarNaMatrizB, asteriskMatrizb);

    int posDaColunaQueVaiSairDaMatrizB =
        posDaColunaNaMatrizB(linhaDaRazaoMenor); //  usar

    trocar(posDaColunaQueVaiSairDaMatrizB, indexDaColunaQueVaiEntrarNaMatrizB);
  }

  bool multiplaSolucao() {
    var inversa = widget.matrizB.inverse;
    var asteriskMatrizCr =
        widget.matrizCr - widget.matrizCb * inversa * widget.matrizR;

    if (!existeMenorCr(asteriskMatrizCr)) {
      for (int i = 0; i < widget.qntVariavel; i++) {
        if (asteriskMatrizCr[0][i] == 0) {
          return true;
        }
      }
    }
    return false;
  }

  bool ilimitadaSolucao() {
    var inversa = widget.matrizB.inverse;
    var asteriskMatrizCr =
        widget.matrizCr - widget.matrizCb * inversa * widget.matrizR;

    if (existeMenorCr(asteriskMatrizCr)) {
      int indexMenor = 0;

      for (int i = 0; i < widget.qntVariavel; i++) {
        if (asteriskMatrizCr[0][i] < asteriskMatrizCr[0][indexMenor]) {
          indexMenor = i;
        }
      }

      var asteriskMatrizbTemporario = inversa * widget.matrizb;
      var asteriskMatrizR = inversa * widget.matrizR;

      int qntDeErro = 0;
      for (int i = 0; i < widget.qntResticao; i++) {
        try {
          var teste =
              asteriskMatrizbTemporario[i][0] / asteriskMatrizR[i][indexMenor];
          if(asteriskMatrizR[i][indexMenor] <= 0 || teste < 0 ) {
            qntDeErro += 1;
          }
        } catch (e) {
          qntDeErro += 1;
        }
      }

      if (qntDeErro == widget.qntResticao) {
        return true;
      }
    }
    return false;
  }

  bool otimaSolucao() {
    var inversa = widget.matrizB.inverse;
    var asteriskMatrizCr =
        widget.matrizCr - widget.matrizCb * inversa * widget.matrizR;
    int qntPositiva = 0;

    for (int i = 0; i < widget.qntVariavel; i++) {
      if (asteriskMatrizCr[0][i] > 0) {
        qntPositiva += 1;
      }
    }

    if (qntPositiva == widget.qntVariavel) {
      asteriskMatrizb = inversa * widget.matrizb;
      return true;
    }

    return false;
  }

  bool verificacao() {
    if (multiplaSolucao()) {
      var inversa = widget.matrizB.inverse;
      var copiab = inversa * widget.matrizb;

      var matrizVari = List.generate(widget.qntResticao + widget.qntVariavel,
          (index) => widget.base[index].toString());

      pivotando(ativarMulti: true);

      inversa = widget.matrizB.inverse;
      asteriskMatrizb = inversa * widget.matrizb;
      navigaionMulti(copiab, matrizVari);
      return true;
    } else if (ilimitadaSolucao() == true) {
      navigaionIlimitado();
      return true;
    } else if (otimaSolucao()) {
      var inversa = widget.matrizB.inverse;
      asteriskMatrizb = inversa * widget.matrizb;
      navigaion();
      return true;
    }

    return false;
  }

  void navigaion() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RFinalOtimo(
              matrizVari: widget.base,
              matrizb: asteriskMatrizb,
              qntRestricao: widget.qntResticao,
              qntVariavel: widget.qntVariavel,
              asteriskFO: asteriskFO,
            ),
          ));
    });
  }

  void navigaionMulti(matrizbcopia, matrizVaricopia) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RFinalMultipla(
              matrizVari: widget.base,
              matrizVaricopia: matrizVaricopia,
              matrizb: asteriskMatrizb,
              matrizbcopia: matrizbcopia,
              qntRestricao: widget.qntResticao,
              qntVariavel: widget.qntVariavel,
              asteriskFO: asteriskFO,
            ),
          ));
    });
  }

  void navigaionIlimitado() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RFinalIlimitado(),
          ));
    });
  }

  String tes() {
    var inversa = widget.matrizB.inverse;
    asteriskFO = widget.matrizCb * inversa * widget.matrizb;
    return '${asteriskFO[0][0]}';
  }

  // apartir daqui é somente a tela
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'R',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      SizedBox(width: 140),
                      Text(
                        'B',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 2.0,
                          ),
                        ),
                        width: 150,
                        height: 150,
                        child: tableR(widget.matrizR, widget.qntResticao,
                            widget.qntVariavel),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 2.0,
                          ),
                        ),
                        width: 150,
                        height: 150,
                        child: tableR(widget.matrizB, widget.qntResticao,
                            widget.qntResticao),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cr',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    SizedBox(width: 140),
                    Text(
                      'Cb',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 2.0,
                        ),
                      ),
                      width: 150,
                      height: 150,
                      child: tableR(widget.matrizCr, 1, widget.qntVariavel),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 2.0,
                        ),
                      ),
                      width: 150,
                      height: 150,
                      child: tableR(widget.matrizCb, 1, widget.qntResticao),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                'b',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              width: 90,
                              height: 100,
                              child: tableb(widget.matrizb, widget.qntResticao),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'FO:',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255), 
                                  width: 2.0, 
                                ),
                              ),
                              width: 90,
                              height: 50,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(tes()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          ElevatedButton(
                            onPressed: simplex,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0052CC),
                              shape: const ContinuousRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableR(Matrix matriz, int qntrest, int qntvar) {
    return ListView(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              for (int i = 0; i < qntrest; i++)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int j = 0; j < qntvar; j++)
                            Row(
                              children: [
                                SizedBox(
                                  width: 65,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: Text(' ${matriz[i][j]}'),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text('|'),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tableb(Matrix matriz, int qntrest) {
    return ListView(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              for (int i = 0; i < qntrest; i++)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text(' ${matriz[i][0]}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

}