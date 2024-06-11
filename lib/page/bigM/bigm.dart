// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:matrices/matrices.dart';
import 'package:simplexe/page/PageDoResultadoFinal/resultadobigmpage.dart';
import 'package:simplexe/page/PageDoResultadoFinal/resultadofinal.dart';

// ignore: must_be_immutable
class SoluBIG extends StatefulWidget {
  Matrix matrizCompleta;
  int qntVariavel = 0;
  int artificial = 0;
  int qntRestricoes = 0;
  List<int> posIgualdade;

  SoluBIG(
      {required this.matrizCompleta,
      required this.posIgualdade,
      required this.qntVariavel,
      required this.artificial,
      required this.qntRestricoes,
      super.key});

  @override
  State<SoluBIG> createState() =>
      
      _SoluBIGState(
          posIgualdade: posIgualdade,
          qntVariavel: qntVariavel,
          artificial: artificial,
          matrizCompleta: matrizCompleta,
          qntResticao: qntRestricoes);
}

class _SoluBIGState extends State<SoluBIG> {
  int artificial = 0;
  int posTroca = 0;
  int qntResticao;
  int qntVariavel;
  Matrix matrizCompleta;
  int aperteiB = 0;
  bool pivotamento = true;
  List posVari = [];
  List<int> posIgualdade;
  int contMultipSol = 0;
  int qntDePivotInserirArtif = 0;
  // ignore: prefer_typing_uninitialized_variables
  var copiaResultado1;
  // ignore: prefer_typing_uninitialized_variables
  var copiaResultado2;
  _SoluBIGState(
      {required this.matrizCompleta,
      required this.qntVariavel,
      required this.posIgualdade,
      required this.artificial,
      required this.qntResticao}) {
    ordenar();
  }

  void ordenar() {
    int um = 0, zero = 0;
    posVari = List.generate(
        qntResticao, (index) => posIgualdade.contains(index) ? '' : index);
    for (int i = 0; i < matrizCompleta.columnCount - 1; i++) {
      zero = 0;
      um = 0;
      int posadd = 0;
      for (int j = 0; j < qntResticao; j++) {
        if (matrizCompleta[j][i] == 0) {
          zero += 1;
        } else if (matrizCompleta[j][i] == 1) {
          um += 1;
          posadd = j;
        }

        if ((um == 1 && zero == (qntResticao - 1))) {
          posVari[posadd] = i;
        }
      }
    }
  }

  void multiplicarLinhas(
      int linhaDOMultip, int colunaMulti, int linhaSubtrair) {
    var multiplicador = -matrizCompleta[linhaSubtrair][colunaMulti];

    for (int i = 0; i < matrizCompleta.columnCount; i++) {
      matrizCompleta[linhaSubtrair][i] =
          (matrizCompleta[linhaDOMultip][i] * multiplicador) +
              matrizCompleta[linhaSubtrair][i];
    }
  }

  void transfUM(int linhaEntra, int colunaEntra) {
    var div = matrizCompleta[linhaEntra][colunaEntra];

    for (int i = 0; i < matrizCompleta.columnCount; i++) {
      matrizCompleta[linhaEntra][i] = matrizCompleta[linhaEntra][i] / div;
    }
  }

  int naoprecisocolunaDoUM(int linhaDaRazaoMnr) {
    int qntUm = 0;
    int qntZr = 0;
    for (int i = 0; i < matrizCompleta.columnCount - 1; i++) {
      if (matrizCompleta[linhaDaRazaoMnr][i] == 0) qntZr += 1;
      if (matrizCompleta[linhaDaRazaoMnr][i] == 1) qntUm += 1;

      if (qntZr == qntResticao - 1 && qntUm == 1) return i;
    }

    return 0;
  }

  void pivotarArtificial() {
    var colunaDaArtifical =
        matrizCompleta.columnCount - 2 - qntDePivotInserirArtif;

    for (int i = 0; i < qntResticao; i++) {
      if (matrizCompleta[i][colunaDaArtifical] == 1) {
        // achei a linha
        multiplicarLinhas(i, colunaDaArtifical, qntResticao);
        return;
      }
    }
  }

