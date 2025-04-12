import 'package:apyar/app/models/app_config_model.dart';
import 'package:flutter/material.dart';

//path
ValueNotifier<String> appRootPathNotifier = ValueNotifier('');
ValueNotifier<String> appExternalPathNotifier = ValueNotifier('');
ValueNotifier<String> appConfigPathNotifier = ValueNotifier('');
//theme
ValueNotifier<bool> isDarkThemeNotifier = ValueNotifier(false);
//config
ValueNotifier<AppConfigModel> appConfigNotifier =
    ValueNotifier(AppConfigModel());
