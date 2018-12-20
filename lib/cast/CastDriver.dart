import 'package:cplayer/cast/CastDevice.dart';
import 'package:cplayer/cast/ServiceDiscovery.dart';

class CastDriver {

  ServiceDiscovery _serviceDiscovery;

  CastDriver(){
    _serviceDiscovery = new ServiceDiscovery();
    _serviceDiscovery.start();
  }

  List<CastDevice> getCastDevices(){
    return _serviceDiscovery.resolvedDevices;
  }

  start(){
    _serviceDiscovery.start();
  }

  stop(){
    _serviceDiscovery.stop();
  }

  restart(){
    _serviceDiscovery.restart();
  }

}