  int colunaMr() {
    int indexMr = 0;
    bool prim = false;

    for (int i = 0; i < matrizCompleta.columnCount - 1; i++) {
      if (matrizCompleta[qntResticao][i] < 0) {
        if (prim == false) {
          prim = true;
          indexMr = i;
        } else if (matrizCompleta[qntResticao][i] <
            matrizCompleta[qntResticao][indexMr]) {
          indexMr = i;
        }
      }
    }

    return indexMr;
  }

  int linhaDaRazaoMr(int colunaMr) {
    int linhaMr = 0;
    bool prim = false;

    for (int i = 0; i < qntResticao; i++) {
      try {
        var razao = matrizCompleta[i][matrizCompleta.columnCount - 1] /
            matrizCompleta[i][colunaMr];

        if (matrizCompleta[i][colunaMr] <= 0) continue;

        var razaoMranterio = matrizCompleta[linhaMr]
                [matrizCompleta.columnCount - 1] /
            matrizCompleta[linhaMr][colunaMr];

        if (razao >= 0) {
          if (prim == false) {
            linhaMr = i;
            prim = true;
          } else if (razao < razaoMranterio) {
            linhaMr = i;
          }
        }
        // ignore: empty_catches
      } catch (e) {}
    }
    return linhaMr;
  }

  // Faça isso quando chamar normalmente->  int colunMr = colunaMr();
  void pivotando(int colunMr) {
    // int colunMr = colunaMr();
    int linhaDaRazaMr = linhaDaRazaoMr(colunMr);

    transfUM(linhaDaRazaMr, colunMr);

    for (int i = 0; i <= qntResticao; i++) {
      if (i != linhaDaRazaMr) {
        multiplicarLinhas(linhaDaRazaMr, colunMr, i);
      }
    }
    ordenar();
  }

  bool exitemenor() {
    for (int i = 0; i < matrizCompleta.columnCount - 1; i++) {
      if (matrizCompleta[qntResticao][i] < 0) {
        return true;
      }
    }
    return false;
  }

  bool ppIlimitado() {
    ///existe um menor para chamar isso
    int colunadoMr = colunaMr();
    int qntFalha = 0;

    for (int i = 0; i < qntResticao; i++) {
      try {
        var razao = matrizCompleta[i][matrizCompleta.columnCount - 1] /
            matrizCompleta[i][colunadoMr];

        if (matrizCompleta[i][colunadoMr] <= 0 || razao < 0) {
          qntFalha += 1;
        }
      } catch (e) {
        qntFalha += 1;
      }
    }

    if (qntFalha == qntResticao) return true;

    return false;
  }

  bool ppInviavel() {
    if (!exitemenor()) {
      for (int i = 0; i < artificial; i++) {
        if (matrizCompleta[qntResticao][matrizCompleta.columnCount - 2 - i] ==
            0) {
          int qntzr = 0;
          int qntUm = 0;
          for (int j = 0; j < qntResticao; j++) {
            if (matrizCompleta[j][matrizCompleta.columnCount - 2 - i] == 0) {
              qntzr += 1;
            } else if (matrizCompleta[j][matrizCompleta.columnCount - 2 - i] ==
                1) {
              qntUm += 1;
            }
            if (qntUm == 1 && qntzr == qntResticao - 1) return true;
          }
        }
      }
    }
    return false;
  }

  int? ppMultipla() {
    if (!exitemenor()) {
      for (int i = 0; i < matrizCompleta.columnCount - 1; i++) {
        if (matrizCompleta[qntResticao][i] == 0) {
          int qntzr = 0;
          int qntUm = 0;
          for (int j = 0; j < qntResticao; j++) {
            if (matrizCompleta[j][i] == 0) {
              qntzr += 1;
            } else if (matrizCompleta[j][i] == 1) {
              qntUm += 1;
            }
          }

          if ((qntUm == 1 && qntzr == qntResticao - 1) == false) return i;
        }
      }
    }
    return null;
  }

