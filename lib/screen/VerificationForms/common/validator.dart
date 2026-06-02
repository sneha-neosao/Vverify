// Address validator to check more than 10 words
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

String? cannotBeEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an address';
  }
  return null;
}

String? addressValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Address is required';
  }
  if (value.length <= 10) {
    return 'Please enter more than 10 characters';
  }
  return null;
}

// Mobile Validator Function
String? validateMobile(String? value) {
  RegExp regExp = RegExp(r'^\d{10}$');
  if (value == null || value.isEmpty) {
    return 'Mobile Number is required';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter a valid 10-digit mobile number';
  }
  return null;
}

// email Validator Function
String? validateEmail(String? value) {
  RegExp regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (value == null || value.isEmpty) {
    return 'Email is required';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter a valid email.';
  }
  return null;
}

// email Validator Function
String? validateDate(String? value) {
  RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  //RegExp(r'^\d{4}-\d{2}-\d{2}$');

  if (value == null || value.isEmpty) {
    return 'Please enter a date';
  } else if (!dateRegExp.hasMatch(value)) {
    return 'Please enter a valid date.';
  }
  return null;
}

String? validateBirthDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Date is required';
  }
  return null;
}

String? validatePinCode(String? value) {
  RegExp dateRegExp = RegExp(r'^\d{6}$');

  if (value == null || value.isEmpty) {
    return 'Pin Code is required';
  } else if (!dateRegExp.hasMatch(value)) {
    return 'Please enter a valid pin code.';
  }
  return null;
}

String? validateNO(String? value) {
  RegExp dateRegExp = RegExp(r'^\d{1}$');

  if (value == null || value.isEmpty) {
    return 'Please enter number';
  } else if (!dateRegExp.hasMatch(value)) {
    return 'Please enter a valid number.';
  }
  return null;
}

String? validatePAN(String? value) {
  RegExp panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  if (value == null || value.isEmpty) {
    return "PAN Number is required";
  } else if (!panRegExp.hasMatch(value)) {
    return 'Please enter a valid PAN number';
  }
  return null;
}

// Passport Number Validator (Indian Passport Format: 1 letter + 7 digits)
String? validatePassport(String? value) {
  RegExp passportRegExp = RegExp(r'^[A-Z]{1}[0-9]{7}$');

  if (value == null || value.isEmpty) {
    return "Passport Number is required";
  } else if (!passportRegExp.hasMatch(value)) {
    return 'Please enter a valid Passport number';
  }
  return null;
}

String? addressValidatorNotRequired(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  if (value.length <= 10) {
    return 'Please enter more than 10 characters';
  }
  return null;
}

// Mobile Validator Function
String? validateMobileNotRequired(String? value) {
  RegExp regExp = RegExp(r'^\d{10}$');
  if (value == null || value.isEmpty) {
    return null;
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter a valid 10-digit mobile number';
  }
  return null;
}

// email Validator Function
String? validateEmailNotRequired(String? value) {
  RegExp regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (value == null || value.isEmpty) {
    return null;
  } else if (!regex.hasMatch(value)) {
    return 'Please enter a valid email address.';
  }
  return null;
}

// email Validator Function
String? validateDateNotRequired(String? value) {
  RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  if (value == null || value.isEmpty) {
    return null;
  } else if (!dateRegExp.hasMatch(value)) {
    return 'Please enter a valid date.';
  }
  return null;
}

String? validatePinCodeNotRequired(String? value) {
  RegExp dateRegExp = RegExp(r'^\d{6}$');

  if (value == null || value.isEmpty) {
    return null;
  } else if (!dateRegExp.hasMatch(value)) {
    return 'Please enter a valid pin code.';
  }
  return null;
}

String? validateDrivingLicence(String? value) {
  RegExp regExp = RegExp(r'^[a-zA-Z]{2}\d{2}\s?\d{11}');

  if (value == null || value.isEmpty) {
    return 'Driving Licence Number is required';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter a valid driving licence number';
  }
  return null;
}

String? validateNONotRequired(String? value) {
  RegExp dateRegExp = RegExp(r'^\d{1}$');

  if (value == null || value.isEmpty) {
    return null;
  } else if (!dateRegExp.hasMatch(value)) {
    return 'Please enter a valid number.';
  }
  return null;
}

String? validateGst(String? value) {
  if (value != null && value.isNotEmpty) {
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
      caseSensitive: false,
    );

    if (!gstRegex.hasMatch(value)) {
      return 'Please enter a valid GST number.';
    }
  }
  return null;
}

String? validatePan(String? value) {
  // Check if the field is not empty and then validate
  if (value != null && value.isNotEmpty) {
    // Example validation: check if it's a valid email
    if (!RegExp(r"^[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}$").hasMatch(value)) {
      return 'Please enter a valid PAN number';
    }
  }
  // Return null if valid or empty (valid for non-required fields)
  return null;
}

String? validateCin(String? value) {
  // Check if the field is not empty and then validate
  if (value != null && value.isNotEmpty) {
    // Example validation: check if it's a valid email
    if (!RegExp(r"^[a-zA-Z]{1}[0-9]{5}[a-zA-Z]{2}[0-9]{4}[a-zA-Z]{3}[0-9]{6}$")
        .hasMatch(value)) {
      return 'Please enter a valid CIN number.';
    }
  }
  // Return null if valid or empty (valid for non-required fields)
  return null;
}

var validateNOMask =
    MaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[0-9]')});

//mobile mask
var mobileMaskFormatter =
    MaskTextInputFormatter(mask: '##########', filter: {"#": RegExp(r'[0-9]')});

var pinMask =
    MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[0-9]')});

var onlyYearMask =
    MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

var onlyMonthMask =
    MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});
