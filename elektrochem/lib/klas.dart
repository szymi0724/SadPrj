class Data {
  Data(this.x, this.y);

  final double x;
  final double y;
}

class DDItem {
  final String label;
  final int value;

  DDItem({required this.label, required this.value});
}

class PlotSet {
  double minx;
  double maxx;
  double miny;
  double maxy;
  String ptype;
  int cxnum;
  int cynum;

  PlotSet({required this.minx, required this.maxx, required this.miny, required this.maxy, required this.ptype, required this.cxnum, required this.cynum});
}