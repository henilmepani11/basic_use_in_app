import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router_0201/theme_controller.dart';

import 'dark_theme.demo.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = Get.put(MyRadioThemeController());

  @override
  void initState() {
    MyGetStorage().getThemeStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<MyRadioThemeController>(
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home:  const HomePage(),
          themeMode: controller.groupValue == 1
              ? ThemeMode.light
              : controller.groupValue == 2
                  ? ThemeMode.dark
                  : ThemeMode.system,
          darkTheme: MyThemes().dark,
          theme: MyThemes().light,
        );
      },
    );
  }
}

//homepage
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:go_router_0201/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final controller = Get.find<MyRadioThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RadioListTile Demo'),
      ),
      body: GetBuilder<MyRadioThemeController>(
        builder: (controller) => Container(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
                children: controller.themeList
                    .map((e) => RadioListTile(
                          value: e.index,
                          groupValue: controller.groupValue,
                          selected: e.selected,
                          onChanged: (val) {
                            controller.setToggleIndex(val);
                          },
                          title: Text(e.text),
                        ))
                    .toList()),
          ),
        ),
      ),
    );
  }
}

//custom theme
class MyThemes {
  ThemeData light = ThemeData(brightness: Brightness.light);
  ThemeData dark = ThemeData(brightness: Brightness.dark);
}

//radio toggle theme logic
class MyRadioThemeController extends GetxController {
  int? groupValue;
  final List<ThemeModel> themeList = [
    ThemeModel(text: "Light", index: 1, selected: true),
    ThemeModel(text: "dark", index: 2, selected: false),
    ThemeModel(text: "system", index: 3, selected: false),
  ];

  setToggleIndex(value) {
    for (int i = 0; i < themeList.length; i++) {
      themeList[i].selected = false;
      groupValue = value!;
      themeList[i].selected = true;
      MyGetStorage().setThemeStorage(value);
      update();
    }
  }
}
//model
class ThemeModel {
  String text;
  int index;
  bool selected;

  ThemeModel({required this.text, required this.index, required this.selected});
}

//store in local theme
class MyGetStorage {
  final box = GetStorage();
  final controller = Get.find<MyRadioThemeController>();
  setThemeStorage(value) {
    box.write('theme', value);
  }

  getThemeStorage() {
    controller.groupValue = box.read('theme') ?? 3;
  }
}


//switch toggle theme
class ThemeController extends GetxController {
  RxBool isDark = false.obs;

  toggleTheme() async {
    isDark.value = !isDark.value;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("theme", isDark.value);
    update();
  }

  getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isDark.value = pref.getBool("theme") ?? false;
  }

  @override
  void onInit() {
    super.onInit();
    getTheme();
  }
}
