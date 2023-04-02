import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventDetailPage extends StatefulWidget {
  final dynamic event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  
  Color _colorFollow = Colors.white;
  bool following = false;

  Future<http.Response> _updateFollowing() async {
    following = !following;
    String event_id = widget.event['_id']['\$oid'];

    String uri = "${helpers.getUri()}/";
    if (following) {
      uri += "/following";
    }
    else {
      uri += "/unfollow";
    }

    final headers = {
      'Content-Type': 'application/json'
    };
    final bodyData = jsonEncode(<String, String> {
      'event_id': event_id
    });

    final response = await http.post(
      Uri.parse(uri),
      headers: headers,
      body: bodyData
    );
    
    if (response.statusCode == 200) {
      return response;
    }
    else {
      throw Exception("error posting id to follow_events: ${event_id}");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C2340),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 15.0, right: 15.0, bottom: 20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(widget.event['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          )),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200]!,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(7.5),
                                bottomLeft: Radius.circular(7.5),
                                topRight: Radius.circular(7.5),
                                bottomRight: Radius.circular(7.5),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.group,
                                size: 24.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              'Student Activities Office',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(
                                      color: Color(0xFF0C2340)),
                                ),
                              ),
                              backgroundColor: MaterialStatePropertyAll<Color>(_colorFollow)
                            ),
                            onPressed: () {
                              _updateFollowing();
                              const snackBar = SnackBar(
                                content: Text('Successfully updating following events'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              setState(() {
                                _colorFollow = (_colorFollow == Colors.white) ? Colors.blue : Colors.white;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.5,
                                vertical: 0.0,
                              ),
                              child: Text(
                                'Follow',
                                style: TextStyle(color: Color(0xFF0C2340)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200]!,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(7.5),
                                bottomLeft: Radius.circular(7.5),
                                topRight: Radius.circular(7.5),
                                bottomRight: Radius.circular(7.5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.event['startTime']!.day.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.yMMMMd()
                                    .format(widget.event['startTime']!),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('h:mm a')
                                    .format(widget.event['startTime']),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0,
                                  color: Colors.grey[600],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200]!,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(7.5),
                                bottomLeft: Radius.circular(7.5),
                                topRight: Radius.circular(7.5),
                                bottomRight: Radius.circular(7.5),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.location_on,
                                size: 24.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            widget.event['location']!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.event['description'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              launchURL(widget.event['registrationLink']);
            },
            child: Container(
              height: 60.0,
              width: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5),
                color: const Color(0xFF0C2340),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'RSVP',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: Colors.white,
                        letterSpacing: 1.25,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Icon(
                      Icons.open_in_browser,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void launchURL(String link) async {
    final Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
