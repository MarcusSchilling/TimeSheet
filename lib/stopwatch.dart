typedef DateTime GetCurrentDateTime();

class Stopwatch {
  List<DateTime> _stoppedTimes = List();
  GetCurrentDateTime _getCurrentDateTime;

  Stopwatch({GetCurrentDateTime getCurrentDateTime}) {
    if(getCurrentDateTime == null) {
      this._getCurrentDateTime = () => DateTime.now();
    } else {
      this._getCurrentDateTime = getCurrentDateTime;
    }
  }

  reset() {
    _stoppedTimes.clear();
  }

  bool get isRunning => _stoppedTimes.length.isOdd;

  String get stoppedTime => getStoppedTime().toString().split(".").elementAt(0);

  start() {
    assert(!isRunning);
    _stoppedTimes.add(_getCurrentDateTime());
  }

  stop() {
    assert(isRunning);
    _stoppedTimes.add(_getCurrentDateTime());
  }

  Duration getStoppedTime() {
    List<Duration> durations = List();
    for (int i = 0; i < _stoppedTimes.length; i += 2) {
      var stopTime;
      var isNotStoppedAndLastElementIsTouched = i + 1 >= _stoppedTimes.length;
      if (isNotStoppedAndLastElementIsTouched) {
        assert(_stoppedTimes.length.isOdd);
        stopTime = _getCurrentDateTime();
      } else {
        stopTime = _stoppedTimes.elementAt(i + 1);
      }
      var startTime = _stoppedTimes.elementAt(i);
      var currentDuration = stopTime.difference(startTime);
      durations.add(currentDuration);
    }
    Duration totalDuration =
        durations.fold(Duration(), (first, second) => first + second);
    return totalDuration;
  }
}
