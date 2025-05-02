import 'dart:io';
import 'dart:ui';

import 'package:elektrochem/matrycowanie.dart';
import 'package:elektrochem/klas.dart';
import 'package:elektrochem/settings.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:fl_chart/fl_chart.dart';

PlotSet pset = PlotSet(
  minx: 0,
  maxx: 313,
  miny: 0,
  maxy: 313,
  ptype: "Line",
  cxnum: 1,
  cynum: 2,
);

class Ploter extends StatefulWidget {
  const Ploter({super.key, required this.path});

  final String path;

  @override
  State<Ploter> createState() => _PloterState();
}

class _PloterState extends State<Ploter> {
  @override
  Widget build(BuildContext context) {
    final String pathI = widget.path;

    final List<DDItem> DDVX = Xaxis(pathI, "\t");

    if (pathI == "Brak") {
      return Text("Nothing loaded", textAlign: TextAlign.left);
    } else {
      final file = File(pathI);
      var (temp1, len) = mixer(
        file.readAsStringSync(),
        "\t",
        (pset.cxnum),
        (pset.cynum),
      );
      List<Data> plota = ogra(temp1, pset.minx, pset.maxx, pset.miny, pset.maxy, len);
      //final List<FlSpot> spots =
      //plota.map((data) => FlSpot(data.x, data.y)).toList();
      return Column(
        children: [
          Row(
            children: [
              SizedBox(width: 15.0, height: 700.0),
              Grafer(a: pset.ptype, b: plota),
              Column(
                children: [
                  SizedBox(
                    width: 150.0,
                    height: 30.0,
                    child: DropdownButton(
                      value: pset.cxnum,
                      hint:
                          pset.cxnum == null
                              ? Text('X axis')
                              : Text(
                                pset.cxnum.toString(),
                                style: TextStyle(color: Colors.blue),
                              ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.blue),
                      items:
                          DDVX.map((DDItem DDVX) {
                            return DropdownMenuItem<int>(
                              value: DDVX.value,
                              child: Text(DDVX.label),
                            );
                          }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          pset.cxnum = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150.0,
                    height: 30.0,
                    child: Text("X Axis", textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: 150.0,
                    height: 30.0,
                    child: DropdownButton(
                      value: pset.cynum,
                      hint:
                          pset.cynum == null
                              ? Text('Y axis')
                              : Text(
                                pset.cynum.toString(),
                                style: TextStyle(color: Colors.blue),
                              ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.blue),
                      items:
                          DDVX.map((DDItem DDVX) {
                            return DropdownMenuItem<int>(
                              value: DDVX.value,
                              child: Text(DDVX.label),
                            );
                          }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          pset.cynum = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150.0,
                    height: 30.0,
                    child: Text("Y Axis", textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 30, width: 150),
                  TextButton(
                    onPressed: () async {
                      final result = await showDialog<Map<String, int>>(
                        context: context,
                        builder: (context) {
                          return SettingsDialog(
                            minX: pset.minx,
                            maxX: pset.maxx,
                            minY: pset.miny,
                            maxY: pset.maxy,
                          );
                        },
                      );

                      if (result != null) {
                        setState(() {
                          pset.minx = result['minX']!;
                          pset.maxx = result['maxX']!;
                          pset.miny = result['minY']!;
                          pset.maxy = result['maxY']!;
                        });
                      }
                    },

                    child: Text('Open Settings'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 70),
          Text(
            "Tu będą dane z analiz/dopasowań w tabelkach albo czymś... kiedyś",
          ),
        ],
      );
    }
  }
}

class Grafer extends StatefulWidget {
  const Grafer({super.key, required this.a, required this.b});

  final String a;
  final List<Data> b;

  @override
  State<Grafer> createState() => _GraferState();
}

class _GraferState extends State<Grafer> {
  @override
  Widget build(BuildContext context) {
    ZoomPanBehavior zoomPanBehavior;

    zoomPanBehavior = ZoomPanBehavior(enableMouseWheelZooming : true);

    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

    // Dimensions in physical pixels (px)
    Size size = view.physicalSize;
    double width = size.width;
    double height = size.height; //do implementacji kiedyś poprawne wyświetlanie na różnych rozdzielczościach (na razie mi się nie chce)

    if (widget.a == "Line") {
      return SizedBox(
        width: 1350,
        height: 700,
        child: SfCartesianChart(
          zoomPanBehavior: zoomPanBehavior,
          // Initialize category axis
          primaryXAxis: NumericAxis(),
          series: <LineSeries<Data, double>>[
            LineSeries<Data, double>(
              // Bind data source
              dataSource: widget.b,
              xValueMapper: (Data plota, _) => plota.x,
              yValueMapper: (Data plota, _) => plota.y,
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 1350,
        height: 700,
        child: SfCartesianChart(
          zoomPanBehavior: zoomPanBehavior,
          // Initialize category axis
          primaryXAxis: NumericAxis(),
          series: <ScatterSeries<Data, double>>[
            ScatterSeries<Data, double>(
              // Bind data source
              dataSource: widget.b,
              xValueMapper: (Data plota, _) => plota.x,
              yValueMapper: (Data plota, _) => plota.y,
            ),
          ],
        ),
      );
    }
  }
}

class SettingsDialog extends StatefulWidget {
  final int minX;
  final int maxX;
  final int minY;
  final int maxY;

  const SettingsDialog({super.key, required this.minX, required this.maxX, required this.minY, required this.maxY});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _minXController;
  late TextEditingController _maxXController;
  late TextEditingController _minYController;
  late TextEditingController _maxYController;

  @override
  void initState() {
    super.initState();
    _minXController = TextEditingController(text: widget.minX.toString());
    _maxXController = TextEditingController(text: widget.maxX.toString());
    _minYController = TextEditingController(text: widget.minX.toString());
    _maxYController = TextEditingController(text: widget.maxX.toString());
  }

  @override
  void dispose() {
    _minXController.dispose();
    _maxXController.dispose();
    _minYController.dispose();
    _maxYController.dispose();
    super.dispose();
  }

  void _submit() {
    final int? minX = int.tryParse(_minXController.text);
    final int? maxX = int.tryParse(_maxXController.text);
    final int? minY = int.tryParse(_minXController.text);
    final int? maxY = int.tryParse(_maxXController.text);

    if (minX == null || maxX == null || minX >= maxX || minY == null || maxY == null || minY >= maxY) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid values: min must be < max')),
      );
      return;
    }

    Navigator.pop(context, {'minX': minX, 'maxX': maxX,'minY': minY, 'maxY': maxY});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Plot settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _minXController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'minX'),
          ),
          TextField(
            controller: _maxXController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'maxX'),
          ),
          TextField(
            controller: _minYController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'minY'),
          ),
          TextField(
            controller: _maxYController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'maxY'),
          ),
          DropdownButton(
            underline: Container(color: const Color.fromARGB(255, 0, 0, 0), width: 10, height: 0.5,),
                      hint:
                          pset.ptype == null
                              ? Text('Type')
                              : Text(
                                pset.ptype,
                                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      items:
                          ["Line", "Scatter"].map((val3) {
                            return DropdownMenuItem<String>(
                              value: val3,
                              child: Text(val3),
                            );
                          }).toList(),
                      onChanged: (val3) {
                        setState(() {
                          pset.ptype = val3!;
                        });
                      },
                    ), 
        ],
      ),
      actions: [
        TextButton(onPressed: _submit, child: Text('Save')),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

PlotSet testSet(PlotSet pset) {
  return pset;
}
