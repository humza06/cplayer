import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import 'package:cplayer/cast/CastDevice.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';
import 'package:observable/observable.dart';

class ServiceDiscovery extends ChangeNotifier {

  static const String CAST_SERVICE = "_googlecast._tcp";

  FlutterMdnsPlugin _flutterMdnsPlugin;
  List<ServiceInfo> resolvedServices;
  List<CastDevice> resolvedDevices;

  ServiceDiscovery(){
    _clear();

    _flutterMdnsPlugin = FlutterMdnsPlugin(
      discoveryCallbacks: DiscoveryCallbacks(
        onDiscoveryStarted: () => _clear,
        onDiscoveryStopped: () => {},
        onDiscovered: (ServiceInfo serviceInfo) => {},
        onResolved: (ServiceInfo serviceInfo){
          if(resolvedServices.where((element) => element.hostName == serviceInfo.hostName).length == 0)
            resolvedServices.add(serviceInfo);

          () async {
            if(resolvedDevices.where((element) => element.host == serviceInfo.hostName).length == 0)
              resolvedDevices.add(await _resolveDevice(serviceInfo));
          }();

          notifyChange();
        },
      )
    );
  }

  start(){
    _clear();
    _flutterMdnsPlugin.startDiscovery(CAST_SERVICE);
  }

  stop(){
    _flutterMdnsPlugin.stopDiscovery();
  }

  restart(){
    _clear();
    _flutterMdnsPlugin.restartDiscovery();
  }

  _clear(){
    resolvedServices = [];
    resolvedDevices = [];
  }

  Future<CastDevice> _resolveDevice(ServiceInfo info) async {
    if(info.type != ".$CAST_SERVICE"){
      return null;
    }

    /* GET USER-FRIENDLY DEVICE INFORMATION */

    // Make a GET request to the UPNP endpoint of that device.
    http.Response response = await http.get("http://${info.hostName}:8008/ssdp/device-desc.xml");
    xml.XmlDocument responseDocument = xml.parse(response.body);

    // Parse device settings.
    var device = responseDocument.findElements("root").single.findElements("device").single;
    String friendlyName = device.findElements("friendlyName").single.text;
    String manufacturer = device.findElements("manufacturer").single.text;
    String modelName = device.findElements("modelName").single.text;

    /* ./GET USER-FRIENDLY DEVICE INFORMATION */

    return CastDevice(
      name: info.name,
      type: info.type,
      host: info.hostName,
      port: info.port,

      friendlyName: friendlyName,
      manufacturer: manufacturer,
      modelName: modelName
    );
  }

}