import 'dart:async';

typedef CountDownTickCallback = Function(int millisUntilFinished);
typedef CountDownCancelCallback = Function();

class CountDownTimer {
  ///毫秒 间隔
  int _interval;

  ///毫秒 总时长
  int _totalTime;

  Timer? _timer;

  bool finish = true;

  CountDownTickCallback? _tickCallback;
  CountDownCancelCallback? _cancelCallback;

  CountDownTimer(
      {int interval = Duration.millisecondsPerSecond,
      required int totalTime,
      CountDownTickCallback? tickCallback,
      CountDownCancelCallback? cancelCallback})
      : _interval = interval,
        _totalTime = totalTime,
        _tickCallback = tickCallback,
        _cancelCallback = cancelCallback;

  setCallback({CountDownTickCallback? tickCallback, CountDownCancelCallback? cancelCallback}) {
    this._tickCallback = tickCallback;
    this._cancelCallback = cancelCallback;
  }

  start() {
    _timer?.cancel();
    if (_totalTime < _interval) {
      throw Exception("CountDownTimer totalTime can not lesser than interval");
    }
    finish = false;
    _tickCallback?.call(_totalTime);
    _timer = Timer.periodic(Duration(milliseconds: _interval), (timer) {
      var tick = _totalTime - timer.tick * _interval;
      if (!finish) {
        if (tick <= 0) {
          _done(timer);
        } else {
          _tickCallback?.call(tick);
        }
      }
    });
  }

  _done(Timer? timer) {
    finish = true;
    timer?.cancel();
    _tickCallback?.call(0);
  }

  cancel() {
    _timer?.cancel();
    if (!finish) {
      _cancelCallback?.call();
    }
    finish = true;
  }

  dispose() {
    finish = true;
    _timer?.cancel();
  }

  isActive() => !finish;

  updateTime({int interval = Duration.millisecondsPerSecond, required int totalTime}) {
    this._interval = interval;
    this._totalTime = totalTime;
    start();
  }
}
