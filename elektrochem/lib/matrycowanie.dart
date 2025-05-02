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
  if (!c) {
    return 0;
  } else {
    return 1;
  }
}

List<DDItem> xaxis(String text, String paz) {
  if (text == "Brak") {
    List<DDItem> k = [];
    return k;
  } else {
    final file = File(text);
    String textt = file.readAsStringSync();
    List rozdzia = textt.split('\n');
    int b = rozdzia[0].split(paz).length;
    int h = checker(rozdzia[0].split(paz), b);
    List zez = rozdzia[0].split(paz);
    List<DDItem> mat = [];
    if (h == 1) {
      for (var z0 = 0; z0 < b; z0++) {
        mat.add(DDItem(label: zez[z0], value: z0));
      }
    } else {
      for (var z = 0; z < b; z++) {
        int u = z + 1;
        mat.add(DDItem(label: ("Col $u"), value: z));
      }
    }
    return mat;
  }
}

List<Data> ogra(List<Data> lis, double minx, double maxx, double miny, double maxy) {
  var ret = <Data>[];
  minx = minx-0.0001;
  maxx = maxx+0.0001;
  miny = miny-0.0001;
  maxy = maxy+0.0001;
  for (var i = 0; i < lis.length; i++) {
    if (lis[i].x > minx) {
      if (lis[i].x < maxx) {
        if (lis[i].y > miny) {
          if (lis[i].y < maxy) {
            ret.add(Data(lis[i].x, lis[i].y));
          }
        }
      }
    }
  }
  return ret;
}
