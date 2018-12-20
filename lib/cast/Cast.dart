import 'dart:async';

import 'package:cplayer/cast/CastDevice.dart';
import 'package:cplayer/cast/CastDriver.dart';
import 'package:dart_chromecast/casting/cast_media.dart';
import 'package:dart_chromecast/casting/cast_sender.dart';
import 'package:flutter/material.dart';

class Cast {

  static const String CAST_APP_NAME = "6569632D";

  CastDriver _driver;
  bool _isRefreshing = false;

  Cast(){
    _driver = new CastDriver();
  }

  restart(){
    _driver.restart();
  }

  destroy(){
    _driver.stop();
  }

  chooseAndPlay(BuildContext context, String url){
    if(_isRefreshing) return;
    List<CastDevice> devices = _driver.getCastDevices();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialog){
        return AlertDialog(
          // Title Row
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.cast),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Cast', style: TextStyle(
                      fontFamily: 'GlacialIndifference',
                      fontSize: 28
                    )),
                  )
                ],
              ),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: const Color(0x70FFFFFF),
                  borderRadius: BorderRadius.circular(100),
                  onTap: (){
                    _isRefreshing = true;
                    _driver.restart();
                    Navigator.pop(context);
                    Timer(Duration(seconds: 1), (){
                      _isRefreshing = false;
                      chooseAndPlay(context, url);
                    });
                  },
                  child: new Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.refresh),
                  ),
                ),
              )
            ],
          ),
          
          // Body
          content: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: devices.length == 0 ? new Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'No Chromecast devices found...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.caption.color
                  ),
                )
              )
            ) : ListView.builder(
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (listContext, index){
                var device = devices[index];

                return ListTile(
                  onTap: (){
                    Navigator.pop(context);
                    _play(device, url, context);
                  },
                  title: Text(device.friendlyName, style: TextStyle(
                    fontFamily: 'GlacialIndifference'
                  )),
                  subtitle: Text("${device.manufacturer} ${device.modelName}"),
                  leading: Material(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.tv),
                    ),
                  ),
                );
              }
            ),
          ),
        );
      }
    );
  }

  _play(CastDevice device, String url, BuildContext context){
    // Show loading message...
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            "Connecting to ${device.friendlyName}...",
            style: TextStyle(
              fontFamily: 'GlacialIndifference',
              fontSize: 28
            ),
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor
                      )
                  ),
                ),
              )
            ],
          ),
        );
      }
    );

    // Connect and play
    () async{
      var castSender = CastSender(device.toPrimitive());
      bool connected = await castSender.connect();

      // Display an error due to connection failure.
      if(!connected){
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text(
                  "Error",
                  style: TextStyle(
                      fontFamily: 'GlacialIndifference',
                      fontSize: 28
                  ),
                ),
                content: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text("Unable to connect to ${device.friendlyName}."),
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.of(context).pop()
                  )
                ],
              );
            }
        );
        return;
      }

      Navigator.of(context).pop();
      castSender.launch(CAST_APP_NAME);
      castSender.load(CastMedia(
        title: 'Debug',
        contentId: url
      ), forceNext: true);
    }();
  }

}