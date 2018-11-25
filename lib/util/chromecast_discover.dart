import 'package:meta/meta.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class ChromecastSettings {

  static const String _endpoint_path = "/ssdp/device-desc.xml";
  static const int _endpoint_port = 8008;

  final String friendlyName;
  final String manufacturer;
  final String modelName;

  ChromecastSettings({
    @required this.friendlyName,
    @required this.manufacturer,
    @required this.modelName
  });

  ///
  /// Makes a request to the device's UPNP endpoint to determine settings.
  /// Returns a [ChromecastSettings] object if successful.
  /// Returns null if not.
  ///
  static Future<ChromecastSettings> get(String ip) async {
    try {
      // Make HTTP request to UPNP endpoint.
      http.Response response =
        await http.get("http://$ip:$_endpoint_port$_endpoint_path");
      // Parse XML output.
      xml.XmlDocument responseDocument = xml.parse(response.body);

      // Parse device settings.
      var device = responseDocument.findElements("root").single.findElements("device").single;
      return new ChromecastSettings(
          friendlyName: device.findElements("friendlyName").single.text,
          manufacturer: device.findElements("manufacturer").single.text,
          modelName: device.findElements("modelName").single.text
      );
    }catch(ex){
      return null;
    }
  }

}