import 'dart:ffi';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Tic extends StatefulWidget {
  const Tic({super.key});

  @override
  State<Tic> createState() => _TicState();
}

class _TicState extends State<Tic> {
  final controller = ConfettiController();
  bool play = false;
  int f = 0;
  _again() {
    for (int i = 0; i < 9; i++) {
      p[i] = '';
      f = 0;
    }
  }

  _showAlertDialog(String s, String w) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              s.toString() + ':' + w.toString(),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    controller.stop();
                    setState(() {
                      for (int i = 0; i < 9; i++) {
                        p[i] = '';
                      }
                    });
                    // _again();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Play Again!",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          );
        });
  }

  List<String> p = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  bool turn = true;
  void _checkTheWinner() {
    // check first row
    if (p[0] == p[1] && p[0] == p[2] && p[0] != '') {
      controller.play();

      _showAlertDialog('Winner', p[0]);
      return;
    }

    // check second row
    if (p[3] == p[4] && p[3] == p[5] && p[3] != '') {
      controller.play();
      _showAlertDialog('Winner', p[3]);
      return;
    }

    // check third row
    if (p[6] == p[7] && p[6] == p[8] && p[6] != '') {
      controller.play();
      _showAlertDialog('Winner', p[6]);
      return;
    }

    // check first column
    if (p[0] == p[3] && p[0] == p[6] && p[0] != '') {
      controller.play();
      _showAlertDialog('Winner', p[0]);
      return;
    }

    // check second column
    if (p[1] == p[4] && p[1] == p[7] && p[1] != '') {
      controller.play();
      _showAlertDialog('Winner', p[1]);
      return;
    }

    // check third column
    if (p[2] == p[5] && p[2] == p[8] && p[2] != '') {
      controller.play();
      _showAlertDialog('Winner', p[2]);
      return;
    }

    // check diagonal
    if (p[0] == p[4] && p[0] == p[8] && p[0] != '') {
      controller.play();
      _showAlertDialog('Winner', p[0]);
      return;
    }

    // check diagonal
    if (p[2] == p[4] && p[2] == p[6] && p[2] != '') {
      controller.play();
      _showAlertDialog('Winner', p[4]);
      return;
    }
    if (f == 9) {
      _showAlertDialog('Draw', ' ');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    tap(int index) {
      if (turn == true && p[index] == '') {
        setState(() {
          p[index] = 'O';
          turn = false;
          f++;
          _checkTheWinner();
        });
      } else if (turn == false && p[index] == '') {
        setState(() {
          p[index] = 'X';
          turn = true;
          f++;
          _checkTheWinner();
        });
      }
    }

    return Stack(alignment: Alignment.topCenter, children: [
      Scaffold(
        backgroundColor: Color.fromARGB(255, 254, 154, 12),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 200),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TextButton(
                      onPressed: () {
                        tap(index);
                      },
                      child: Text(
                        p[index].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      )),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                );
              },
              itemCount: 9,
            ),
          ),
        ),
      ),
      ConfettiWidget(
          confettiController: controller,
          //blastDirection: 90,
          maxBlastForce: Checkbox.width,
          blastDirectionality: BlastDirectionality.explosive,
          canvas: MediaQuery.of(context).size * 2)
    ]);
  }
}
