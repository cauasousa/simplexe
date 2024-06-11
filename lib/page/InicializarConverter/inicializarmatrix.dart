import 'package:flutter/material.dart';
import 'package:matrices/matrices.dart';
import 'package:simplexe/page/PageOfTableau/pageBigM.dart';
import 'package:simplexe/page/SimplexRevisado/simplexx.dart';

// ignore: must_be_immutable
class Resultado extends StatelessWidget {
  int artificial = 0;
  int qntResticao;
  int qntVariavel;
  int qntVariavelX;
  List<int> posIgualdades;
  List<List<double>> matrizR;
  List<List<double>> matrizB;
  List<List<double>> matrizb;
  List<double> matrizCr;
  List<double> matrizCb;
  List<List<double>> matrizCompleta;

  Resultado({
    required this.posIgualdades,
    required this.artificial,
    required this.matrizCompleta,
    required this.qntVariavel,
    required this.qntVariavelX,
    required this.qntResticao,
    required this.matrizR,
    required this.matrizB,
    required this.matrizb,
    required this.matrizCr,
    required this.matrizCb,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (artificial > 0 || posIgualdades.isNotEmpty) {
      return PageTableM(
        matrizCompleta: incializarMatrizCompleta(),
        qntResticoes: qntResticao,
        qntVariavel: qntVariavel,
        artificial: artificial,
        posIgualdade: posIgualdades,
      );
    } else {
      return RSimplexRevisado(
          qntVariavelArtificial: artificial,
          qntVariavel: qntVariavel + artificial,
          qntResticao: qntResticao,
          matrizR: incializarmatrizR(),
          matrizB: incializarmatrizB(),
          matrizb: incializarmatrizb(),
          matrizCr: incializarmatrizCr(),
          matrizCb: incializarmatrizCb());
    }
  }

  Matrix incializarMatrizCompleta() {
    Matrix matrizCompletaFormatada = Matrix.fromList(matrizCompleta);
    return matrizCompletaFormatada;
  }

  Matrix incializarmatrizR() {
    Matrix matrizCompletaFormatada = Matrix.fromList(matrizR);
    return matrizCompletaFormatada;
  }

  SquareMatrix incializarmatrizB() {
    SquareMatrix matrizCompletaFormatada = SquareMatrix.fromList(matrizB);
    return matrizCompletaFormatada;
  }

  Matrix incializarmatrizb() {
    Matrix matrizCompletaFormatada = Matrix.fromList(matrizb);
    return matrizCompletaFormatada;
  }

  Matrix incializarmatrizCr() {
    Matrix matrizCompletaFormatada = Matrix.fromList([matrizCr]);
    return matrizCompletaFormatada;
  }

  Matrix incializarmatrizCb() {
    Matrix matrizCompletaFormatada = Matrix.fromList([matrizCb]);
    return matrizCompletaFormatada;
  }
}

