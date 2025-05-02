import 'dart:io';

import 'package:elektrochem/klas.dart';
import 'package:matrices/matrices.dart';

int countLines(String text) {
  if (text.trim().isEmpty) return 0;
  return text.split('\n').length;
}

(Matrix, int, int) matryca(String text, String paz) {
  List rozdzia = text.split('\n');
  int dlu = rozdzia.length;
  int b = rozdzia[0].split(paz).length;
  int h = checker(rozdzia[0].split(paz), b);
  var mat = Matrix.zero(dlu - h - 1, b);
  for (var i = 0; i < (dlu - h - 1); i++) {
    List zez = rozdzia[i + h].split(paz);
    for (var z = 0; z < b; z++) {
      if (double.tryParse(zez[z]) == null) {
        break;
      }
      mat[i][z] = double.parse(zez[z]);
    }
  }
  return (mat, (dlu - h), b);
}

List<Data> listo(Matrix A, int b, int c, int x, int y) {
  var ret = <Data>[];
  for (var i = 0; i < b - 1; i++) {
    ret.add(Data(A[i][x], A[i][y]));
  }
  return ret;
}

(List<Data>, int) mixer(String text, String paz, int x, int y) {
  var (a, b, c) = matryca(text, paz);
  List<Data> d = listo(a, b, c, x, y);
  return (d, b);
}

int checker(List a, int b) {
  //int z = 0; //na później do sprawdzania macierzy ewentualnie
  bool c = false;
  for (var i = 0; i < b; i++) {
    String value = a[i];
    if (double.tryParse(value) != null) {
      c = false;
    } else {
      c = true;
    }
    //z++;
  }
  if (c == false) {
    return 0;
  } else {
    return 1;
  }
}

List<DDItem> Xaxis(String _text, String _paz) {
  if (_text == "Brak") {
    List<DDItem> k = [];
    return k;
  } else {
    final file = File(_text);
    String _textt = file.readAsStringSync();
    List _rozdzia = _textt.split('\n');
    int _b = _rozdzia[0].split(_paz).length;
    int _h = checker(_rozdzia[0].split(_paz), _b);
    List _zez = _rozdzia[0].split(_paz);
    List<DDItem> _mat = [];
    if (_h == 1) {
      for (var _z = 0; _z < _b; _z++) {
        _mat.add(DDItem(label: _zez[_z], value: _z));
      }
    } else {
      for (var z = 0; z < _b; z++) {
        int _u = z + 1;
        _mat.add(DDItem(label: ("Col $_u"), value: z));
      }
    }
    return _mat;
  }
}

List<Data> ogra(List<Data> lis, int minx, int maxx, int miny, int maxy, int z) {
  var ret = <Data>[];
  int j = 0;
  for (var i = 0; i < z-1; i++) {
    if (lis[i].x < minx) {
      if (lis[i].x > maxx) {
        if (lis[i].y < miny) {
          if (lis[i].y > miny) {
            ret.add(Data(lis[j].x, lis[j].y));
            j++;
          }
        }
      }
    }
  }
  return ret;
}
