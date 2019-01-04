import 'dart:io';
import 'package:flutter_app/stopwatch.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  test("stopwatch works after 1 second delay without stop and without mocking datetime", () {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    sleep(Duration(seconds: 1));
    var stoppedTime = stopwatch.getStoppedTime();
    expect(stoppedTime.inSeconds < 1.5, true);
  });

  test("stopwatch works after 1 second delay without mocking datetime", () {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    sleep(Duration(seconds: 1));
    stopwatch.stop();
    var stoppedTime = stopwatch.getStoppedTime();
    expect(stoppedTime.inSeconds < 1.5, true);
  });


  test("stopwatch works after 9 hours delay without stop with mocking datetime", () {
    List<DateTime> stoppedTimes = List();
    var stopwatchWithMocking = Stopwatch(getCurrentDateTime: () => stoppedTimes.removeLast());
    //because we use the list as a stack we must first add the element that is used last
    stoppedTimes.add(DateTime(2010,1,1,10,1,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,1,1,1,1,1));  Stopwatch stopwatch = stopwatchWithMocking;
    stopwatch.start();
    var stoppedTime = stopwatch.getStoppedTime();
    expect(stoppedTime.inHours == 9, true);
  });

  test("stopwatch works after 9 hours delay with mocking datetime", () {
    //because we use the list as a stack we must first add the element that is used last
    List<DateTime> stoppedTimes = List();
    var stopwatchWithMocking = Stopwatch(getCurrentDateTime: () => stoppedTimes.removeLast());
    stoppedTimes.add(DateTime(2010,1,1,10,1,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,1,1,1,1,1));
    Stopwatch stopwatch = stopwatchWithMocking;
    stopwatch.start();
    stopwatch.stop();
    var stoppedTime = stopwatch.getStoppedTime();
    expect(stoppedTime.inHours == 9, true);
  });

  test("stopwatch works start + stop + start and without stopping last with mocking datetime", () {
    List<DateTime> stoppedTimes = List();
    var stopwatchWithMocking = Stopwatch(getCurrentDateTime: () => stoppedTimes.removeLast());
    //because we use the list as a stack we must first add the element that is used last
    stoppedTimes.add(DateTime(2010,1,1,10,20,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,10,11,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,10,1,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,1,1,1,1,1));
    Stopwatch stopwatch = stopwatchWithMocking;
    stopwatch.start();
    stopwatch.stop();
    stopwatch.start();
    var stoppedTime = stopwatch.getStoppedTime();
    expect(stoppedTime.inMinutes == 9*60 + 9, true);
  });

  test("stopwatch works after start + stop + start + stop mocking datetime", () {
    //because we use the list as a stack we must first add the element that is used last
    List<DateTime> stoppedTimes = List();
    var stopwatchWithMocking = Stopwatch(getCurrentDateTime: () => stoppedTimes.removeLast());
    stoppedTimes.add(DateTime(2010,1,1,10,20,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,10,11,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,10,1,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,1,1,1,1,1));
    Stopwatch stopwatch = stopwatchWithMocking;
    stopwatch.start();
    stopwatch.stop();
    stopwatch.start();
    stopwatch.stop();
    var stoppedTime = stopwatch.getStoppedTime();
    expect(stoppedTime.inMinutes == 9*60 + 9, true);
  });

  test("reset works", () {
    List<DateTime> stoppedTimes = List();
    var stopwatchWithMocking = Stopwatch(getCurrentDateTime: () => stoppedTimes.removeLast());
    stoppedTimes.add(DateTime(2010,1,1,10,20,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,10,11,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,10,1,1,1,1));
    stoppedTimes.add(DateTime(2010,1,1,1,1,1,1,1));
    Stopwatch stopwatch = stopwatchWithMocking;
    stopwatch.start();
    stopwatch.stop();
    stopwatch.start();
    stopwatch.stop();
    var stoppedTimeBeforeReset = stopwatch.getStoppedTime();
    expect(stoppedTimeBeforeReset.inMinutes == 9*60 + 9, true);
    stopwatch.reset();
    var stoppedTimeAfterReset = stopwatch.getStoppedTime();
    expect(stoppedTimeAfterReset.inMinutes == 0, true);
  });

  test("reset works without start or stop", () {
    List<DateTime> stoppedTimes = List();
    var stopwatchWithMocking = Stopwatch(getCurrentDateTime: () => stoppedTimes.removeLast());
    stopwatchWithMocking.reset();
    expect(stopwatchWithMocking.getStoppedTime(), Duration());
  });
}
