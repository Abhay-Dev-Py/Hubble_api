import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserList extends StatelessWidget{

  final String apiUrl = "https://hubblesite.org/api/v3/news";

  Future<List<dynamic>> fetchnews() async {

    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body);

  }

  String _name(dynamic news){
    return news['name'];

  }

  String _newsUrl(dynamic news){
    return news['url'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,

        title: Text('Hubblesite News',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchnews(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){

              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return
                      Card(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage("https://hubblesite.org/files/live/sites/hubble/files/hs-logo-nasa.png?t=tn1600")
                              ),
                              title: Text(_name(snapshot.data[index])),
                              //subtitle: Text(_newsUrl(snapshot.data[index])),
                                subtitle: RichText(
                                    text: TextSpan(
                                        children: [

                                          TextSpan(
                                              style: TextStyle(color: Colors.blueAccent),
                                              text: "To learn more Click here",
                                              recognizer: TapGestureRecognizer()..onTap =  () async{
                                                var url = _newsUrl(snapshot.data[index]);
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              }
                                          ),
                                        ]
                                    ))
                              //trailing: Text(_age(snapshot.data[index])),

                            ),
                            SizedBox(height: 10,)
                          ],

                        ),
                      );
                  });
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        ),
      ),
    );
  }

}