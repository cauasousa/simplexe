import 'package:flutter/material.dart';
import 'package:matrices/matrices.dart';
import 'package:simplexe/page/bigM/bigm.dart';

// ignore: must_be_immutable
class PageTableM extends StatefulWidget {
  Matrix matrizCompleta;
  List<int> posIgualdade;

  PageTableM({
    super.key,
    required this.posIgualdade,
    required this.qntResticoes,
    required this.matrizCompleta,
    required this.artificial,
    required this.qntVariavel,
  });
// ignore: prefer_typing_uninitialized_variables
  var qntResticoes;
  // ignore: prefer_typing_uninitialized_variables
  int qntVariavel;
  int artificial;
  @override
  // ignore: no_logic_in_create_state
  State<PageTableM> createState() => _PageTableState(
        posIgualdade: posIgualdade,
        qntVariavel: qntVariavel,
        qntResticoes: qntResticoes,
        artificial: artificial,
        matrizCompleta: matrizCompleta,
      );
}

class _PageTableState extends State<PageTableM> {
  _PageTableState({
    required this.posIgualdade,
    required this.qntVariavel,
    required this.matrizCompleta,
    required this.artificial,
    required this.qntResticoes,
  });

  List<int> posIgualdade;
  int qntVariavel;
  int qntResticoes;
  int artificial;
  Matrix matrizCompleta;
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
      body: SoluBIG(
        posIgualdade:posIgualdade,
        qntVariavel: qntVariavel,
        qntRestricoes: qntResticoes,
        artificial: artificial,
        matrizCompleta: matrizCompleta,
      ),
    );
  }
}
