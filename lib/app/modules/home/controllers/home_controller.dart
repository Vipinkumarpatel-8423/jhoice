import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/campaign_model.dart';
import 'package:home_services/app/repositories/notification_repository.dart';
import 'package:video_player/video_player.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;
  NotificationRepository _notificationRepository;
  VideoPlayerController _videoPlayerController;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;
  final campaign = <Campaign>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
    _notificationRepository = new NotificationRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();

    // print(await FirebaseMessaging.instance.getToken());
    // print("user");
    // print(Get.find<AuthService>().isAuth);
    if (Get.find<AuthService>().isAuth) {
      saveToken();
    }
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) _videoPlayerController.dispose();
    super.dispose();
  }

  void showCampaign() async {
    if (_videoPlayerController == null) if (Get.find<AuthService>().isAuth) {
      await getCampaign();
      if (await Get.find<AuthService>().isTodaysFirstLogin()) {
        bool firstLogin = !await Get.find<AuthService>().isFirstLogin();
        if (campaign.length > 0) {
          Ui.campaignAds(campaign.elementAt(0), 0, campaign,
              _videoPlayerController, firstLogin);
        }
        Get.find<AuthService>().saveLastLoginTime();
        Get.find<AuthService>().saveFirstLoginCampaign();
      }
    }
  }

  void saveToken() async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('https://jhoice.com/api/save_token'));
    request.body = json.encode({
      "userId": Get.find<AuthService>().user.value.id,
      "device_token": await FirebaseMessaging.instance.getToken(),
      "table": "user"
    });
    request.headers.addAll(headers);
    print(request.body);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("api call");
      print(await response.stream.bytesToString());
    } else {
      print("api call");
      print(response.reasonPhrase);
    }
  }

  Future refreshHome({bool showMessage = false}) async {
    await getSlider();
    await getCategories();
    await getFeatured();
    if (Get.find<AuthService>().isAuth) await getCampaign();
    await getRecommendedEServices();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
    showCampaign();
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCampaign() async {
    try {
      campaign.assignAll(await _notificationRepository.getCompaigns());
      print('camaign $campaign');
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
