import 'dart:math' show Random;

import 'package:flutter/rendering.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:flutter/material.dart';
import 'package:random_words/random_words.dart' show nouns;
import 'package:random_string/random_string.dart' show randomAlpha;

import '../room_client.dart';

class Room extends StatefulWidget {
  static const String RoutePath = '/room';
  final String url;

  const Room({Key key, this.url}) : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  RoomClient roomClient;

  List<RTCVideoRenderer> remoteRenderers = [];
  RTCVideoRenderer localRenderer;
  List<Consumer> consumers = [];
  List<Producer> producers = [];

  void addConsumer(Consumer consumer) async {
    consumers.add(consumer);
    if (consumer.kind != 'audio') {
      final renderer = RTCVideoRenderer();
      await renderer.initialize().then((_) {
        renderer.srcObject = consumer.stream;
        remoteRenderers.add(renderer);
      }).then((_) => setState(() {}));
    }
  }

  void onProducer(Producer producer) async {
    producers.add(producer);
    if (producer.kind != 'audio') {
      localRenderer = RTCVideoRenderer();
      await localRenderer.initialize();
      localRenderer.srcObject = producer.stream;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.url != null && widget.url.isNotEmpty) {
      print("-----------------url${widget.url}");
      Uri uri = Uri.parse(widget.url);
      print("uriiii ---------------------${uri}");
      roomClient = RoomClient(
        displayName: nouns[Random.secure().nextInt(2500)],
        roomId: uri.queryParameters['roomid'] ?? randomAlpha(8).toLowerCase(),
        peerId: uri.queryParameters['peerid'] ?? randomAlpha(8),
        url: 'wss://${uri.host}:4443',
        onConsumer: addConsumer,
        onProducer: onProducer,
      );
    } else {
      roomClient = RoomClient(
        displayName: nouns[Random.secure().nextInt(2500)],
        roomId: randomAlpha(8),
        peerId: randomAlpha(8),
        url: 'wss://v3demo.mediasoup.org:4443',
        onConsumer: addConsumer,
        onProducer: onProducer,
      );
    }

    roomClient.join();
    // roomClient.isMic = false;
    // roomClient.enableMic();
    // roomClient.enableWebcam();
    // Scaffold.of(context).re
  }

  @override
  void dispose() {
    localRenderer?.dispose();
    remoteRenderers.forEach((element) {
      element?.dispose();
    });
    roomClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
            roomClient.close();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: roomClient.roomId != null ? Text(roomClient.roomId) : null,
        actions: [
          FlatButton(onPressed: (){
            setState(() {
              roomClient.isMic==true?
              roomClient.disableMic():roomClient.enableMic();

            });

          },minWidth: 20, child: Icon( roomClient.isMic==true?Icons.mic:Icons.mic_off,color: Colors.white70,),),

          FlatButton(onPressed: (){
            setState(() {
              roomClient.isCamera==true?
              roomClient.disableWebcam():roomClient.enableWebcam();

            });

          },minWidth: 20, child: Icon( roomClient.isCamera==true?Icons.videocam:Icons.videocam_off,color: Colors.white70),)

        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          Column(
            children: [
              InteractiveViewer(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height:360,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    children: remoteRenderers.map((e) {
                      return Container(
                        height: 100,
                        // width:MediaQuery.of(context).size.width,
                        child: RTCVideoView(e
                            ,mirror: false),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          // ListView.builder(itemBuilder: itemBuilder),

          if (localRenderer != null &&roomClient.isCamera==true)
            Positioned(
                right: 5,
                bottom: 5,
                child:
                // roomClient.isCamera==true?
                Container(
                  height: 200,
                  width: 150,
                  child:RTCVideoView(
                    localRenderer,
                    mirror: true,
                  ),
                )
            ),

          if (roomClient.isCamera==false)
            Positioned(
              right: 5,
              bottom: 5,
              // alignment: Alignment.topRight,
              child: Container(
                height: 150,
                width: 150,
                child: Center(child: Text(roomClient.roomId.substring(0,2),style: TextStyle(color: Colors.white,fontSize: 30),)),
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}