  bool verificao() {
    // de acordo com a lógica, não existe número negativo aqui
    if (ppInviavel()) {
      navigaionInviavel();
      return true;
    }
    int? colunaZr = ppMultipla();
    if (colunaZr != null) {
      if (contMultipSol == 0) {
        copiaResultado1 = converterMultipla();
        pivotando(colunaZr);
        contMultipSol += 1;
      } else {
        copiaResultado2 = converterMultipla();
        navigaionMulti(copiaResultado1, copiaResultado2);
      }
      return true;
    } else {
      var possuiVariavelDaIgualdadeSemBase = posVari.contains('');
      if (possuiVariavelDaIgualdadeSemBase) {
        navigaionInviavel();
        return true;
      }
    }
    navigaion();

    return true;
  }

  void bigM() {
    if (qntDePivotInserirArtif < artificial) {
      setState(() {
        pivotarArtificial();
        qntDePivotInserirArtif++;
      });
    } else {
      // se existir menor -> ilimitado/
      if (exitemenor()) {
        if (ppIlimitado()) {
          navigaionIlimitado();
        } else {
          setState(() {
            pivotando(colunaMr());
          });
        }
      } else {
        verificao();
      }
      return;
    }
  }

  List<List> converterMultipla() {
    List matrizVari = List.generate(posVari.length, (index) => posVari[index]);

    List b = List.generate(qntResticao + 1,
        (index) => matrizCompleta[index][matrizCompleta.columnCount - 1]);

    return [matrizVari, b];
  }

  void navigaion() {
    var copiaResultado1 = converterMultipla();
    var matriVar1 = copiaResultado1[0];
    var b1 = copiaResultado1[1];
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RFinalOtimoBIGM(matriVar1, b1),
          ));
    });
  }

  void navigaionMulti(copiaResultado1, copiaResultado2) {
    var matriVar1 = copiaResultado1[0];
    var b1 = copiaResultado1[1];

    var matriVar2 = copiaResultado2[0];
    var b2 = copiaResultado2[1];
    
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RFinalMultiplaBIGM(matriVar1, b1, matriVar2, b2),
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

  void navigaionInviavel() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RFinalInviavel(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border.symmetric(
                  horizontal: BorderSide(width: 2),
                  vertical: BorderSide(width: 2),
                )),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  height: calcular(),
                  child: ListView(children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: louyt(),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                children: [
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 340,
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          bigM();
                          aperteiB += 1;
                        },
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
                          'Calcular',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calcular() {
    if (qntResticao > 9) return 380;
    return 40 * (qntResticao.toDouble() + 2);
  }

  List<Widget> louyt() {
    List<Widget> dda = [];

    dda.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 40,
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(width: 1),
                vertical: BorderSide(width: 1),
              ),
            ),
            child: const Text(' '),
          ),
        ),
        for (int j = 0; j < matrizCompleta.columnCount - 1; j++)
          SizedBox(
            width: 80,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(width: 1),
                  vertical: BorderSide(width: 1),
                ),
              ),
              child: Text('X$j'),
            ),
          ),
        SizedBox(
          width: 80,
          height: 40,
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(width: 1),
                vertical: BorderSide(width: 1),
              ),
            ),
            child: const Text('b'),
          ),
        ),
      ],
    ));

    for (int i = 0; i <= widget.qntRestricoes; i++) {
      List<Widget> linhaSecundaria = [
        SizedBox(
          width: 80,
          height: 40,
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(width: 1),
                vertical: BorderSide(width: 1),
              ),
            ),
            child: i != widget.qntRestricoes
                ? Text('X${posVari[i]}')
                : const Text('FO'),
          ),
        ),
      ];

      for (int j = 0; j < matrizCompleta.columnCount - 1; j++) {
        linhaSecundaria.add(
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 80,
                    height: 40,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(width: 1),
                          vertical: BorderSide(width: 1),
                        ),
                      ),
                      child: Text('${matrizCompleta[i][j]}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      dda.add(Row(
        children: [
          Row(
            children: linhaSecundaria,
          ),
          SizedBox(
            width: 80,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(width: 1),
                  vertical: BorderSide(width: 1),
                ),
              ),
              child:
                  Text('${matrizCompleta[i][matrizCompleta.columnCount - 1]}'),
            ),
          )
        ],
      ));
    }

    return dda;
  }

  Widget linha(j) {
    if (widget.qntVariavel - j > 1) {
      return const Text('|');
    } else {
      return const SizedBox.shrink();
    }
  }
}


