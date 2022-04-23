import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({Key? key, required this.label, required this.spentAmount, required this.spentPercentageTotal}) : super(key: key);
  final String label;
  final double spentAmount;
  final double spentPercentageTotal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
              child: FittedBox(
                child: Text(
                  "₹${spentAmount.toStringAsFixed(0)}",
                ),
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: (Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  //FractionallySizedBox to fill in the spaces available according to the percentage of expense we have
                  heightFactor: spentPercentageTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            )),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                label,
              ),
            ),
          ),
        ],
      );
    });
  }
}
