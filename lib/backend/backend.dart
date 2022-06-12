import 'dart:async';
import 'dart:math' as math;

class Backend {
  void Function(Timer) progressFunc(Function(double) progressCallback) {
    double time = 0;
    double progress = 0.1;

    return (t) {
      // Asymptote
      time += .001;
      progress = math.sqrt(1 - math.pow(time - 1, 2));

      if (progress < 1) {
        progressCallback(progress);
        return;
      }

      progressCallback(1);
      t.cancel();
    };
  }

  Future<String> sendCommand(
      String command, Function(double) progressCallback) {
    var t = Timer.periodic(
        const Duration(milliseconds: 10), progressFunc(progressCallback));

    return Future.delayed(
      const Duration(seconds: 9),
      () {
        progressCallback(1);
        t.cancel();
        String exec = command.split(" ")[0];
        return "command not found: $exec";
      },
    );
  }
}
