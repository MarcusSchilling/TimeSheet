class CriticalTimeSpan {

  final Duration _timeSpan;
  final Duration _timeToDo;

  const CriticalTimeSpan(this._timeSpan, this._timeToDo);

  Duration get timeToDo => _timeToDo;

  Duration get timeSpan => _timeSpan;

  Duration percentageOfTimeToDo(double percentage) {
    return _percentageOfDuration(timeToDo, percentage);
  }

  Duration percentageOfTimeSpan(double percentage) {
    return _percentageOfDuration(timeSpan, percentage);
  }

  Duration _percentageOfDuration(Duration duration, double percentage) {
    assert(percentage < 1 && percentage > 0);
    return Duration(microseconds: (duration.inMicroseconds * percentage).round());
  }

}