class EmptyClass {}

class FullClass {
  void simpleMethod() {}
  num get aGetter => -1;
  set aSetter(num arg) {}
  num aField;

  set aPair(num a) {}
  num get aPair => -1;

  //TODO inhomogeneous pair
}

abstract class FullAbstractClass {
  void simpleMethod();
  void otherMethod();
  num get aGetter;
  set aSetter(num arg);
  num aField;
  set aPair(num a);
  num get aPair;
}

class FullAbstractImplemented extends FullAbstractClass {
  void simpleMethod() {}
  void otherMethod() {}
  num get aGetter {}
  set aSetter(num arg) {}
  set aPair(num a) {}
  num get aPair {}
}

abstract class PartiallyImplemented extends FullAbstractClass {
  void simpleMethod() {}
}

abstract class MoreImplemented extends PartiallyImplemented {
  void otherMethod() {}
}
