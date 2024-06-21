import os
import re
import sys


class GenerateDart:
    _protos = []
    _services = []
    _updates = []
    _payload_dispatcher = 'lib/network/src/dispatcher/payload_dispatcher_initializater.dart'
    _payload_helper = 'lib/network/src/dispatcher/payload_helper.dart'
    _esport_api = 'lib/network/src/esport_api.dart'
    _event_helper = 'lib/events/src/event_helper.dart'
    _event_handle = 'lib/events/src/event_handle.dart'

    _rpcReg = r'\s{0,}rpc\s{1,}(\S+)\s{0,}\((\S+)\)\s{0,}returns\s{0,}\((\S+)\)\s{0,}'
    _serviceReg = r"\s{0,}service\s{0,}\w+\s{0,}\{([\s\S]+?)\}"

    def __init__(self, source_path, temp_path):
        self._findProtos(source_path)
        self._rewriteFiles(temp_path)
        self._readProtos()
        self._writeDispatcher()
        self._writePayloadHelper()
        self._writeApi()
        self._writeEventHelper()
        self._writeEventHandle()

    def _open(self, file, mode):
        if sys.platform == 'win32':
            return open(file, mode, encoding='utf-8')
        else:
            return open(file, mode)

    def _rewriteFiles(self, folder):
        for file in os.listdir(folder):
            path = folder + '/' + file
            fio = self._open(path, 'rt')
            text = fio.read()
            fio.close()
            regs = r"\s{0,}service\s{0,}\w+\s{0,}\{[\s\S]*\}"
            while len(re.findall(regs, text)) > 0:
                text = re.sub(regs, '', text)
            if text.count("syntax = \"proto2\";") == 0:
                text = "syntax = \"proto2\";\n" + text
            text = text.replace(r"game_server/proto/share_message/", "")
            text = text.replace(r"ggotag.proto", "gogo.proto")
            fio = self._open(path, 'w')
            fio.write(text)
            fio.close()

    def _findProtos(self, path):
        files = os.listdir(path)
        for file in files:
            fulfile = path + '/' + file
            if str(fulfile).endswith('.proto'):
                self._protos.append(fulfile)
            if os.path.isdir(fulfile):
                self._findProtos(fulfile)

    def _readProtos(self):
        for path in self._protos:
            self._parseProto(path)

    def _parseProto(self, path):
        f = self._open(path, "rt")
        txt = f.read()
        f.close()
        services = re.findall(self._serviceReg, txt)
        for i in range(len(services)):
            if i == 0:
                rpcs = re.findall(self._rpcReg, services[i])
                for rpc in rpcs:
                    self._deal_a_rpc(list(rpc), self._services)
            if i == 1:
                rpcs = re.findall(self._rpcReg, services[i])
                for rpc in rpcs:
                    self._deal_a_rpc(list(rpc), self._updates)

    def _deal_a_rpc(self, rpc, rpcs):
        method_name = rpc[0]
        request_msg = rpc[1]
        response_msg = rpc[2]
        if '.' in request_msg:
            request_msg = request_msg.split('.')[1]
        if '.' in response_msg:
            response_msg = response_msg.split('.')[1]
        rpcs.append({'rpc': method_name, "request": request_msg,
                    "response": response_msg})

    def _writeDispatcher(self):
        _items = ''
        for update in self._updates:
            rpc = '''d.add('%s',(s, p) => eventMgr.fire(p));\n''' % (
                update['rpc'])
            _items += rpc

        _content = '''
        part of network;

        void _initPayloadDispatcher(_PaylaodDispatcher d) {
            %s
        }''' % (_items)
        _fd = self._open(self._payload_dispatcher, 'w')
        _fd.write(_content)
        _fd.close()

    def _writePayloadHelper(self):
        _content = '''
        part of network;
        
        Payload _createPayload<T extends GeneratedMessage>(
            T req,
            String methodName,
        ) {
            Payload p = new Payload();
            p.msg = req.writeToBuffer();
            p.methodName = methodName;
            if (methodName != 'RpcHeartbeat') {
                log.d('request ====== $methodName\\n$req');
            }
            return p;
        }'''
        fd = self._open(self._payload_helper, 'w')
        fd.write(_content)
        fd.close()

    def _writeApi(self):
        _items = ''
        for down in self._services:
            rpc = '''
            Future<%s?> %s(%s request,{ValueChanged<Fail>? failedCallback,}) async {
                return (await _session.request<%s, %s>(request,failedCallback,'%s',))!.pkt;
            }
            ''' % (down['response'], (down['rpc'][:1]).lower() + down['rpc'][1:], down['request'], down['request'], down['response'], down['rpc'])
            _items += rpc

        _content = '''
        part of network;

        var api = _EsportApi._();

        class _EsportApi extends _EsportApiPrivate {
        _EsportApi._();
        %s
        }''' % (_items)
        _fd = self._open(self._esport_api, 'w')
        _fd.write(_content)
        _fd.close()

    def _writeEventHelper(self):
        _event_helper = '''
        part of events;

        class EventHelper {
        static void fireCompleter(
            Completer completer,
            String method,
            List<int> data,
        ) {
            switch (method) {
            %s
            default:
            {
                completer.complete(PacketEvent<Fail>(
                    Fail.fromBuffer(data),
                ));
                break;
                }
                }
            }
        }'''

        _event_helper_item = '''
        case '%s':
            {
                %s _data;
                if (data.isEmpty) {
                    _data = %s.create();
                } else {
                    _data = %s.fromBuffer(data);
                }
                completer.complete(PacketEvent<%s>(_data));
            break;
            }'''

        _items = ''
        for down in self._services:
            rpc = _event_helper_item % (
                down['rpc'], down['response'], down['response'], down['response'], down['response'],)
            _items += rpc
        _content = _event_helper % (_items)
        _fd = self._open(self._event_helper, 'w')
        _fd.write(_content)
        _fd.close()

    def _writeEventHandle(self):
        _template = '''
        part of events;

        _EventHandle eventHandle = _EventHandle._();

        class _EventHandle {
        _EventHandle._();
        void fireEvent(Request request) {
            switch (request.methodName) {
            %s
            default:
                log.e('method ${request.methodName} is not find');
            }
        }

        void _error(String method) {
            log.e('current method $method is`not implement');
        }

        %s

        %s
        }'''

        _item = '''case '%s':
                {
                if (_on%s == null) {
                    _error(request.methodName);
                    return;
                }
                _on%s!(%s.fromBuffer(request.serialized));
                break;
                }'''

        _register = '''void on%s(ValueChanged<%s> on%s) {
            _on%s = on%s;
            }'''

        _functions = ''
        _items = ''
        _registers = ''

        for update in self._updates:
            rpc = _item % (
                update['rpc'], update['rpc'], update['rpc'], update['request'])
            _items += rpc
            _functions += 'ValueChanged<%s>? _on%s;' % (
                update['request'], update['rpc'])
            _registers += _register % (update['rpc'], update['request'],
                                       update['rpc'], update['rpc'], update['rpc'])

        _content = _template % (_items, _functions, _registers)
        _fd = self._open(self._event_handle, 'w')
        _fd.write(_content)
        _fd.close()


def unpack_args(args):
    data = {}
    for arg in args:
        k, v = arg.split("=")
        data[k] = v
    return data


if __name__ == "__main__":
    args = unpack_args(sys.argv[1:])
    source_path = args["source_path"]
    temp_path = args["temp_path"]
    GenerateDart(source_path, temp_path)
