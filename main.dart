import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'goodbye': 'Goodbye',
    },
    'es_ES': {
      'hello': 'Hola',
      'goodbye': 'Adiós',
    },
  };
}

void main() async {
  await GetStorage.init();
  // Get.put(Localization());
  runApp(MyApp());
}



class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final  box= GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale(box.read('locale')),
      translations: Localization(),
      title: 'My App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // final Localization localization = Get.find<Localization>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello".tr), // Accessing translation
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                box.write('locale', 'en_US'); // Writing locale to GetStorage
                Get.updateLocale(const Locale('en', 'US')); // Updating locale
              },
              child: const Text('English'),
            ),
            ElevatedButton(
              onPressed: () {
                box.write('locale', 'es_ES'); // Writing locale to GetStorage
                Get.updateLocale(const Locale('es', 'ES')); // Updating locale
              },
              child: const Text('Spanish'),
            ),
            Text("goodbye".tr), // Accessing another translation
          ],
        ),
      ),
    );
  }
}
