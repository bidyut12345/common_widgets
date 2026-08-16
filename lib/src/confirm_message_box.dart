import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class MsgBoxGlobalConfigs {
  static ButtonStyle Function(BuildContext context) okButtonStyle = (context) {
    var isDarkMode_ = ThemeHelper.isDarkMode(context);
    var primaryColor = Theme.of(context).primaryColor;
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      elevation: 1,
    );
  };

  static ButtonStyle Function(BuildContext context, String buttonText, {bool isPrimary}) confirmButtonStyle =
      (context, buttonText, {bool isPrimary = false}) {
    var isDarkMode_ = ThemeHelper.isDarkMode(context);
    var primaryColor = Theme.of(context).primaryColor;
    if (isPrimary) {
      return ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 1,
      );
    }
    return OutlinedButton.styleFrom(
      foregroundColor: isDarkMode_ ? Colors.white70 : Colors.black87,
      side: BorderSide(color: isDarkMode_ ? Colors.white30 : Colors.black26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  };
}

Future showConfirmMessageBox(
  BuildContext context,
  String message, {
  String title = "",
  IconData icon = Icons.question_answer_outlined,
  String button1 = "Yes",
  String button2 = "No",
  String button3 = "",
  ButtonStyle? button1Style,
  ButtonStyle? button2Style,
  ButtonStyle? button3Style,
  String defaultButton = "Yes",
}) async {
  var isDarkMode_ = ThemeHelper.isDarkMode(context);
  var theme = Theme.of(context);
  var primaryColor = theme.primaryColor;

  return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (cntxt) {
        bool isButton1Primary = defaultButton == button1;
        bool isButton2Primary = defaultButton == button2;
        bool isButton3Primary = defaultButton == button3;

        Widget buildButton({
          required String label,
          required bool isPrimary,
          required bool isAutofocus,
          ButtonStyle? customStyle,
        }) {
          final style = customStyle ?? MsgBoxGlobalConfigs.confirmButtonStyle(context, label, isPrimary: isPrimary);

          if (isPrimary || customStyle != null) {
            return ElevatedButton(
              autofocus: isAutofocus,
              onPressed: () {
                Navigator.pop(cntxt, label);
              },
              style: style,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            );
          } else {
            return OutlinedButton(
              autofocus: isAutofocus,
              onPressed: () {
                Navigator.pop(cntxt, label);
              },
              style: style,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            );
          }
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDarkMode_ ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          backgroundColor: isDarkMode_ ? const Color(0xFF242731) : Colors.white,
          elevation: 12,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          clipBehavior: Clip.antiAlias,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon Badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: isDarkMode_ ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: isDarkMode_ ? Color.lerp(primaryColor, Colors.white, 0.3) : primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                if (title.isNotEmpty) ...[
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode_ ? Colors.white : Colors.black87,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: isDarkMode_ ? Colors.white70 : Colors.black.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 24),

                // Actions Row
                Row(
                  children: [
                    if (button3.isNotEmpty) ...[
                      Expanded(
                        child: buildButton(
                          label: button3,
                          isPrimary: isButton3Primary,
                          isAutofocus: defaultButton == button3,
                          customStyle: button3Style,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: buildButton(
                        label: button2,
                        isPrimary: isButton2Primary,
                        isAutofocus: defaultButton == button2,
                        customStyle: button2Style,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildButton(
                        label: button1,
                        isPrimary: isButton1Primary,
                        isAutofocus: defaultButton == button1,
                        customStyle: button1Style,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
