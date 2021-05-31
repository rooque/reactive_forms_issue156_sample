import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyString {
  String s;
  MyString({
    required this.s,
  });
}

class HomeController extends GetxController {
  var myList = <MyString>[].obs;

  var formGroup = fb.group({'list': fb.array([])});

  FormArray get formArray => formGroup.control('list') as FormArray;

  void remove(MyString s) {
    var i = myList.indexOf(s);
    myList.remove(s);
    formArray.removeAt(i);
  }

  void add(MyString s) {
    formArray.add(FormControl<String>(value: s.s));
    myList.add(s);
  }
}

class MyHomePage extends GetView<HomeController> {
  List<Widget> get list {
    return controller.formArray.controls.map((e) {
      var i = controller.formArray.controls.indexOf(e);
      return formText(controller.myList[i]);
    }).toList();
  }

  Widget formText(MyString s) {
    var i = controller.myList.indexOf(s);
    return Container(
      child: Row(
        children: [
          Expanded(
            child: ReactiveTextField(
              formControlName: 'list.$i',
            ),
          ),
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    controller.remove(s);
                  },
                  child: Text('-')))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactiveForm(
        formGroup: controller.formGroup,
        child: Center(
          child: ReactiveValueListenableBuilder(
            formControlName: 'list',
            builder: (_, __, ___) => Column(
              children: [
                ...list,
                ElevatedButton(
                    onPressed: () {
                      controller
                          .add(MyString(s: Random().nextInt(100).toString()));
                    },
                    child: Text('+'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
