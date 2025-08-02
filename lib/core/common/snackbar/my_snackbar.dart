import 'package:flutter/material.dart';


enum SnackBarType { success, error, info }


void showMySnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.info, 
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  final theme = Theme.of(context);
  final Color backgroundColor;
  final IconData iconData;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = theme.colorScheme.secondary;
      iconData = Icons.check_circle_outline;
      break;
    case SnackBarType.error:
      backgroundColor = theme.colorScheme.error;
      iconData = Icons.error_outline;
      break;
    case SnackBarType.info:
    default:
      backgroundColor = theme.colorScheme.primary;
      iconData = Icons.info_outline;
      break;
  }

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(iconData, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    
    behavior: SnackBarBehavior.floating,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),

    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

    dismissDirection: DismissDirection.horizontal,
  );

  // Show the snackbar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}