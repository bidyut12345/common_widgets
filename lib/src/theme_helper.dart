import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.system);

class ThemeHelper {
  static late Brightness platformBrightness;
  static initialize(Function onThemeChange) {
    var dispatcher = SchedulerBinding.instance.platformDispatcher;
    dispatcher.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      platformBrightness = dispatcher.platformBrightness;
      onThemeChange();
    };
  }

  ///gives the brightness of the device only.
  static Brightness getSystemThemeMode() {
    return platformBrightness;
  }

  ///returns the bright of the app taking into account the system brightness.
  static Brightness getBrighnessCalculated(BuildContext context) {
    return Theme.of(context).brightness;
  }

  static bool isDarkMode(BuildContext context) {
    return getBrighnessCalculated(context) == Brightness.dark;
  }

  // ignore: non_constant_identifier_names
  static void SetTheme(ThemeMode thememode) {
    _themeMode.value = thememode;
  }

  // ignore: non_constant_identifier_names
  static Widget ThemeSetter({required Widget Function(ThemeMode) builder}) {
    return ValueListenableBuilder(
      valueListenable: _themeMode,
      builder: (context, value, child) {
        return builder(_themeMode.value);
      },
    );
  }

  static ListTile ThemeListTile() {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Theme"),
          SizedBox(
            width: 100,
            child: CustomDropDown(
              datasource: const [
                {"name": "Dark"},
                {"name": "Light"},
                {"name": "System"},
              ],
              displayMember: "name",
              valueMember: "name",
              labelText: "",
              showLabel: false,
              onChanged: (value, text) {
                switch (value) {
                  case "Dark":
                    {
                      SetTheme(ThemeMode.dark);
                      break;
                    }
                  case "Light":
                    {
                      SetTheme(ThemeMode.light);
                      break;
                    }
                  case "System":
                    {
                      SetTheme(ThemeMode.system);
                      break;
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
