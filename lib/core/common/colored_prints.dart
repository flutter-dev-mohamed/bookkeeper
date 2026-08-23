class OPrint {
  static const String reset = '\x1B[0m';

  static void r(Object m) => print('\x1B[31m$m$reset'); // Red
  static void g(Object m) => print('\x1B[32m$m$reset'); // Green
  static void y(Object m) => print('\x1B[33m$m$reset'); // Yellow
  static void b(Object m) => print('\x1B[34m$m$reset'); // Blue
  static void m(Object m) => print('\x1B[35m$m$reset'); // Magenta
  static void c(Object m) => print('\x1B[36m$m$reset'); // Cyan
  static void br(Object m) => print('\x1B[91m$m$reset'); // Bright Red
  static void bg(Object m) => print('\x1B[92m$m$reset'); // Bright Green
  static void by(Object m) => print('\x1B[93m$m$reset'); // Bright Yellow
  static void bb(Object m) => print('\x1B[94m$m$reset'); // Bright Blue

  static void lineC(String title) => c(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineR(String title) => r(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineG(String title) => g(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineY(String title) => y(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineB(String title) => b(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineM(String title) => m(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineBr(String title) => br(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineBg(String title) => bg(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineBy(String title) => by(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );

  static void lineBb(String title) => bb(
    '——————————————— ${title} ——————————————————————————————————————————————————',
  );
}
