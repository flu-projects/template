part of utils;

enum EventType {
  congratulations,
  updateDomain,
  updateData,
  closeDialog,
  smsUpdate,
}

class Event {
  final EventType type;
  final dynamic data;
  const Event({required this.type, this.data});
}

class EventMgr extends Object {
  EventMgr._();

  // 静态变量指向自身
  static final EventMgr _instance = EventMgr._();

  // 方案1：静态方法获得实例变量
  static EventMgr getInstance() => _instance;

  // 方案2：工厂构造方法获得实例变量
  factory EventMgr() => _instance;

  // 方案3：静态属性获得实例变量
  static EventMgr get instance => _instance;

  final EventBus _eventBus = EventBus();

  StreamSubscription? _subscription;
  final Map<EventType, ValueChanged> _functions = {};
  final List<Event> _events = List.empty(growable: true);
  Timer? _timer;

  void init() {
    _subscription = _eventBus.on().listen((event) {
      if (event is! Event) {
        return;
      }
      _events.add(event);
      if (!(_timer?.isActive ?? false)) {
        _start();
      }
    });
  }

  void fire(Event event) {
    _eventBus.fire(event);
  }

  void listen(EventType type, ValueChanged onResult) {
    _functions[type] = onResult;
  }

  void destory() {
    _subscription?.cancel();
    _subscription = null;
    _eventBus.destroy();
  }

  void _start() {
    _timer = Timer(const Duration(milliseconds: 100), _dispatchEvent);
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _dispatchEvent() async {
    do {
      if (_events.isEmpty) {
        break;
      }
      if (_functions[_events.last.type] == null) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }

      var _event = _events.removeLast();
      _functions[_event.type]?.call(_event.data);
    } while (true);
    _stop();
  }
}
