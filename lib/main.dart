import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(title: 'Networking'),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.title, required this.lat, required this.lon});

  final String title;
  final String lat;
  final String lon;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var data;

  @override
  void initState() {
    super.initState();
    setState ((){
      readJson();
    });
  }

  Future<void> readJson() async {
    final response = await http.get(Uri.parse('https://api.weather.yandex.ru/v2/forecast?lat=${widget.lat}&lon=${widget.lon}&lang=ru_RU&limit=2&extra=true'), headers:  {"X-Yandex-API-Key": "9d1f512e-392d-4dd3-8f26-068c0a1f74b0"});

    if (response.statusCode == 200) {
      setState ((){
        data = json.decode(response.body);
      });
      setState ((){
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            data != null
            ? Expanded(child: Container(
              child: Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Широта: ${data["info"]["lat"]}, Долгота: ${data["info"]["lon"]}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      flex: 0,
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          '${data["fact"]["temp"]}°',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      flex: 0,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                        alignment: Alignment.topCenter,
                        child: Text(
                          '${data["fact"]["condition"]}\nОщущается как: ${data["fact"]["feels_like"]}°',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      flex: 0,
                      child: Container(
                          child: Text(
                            '༄${data["fact"]["wind_speed"]},${data["fact"]["wind_dir"]}         ${data["fact"]["pressure_mm"]}мм рт.ст.        💧${data["fact"]["humidity"]}%',
                            style: TextStyle(
                              fontSize: 20,
                              height: 2.5,
                            ),
                          )
                      )
                  ),
                  Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      'Ночь\nmax: ${data["forecasts"][0]["parts"]["night"]["temp_max"]}°\nmin: ${data["forecasts"][0]["parts"]["night"]["temp_min"]}°',
                                      style: TextStyle(
                                        fontSize: 20,
                                        height: 2.5,
                                      ),
                                    )
                                )
                            ),
                            Expanded(
                                child: Container(
                                    child: Text(
                                      'Утро\nmax: ${data["forecasts"][0]["parts"]["morning"]["temp_max"]}°\nmin: ${data["forecasts"][0]["parts"]["morning"]["temp_min"]}°',
                                      style: TextStyle(
                                        fontSize: 20,
                                        height: 2.5,
                                      ),
                                    )
                                )
                            ),
                            Expanded(
                                child: Container(
                                    child: Text(
                                      'День\nmax: ${data["forecasts"][0]["parts"]["day"]["temp_max"]}°\nmin: ${data["forecasts"][0]["parts"]["day"]["temp_min"]}°',
                                      style: TextStyle(
                                        fontSize: 20,
                                        height: 2.5,
                                      ),
                                    )
                                )
                            ),
                            Expanded(
                                child: Container(
                                    child: Text(
                                      'Вечер\nmax: ${data["forecasts"][0]["parts"]["evening"]["temp_max"]}°\nmin: ${data["forecasts"][0]["parts"]["evening"]["temp_min"]}°',
                                      style: TextStyle(
                                        fontSize: 20,
                                        height: 2.5,
                                      ),
                                    )
                                )
                            )
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ))
            : Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class StartPage extends StatefulWidget {
  const StartPage({super.key, required this.title});

  final String title;

  @override
  State<StartPage> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {

  final _controller = TextEditingController();
  final _controller2 = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = _controller.value.text;
    if (text != '') {
      return null;
    }
    if (text == '') {
      return 'Введите цель';
    }
  }

  String? get _errorText2 {
    final text = _controller2.value.text;
    if (text != '') {
      return null;
    }
    if (text == '') {
      return 'Введите описание цели';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                onChanged: (_) => setState(() {}),
                controller: _controller,
                decoration: InputDecoration(
                  errorText: _errorText,
                  border: UnderlineInputBorder(),
                  labelText: 'Введите широту',
                ),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                onChanged: (_) => setState(() {}),
                controller: _controller2,
                decoration: InputDecoration(
                  errorText: _errorText2,
                  border: UnderlineInputBorder(),
                  labelText: 'Введите долготу',
                ),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPage(title: 'Networking', lat: _controller.value.text, lon: _controller2.value.text)),
                    );
                  },
                  child: Text('Показать прогноз')),
            )
          ],
      )
    );
  }
}
