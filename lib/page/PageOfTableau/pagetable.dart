import 'package:flutter/material.dart';
import 'package:simplexe/page/InicializarConverter/convertertablue.dart';

// ignore: must_be_immutable
class PageTable extends StatefulWidget {
  PageTable({
    super.key,
    required this.qntResticoes,
    required this.qntVariavel,
  });

  int qntResticoes;
  
  int qntVariavel;

  @override
  State<PageTable> createState() =>
      
      _PageTableState(qntVariavel: qntVariavel, qntResticoes: qntResticoes);
}

class _PageTableState extends State<PageTable> {
  _PageTableState({required this.qntVariavel, required this.qntResticoes});

  int qntVariavel;
  int qntResticoes;

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
                    color: Color.fromARGB(255, 252, 252, 252)),
              ),
              SizedBox(
                width: 50,
              )
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Entradas(qntVariavel: qntVariavel, qntRestricoes: qntResticoes),
    );
  }
}

// ignore: must_be_immutable
class Entradas extends StatefulWidget {
  int qntRestricoes = 0;
  int qntVariavel = 0;
  Entradas({required this.qntVariavel, required this.qntRestricoes, super.key});

  @override
  State<Entradas> createState() =>
      // ignore: no_logic_in_create_state
      _EntradasState(qnt: qntRestricoes, qntV: qntVariavel);
}

class _EntradasState extends State<Entradas> {
  int qnt = 0;
  int qntV = 0;
  List<List<String>> _selectedOptions = []; // esse é as opções das restrições
  // ignore: prefer_final_fields
  List<List<String>> _selectedOptionsFuncionObj = [
    ['Min']
  ];

  List<List<TextEditingController>> _selectedControlsFO = []; 
  List<List<TextEditingController>> _selectedControls = [];

  _EntradasState({required this.qnt, required this.qntV}) {
    _selectedOptions = List.generate(qnt, (index) => []);
    _selectedControlsFO =
        List.generate(qntV, (index) => [TextEditingController()]);
    int atualiza = qntV + 1;
    
    _selectedControls = List.generate(
      qnt,
      (index) => List.generate(
        atualiza,
        (indexx) => TextEditingController(),
      ),
    );
  }

  // List<String> operadores = ['>=', '<=', '='];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // decoration: BoxDecoration(color: Colors.white),

                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Cor da borda
                    width: 2.0, // Largura da borda
                  ),
                  // border: Border.symmetric(
                  //   horizontal: BorderSide(width: 2),
                  //   vertical: BorderSide(width: 2),
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: SizedBox(
                    // width: Null,
                    height: 50,
                    child: ListView(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: _selectedOptionsFuncionObj[0].first,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedOptionsFuncionObj[0] = [
                                          newValue!
                                        ];
                                      });
                                    },
                                    items: ['Min', 'Max']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  const Text('F-O: '),
                                  for (int i = 0; i < qntV; i++)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: TextField(
                                            controller: _selectedControlsFO[i]
                                                [0],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        Text('X${i + 1}'),
                                        const SizedBox(width: 10),
                                        mais(i),
                                        const SizedBox(width: 10),
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
                ),
              ),
            ),
            Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Cor da borda
                    width: 2.0, // Largura da borda
                  ),
                ),
                child: SizedBox(
                  height: calculartablue(),
                  child: SizedBox(
                    // width: Null,
                    height: calcularAltura(),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: teste,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mais(j) {
    if (widget.qntVariavel - j > 1) {
      return const Text('+');
    } else {
      return const SizedBox.shrink();
    }
  }

  double calculartablue() {
    if (widget.qntRestricoes < 8) return 48 * widget.qntRestricoes.toDouble();

    return 380;
  }

  double calcularAltura() {
    double alturaTotal = 0.0;

    for (int i = 0; i < widget.qntRestricoes; i++) {
      alturaTotal += (widget.qntVariavel * 15) + 20;
    }

    return alturaTotal;
  }

  void teste() {
    // _selectedOptionsFuncionObj

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Tablue(
              selectedOptionsFuncionObj: _selectedOptionsFuncionObj,
              qntRestricao: qnt,
              qntVariavel: qntV,
              selectedControls: _selectedControls,
              selectedOptions: _selectedOptions,
              selectedControlsFO: _selectedControlsFO),
        ));
  }

  List<Widget> louyt() {
    // int ts = 2;

    List<Widget> dda = [];
    for (int i = 0; i < widget.qntRestricoes; i++) {
      List<Widget> linhaSecundaria = [];
      for (int j = 0; j < widget.qntVariavel; j++) {
        

        linhaSecundaria.add(
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextField(
                      controller: _selectedControls[i][j],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Text('X${j + 1}'),
                ],
              ),
              const SizedBox(width: 10),
              mais(j),
              const SizedBox(width: 10),
            ],
          ),
        );
      }
      //  _selectedOptions.add([]);
      dda.add(Row(
        children: [
          Row(
            children: linhaSecundaria,
          ),
          DropdownButton<String>(
            value: _selectedOptions[i].isNotEmpty
                ? _selectedOptions[i].first
                : null,
            onChanged: (newValue) {
              setState(() {
                _selectedOptions[i] = [newValue!];
              });
            },
            items: ['<=', '>=', '='].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              SizedBox(
                width: 40,
                height: 40,
                child: TextField(
                  controller: _selectedControls[i][qntV],
                  keyboardType: TextInputType.number,
                ),
              ),
              Text('b${i + 1}'),
            ],
          )
        ],
      ));
    }

    return dda;
  }
}
