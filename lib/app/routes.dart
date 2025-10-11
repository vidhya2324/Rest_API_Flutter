import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_api_flutter/pages/fetchdata.dart';
import 'package:rest_api_flutter/pages/listview.dart';


List<GetPage> appRoutes() => [
  GetPage(
    name: '/listview',
    page: () => RestApiScreen(),
    transition: Transition.upToDown,
  ),

    GetPage(
    name: '/fetchdata',
    page: () => FetchData(),
    transition: Transition.upToDown,
  ),
 
];
