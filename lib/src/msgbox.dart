import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';

/// Modern styled multi-button message dialog widget.
/// Returns a [Dialog] widget that pops the selected button's key on tap.
Widget msgBox({
  required String title,
  required String message,
  required Map<String, IconData> buttons,
  required BuildContext context,
  IconData? icon,
}) {
  var isDarkMode_ = ThemeHelper.isDarkMode(context);
  var theme = Theme.of(context);
  var primaryColor = theme.primaryColor;

  IconData effectiveIcon = icon ??
      (buttons.isNotEmpty
          ? buttons.values.first
          : Icons.question_answer_outlined);

  Widget buildButton({
    required String label,
    required IconData? iconData,
    required bool isPrimary,
    required bool isAutofocus,
  }) {
    final style = MsgBoxGlobalConfigs.confirmButtonStyle(context, label, isPrimary: isPrimary);

    final Widget labelWidget = Text(
      label,
      style: TextStyle(
        fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
        fontSize: 14,
      ),
    );

    final hasValidIcon = iconData != null;

    if (isPrimary || label == "Yes" || label == "No") {
      return ElevatedButton(
        autofocus: isAutofocus,
        onPressed: () {
          Navigator.pop(context, label);
        },
        style: style,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasValidIcon) ...[
                Icon(iconData, size: 18),
                const SizedBox(width: 6),
              ],
              Flexible(child: labelWidget),
            ],
          ),
        ),
      );
    } else {
      return OutlinedButton(
        autofocus: isAutofocus,
        onPressed: () {
          Navigator.pop(context, label);
        },
        style: style,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasValidIcon) ...[
                Icon(iconData, size: 18),
                const SizedBox(width: 6),
              ],
              Flexible(child: labelWidget),
            ],
          ),
        ),
      );
    }
  }

  final buttonEntries = buttons.entries.toList();

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
              effectiveIcon,
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
              for (int i = 0; i < buttonEntries.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: buildButton(
                    label: buttonEntries[i].key,
                    iconData: buttonEntries[i].value,
                    isPrimary: buttonEntries[i].key == "Yes" || buttonEntries[i].key == "Ok" || i == 0,
                    isAutofocus: buttonEntries[i].key == "Yes" || buttonEntries[i].key == "Ok" || i == 0,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}

/// Modern styled single "Ok" button message dialog.
/// Displays dialog with optional [onComplete] callback after dismissal.
Future<void> msgBoxOkOnly({
  required BuildContext context,
  required String title,
  required String message,
  Function? onComplete,
  IconData? icon,
}) async {
  if (!context.mounted) return;
  await showDialog(
    context: context,
    useRootNavigator: false,
    builder: (cnt) {
      return _MsgBoxOkDialog(
        title: title,
        message: message,
        icon: icon,
      );
    },
  );
  if (onComplete != null) onComplete();
}

/// Modern styled single "Ok" button message dialog returning a Future.
Future<dynamic> msgBoxOkOnlyFuture({
  required BuildContext context,
  required String title,
  required String message,
  IconData? icon,
}) {
  return showDialog(
    context: context,
    builder: (cnt) {
      return _MsgBoxOkDialog(
        title: title,
        message: message,
        icon: icon,
      );
    },
  );
}

class _MsgBoxOkDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;

  const _MsgBoxOkDialog({
    required this.title,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var isDarkMode_ = ThemeHelper.isDarkMode(context);
    var theme = Theme.of(context);
    var sc = ScrollController();

    IconData effectiveIcon;
    if (icon != null) {
      effectiveIcon = icon!;
    } else {
      final lowerTitle = title.toLowerCase();
      if (lowerTitle.contains("error") || lowerTitle.contains("invalid") || lowerTitle.contains("failed")) {
        effectiveIcon = Icons.error_outline;
      } else if (lowerTitle.contains("success") || lowerTitle.contains("saved") || lowerTitle.contains("sent") || lowerTitle.contains("connected")) {
        effectiveIcon = Icons.check_circle_outline;
      } else if (lowerTitle.contains("warning") || lowerTitle.contains("stock")) {
        effectiveIcon = Icons.warning_amber_rounded;
      } else {
        effectiveIcon = Icons.info_outline;
      }
    }

    Color iconColor;
    Color iconBgColor;
    if (effectiveIcon == Icons.error_outline) {
      iconColor = isDarkMode_ ? const Color(0xFFF87171) : const Color(0xFFDC2626);
      iconBgColor = (isDarkMode_ ? const Color(0xFFEF4444) : const Color(0xFFDC2626)).withValues(alpha: isDarkMode_ ? 0.2 : 0.1);
    } else if (effectiveIcon == Icons.check_circle_outline) {
      iconColor = isDarkMode_ ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
      iconBgColor = (isDarkMode_ ? const Color(0xFF22C55E) : const Color(0xFF16A34A)).withValues(alpha: isDarkMode_ ? 0.2 : 0.1);
    } else if (effectiveIcon == Icons.warning_amber_rounded) {
      iconColor = isDarkMode_ ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
      iconBgColor = (isDarkMode_ ? const Color(0xFFF59E0B) : const Color(0xFFD97706)).withValues(alpha: isDarkMode_ ? 0.2 : 0.1);
    } else {
      var primaryColor = theme.primaryColor;
      iconColor = isDarkMode_ ? Color.lerp(primaryColor, Colors.white, 0.3)! : primaryColor;
      iconBgColor = primaryColor.withValues(alpha: isDarkMode_ ? 0.2 : 0.1);
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
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Icon Badge
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                effectiveIcon,
                size: 28,
                color: iconColor,
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

            // Message Body (scrollable if long)
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                controller: sc,
                child: SingleChildScrollView(
                  controller: sc,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: isDarkMode_ ? Colors.white70 : Colors.black.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  autofocus: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: MsgBoxGlobalConfigs.okButtonStyle(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      "Ok",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
