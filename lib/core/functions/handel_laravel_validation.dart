import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidationHelper {
  // Show validation errors in a dialog
  static void showValidationErrorDialog({
    required Map<String, dynamic> errors,
    String title = 'Validation Errors',
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildErrorWidgets(errors),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show validation errors as snackbar
  static void showValidationErrorSnackbar({
    required Map<String, dynamic> errors,
    String title = 'Validation Error',
    Duration duration = const Duration(seconds: 4),
  }) {
    String errorMessage = _formatErrorsAsString(errors);
    
    Get.snackbar(
      title,
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      icon: const Icon(Icons.error, color: Colors.red),
      duration: duration,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  // Show validation errors as bottom sheet
  static void showValidationErrorBottomSheet({
    required Map<String, dynamic> errors,
    String title = 'Validation Errors',
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...(_buildErrorWidgets(errors)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Get specific field error
  static String? getFieldError(Map<String, dynamic> errors, String fieldName) {
    if (errors.containsKey(fieldName)) {
      var fieldErrors = errors[fieldName];
      if (fieldErrors is List && fieldErrors.isNotEmpty) {
        return fieldErrors.first.toString();
      } else if (fieldErrors is String) {
        return fieldErrors;
      }
    }
    return null;
  }

  // Check if field has error
  static bool hasFieldError(Map<String, dynamic> errors, String fieldName) {
    return getFieldError(errors, fieldName) != null;
  }

  // Get all errors as a flat list
  static List<String> getAllErrors(Map<String, dynamic> errors) {
    List<String> allErrors = [];
    
    errors.forEach((field, fieldErrors) {
      if (fieldErrors is List) {
        for (var error in fieldErrors) {
          allErrors.add(error.toString());
        }
      } else if (fieldErrors is String) {
        allErrors.add(fieldErrors);
      }
    });
    
    return allErrors;
  }

  // Format errors as single string
  static String _formatErrorsAsString(Map<String, dynamic> errors) {
    List<String> errorMessages = [];
    
    errors.forEach((field, fieldErrors) {
      String fieldName = _formatFieldName(field);
      
      if (fieldErrors is List) {
        for (var error in fieldErrors) {
          errorMessages.add('• $fieldName: ${error.toString()}');
        }
      } else if (fieldErrors is String) {
        errorMessages.add('• $fieldName: $fieldErrors');
      }
    });
    
    return errorMessages.join('\n');
  }

  // Build error widgets for display
  static List<Widget> _buildErrorWidgets(Map<String, dynamic> errors) {
    List<Widget> widgets = [];
    
    errors.forEach((field, fieldErrors) {
      String fieldName = _formatFieldName(field);
      
      // Add field title
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            fieldName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      );
      
      // Add field errors
      if (fieldErrors is List) {
        for (var error in fieldErrors) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.red)),
                  Expanded(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else if (fieldErrors is String) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.red)),
                Expanded(
                  child: Text(
                    fieldErrors,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      
      widgets.add(const SizedBox(height: 10));
    });
    
    return widgets;
  }

  // Format field name for display
  static String _formatFieldName(String fieldName) {
    return fieldName
        .split('_')
        .map((word) => word.capitalize)
        .join(' ');
  }

  // Widget to display field-specific error
  static Widget fieldErrorWidget(
    Map<String, dynamic> errors,
    String fieldName, {
    TextStyle? style,
  }) {
    String? error = getFieldError(errors, fieldName);
    
    if (error == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        error,
        style: style ?? const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }




}
