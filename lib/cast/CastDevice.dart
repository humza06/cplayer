import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:dart_chromecast/casting/cast_device.dart' as tbCastDevice;

class CastDevice {

  final String name;
  final String type;
  final String host;
  final int port;

  final String friendlyName;
  final String manufacturer;
  final String modelName;

  CastDevice({
    @required this.name,
    @required this.type,
    @required this.host,
    @required this.port,

    @required this.friendlyName,
    @required this.manufacturer,
    @required this.modelName
  });

  ///
  /// Returns a Terrabythia [tbCastDevice.CastDevice] object from the data
  /// stored in the Apollo [CastDevice].
  ///
  tbCastDevice.CastDevice toPrimitive(){
    return tbCastDevice.CastDevice(
      name: this.name,
      type: this.type,
      host: this.host,
      port: this.port
    );
  }

  @override
  toString(){
    return jsonEncode({
      "name": name,
      "type": type,
      "host": host,
      "port": port,

      "friendlyName": friendlyName,
      "manufacturer": manufacturer,
      "modelName": modelName
    });
  }

}