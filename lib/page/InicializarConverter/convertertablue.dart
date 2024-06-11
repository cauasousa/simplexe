import 'package:flutter/material.dart';
import 'package:simplexe/page/InicializarConverter/inicializarmatrix.dart';

// ignore: must_be_immutable
class Tablue extends StatelessWidget {
  int qntVariavel = 0;
  int qntRestricao = 0;
  
  List<int> posIgualdade = [];
  List<List<String>> selectedOptions;
  List<List<TextEditingController>> selectedControls;
  List<List<TextEditingController>> selectedControlsFO;
  List<List<String>> selectedOptionsFuncionObj;
  List<int> qntDeNoovasVariaveis = [0, 0];
  List<List<double>> matriz = [];
  List<List<double>>? matrizR;
  List<List<double>>? matrizB;
  List<List<double>> matrizb = [];
  List<double>? matrizCr;
  List<double> matrizCb = [];
  int contVariaveisNovas = 0;
  int contVariaveisNovasArtificiais = 0;

  Tablue(
      {required this.qntRestricao,
      required this.qntVariavel,
      required this.selectedControls,
      required this.selectedOptions,
      required this.selectedControlsFO,
      required this.selectedOptionsFuncionObj,
      super.key});

  @override
  Widget build(BuildContext context) {
    convertendoDados();

    return Resultado(
      posIgualdades: posIgualdade,
      qntVariavelX: contVariaveisNovas,
      artificial: contVariaveisNovasArtificiais,
      matrizCompleta: matriz,
      qntVariavel: qntVariavel,
      qntResticao: qntRestricao,
      matrizR: matrizR!,
      matrizB: matrizB!,
      matrizb: matrizb,
      matrizCr: matrizCr!,
      matrizCb: matrizCb,
    );
  }

  void convertendoDados() {
    //verificando se existe alguma restrição com b negativo, então inverter o b para ficar negativo
    for (int i = 0; i < qntRestricao; i++) {
      if (selectedOptions[i][0] == '=') 
      {
        
        posIgualdade.add(i);
      }
      if (double.parse(selectedControls[i][qntVariavel].text) < 0) {
        if (selectedOptions[i][0] == '>=') {
          selectedOptions[i][0] = '<=';
        } else if (selectedOptions[i][0] == '<=') {
          selectedOptions[i][0] = '>=';
        }

        for (int j = 0; j <= qntVariavel; j++) {
          selectedControls[i][j].text =
              (-double.parse(selectedControls[i][j].text)).toString();
        }
      }
    }

    // adicionando a matriz normal aqui
    for (int i = 0; i < qntRestricao; i++) {
      List<double> matrizTemp = [];
      for (int j = 0; j < qntVariavel; j++) {
        matrizTemp.add(double.parse(selectedControls[i][j].text));
      }
      matriz.add(matrizTemp);
    }

    matrizR = List.generate(
      matriz.length,
      (index) => List.generate(
        matriz[index].length,
        (indexx) => matriz[index][indexx],
      ),
    );

    matrizB = List.generate(qntRestricao, (index) => []);

    List<double> matrizFOComp;

    if (selectedOptionsFuncionObj[0][0] == 'Max') {
      matrizCr = List.generate(qntVariavel,
          (index) => -double.parse(selectedControlsFO[index][0].text));

      matrizFOComp = List.generate(qntVariavel,
          (index) => -double.parse(selectedControlsFO[index][0].text));
    } else {
      matrizCr = List.generate(qntVariavel,
          (index) => double.parse(selectedControlsFO[index][0].text));
      matrizFOComp = List.generate(qntVariavel,
          (index) => double.parse(selectedControlsFO[index][0].text));
    }

    double bigm = 0.0;

    for (int j = 0; j < qntRestricao; j++) {
      for (int i = 0; i < qntRestricao; i++) {
        if (selectedOptions[j][0] != '=') {
          if (i == j && selectedOptions[j][0] == '<=') {
            contVariaveisNovas += 1;
            matrizB![i].add(1);
            matriz[i].add(1);
          } else if (i == j && selectedOptions[i][0] == '>=') {
            contVariaveisNovas += 1;
            contVariaveisNovasArtificiais += 1;
            matriz[i].add(-1);
            matrizB![i].add(-1);
          } else {
            matriz[i].add(0);
            matrizB![i].add(0);
          }
        }
      }

      if (selectedOptions[j][0] == '<=') {
        matrizFOComp.add(0);
        matrizCb.add(0);
      } else if (selectedOptions[j][0] == '>=') {
        matrizFOComp.add(0);
        matrizFOComp.add(0);
        matrizCb.add(0);
        matrizCb.add(0);
      }
    }

    matriz.add(matrizFOComp);
    

    for (int j = 0; j < qntRestricao; j++) {
      for (int i = 0; i < qntRestricao; i++) {
        if (selectedOptions[j][0] == '>=') {
          if (i == j) {
            matriz[i].add(1);
          } else {
            matriz[i].add(0);
          }
        }
      }
    }

    for (int i = 0; i < qntRestricao; i++) {
      matrizb.add([double.parse(selectedControls[i][qntVariavel].text)]);

      matriz[i].add(double.parse(selectedControls[i][qntVariavel].text));
    }

    for (int i = 0; i < qntVariavel; i++) {
      bigm += double.parse(selectedControlsFO[i][0].text).abs();
    }

    matriz[qntRestricao].add(0);
    bigm = bigm * 1000;

    for (int i = 0; i < contVariaveisNovasArtificiais; i++) {
      matriz[qntRestricao][qntVariavel + contVariaveisNovas + i] = bigm;
    }
    
  }
}
