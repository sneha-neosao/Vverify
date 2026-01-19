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
    return 'Please enter pin code';
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
    return "Tenant's PAN Number is required";
  } else if (!panRegExp.hasMatch(value)) {
    return 'Please enter a valid PAN number';
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


String? validateNONotRequired(String? value) {
  RegExp dateRegExp = RegExp(r'^\d{1}$');

  if (value == null || value.isEmpty) {
    return null;
  } else if (!dateRegExp.hasMatch(value)) {
    return 'Please enter a valid number.';
  }
  return null;
}

var validateNOMask = MaskTextInputFormatter(
    mask: '#', filter: {"#": RegExp(r'[0-9]')});

//mobile mask
var mobileMaskFormatter =
    MaskTextInputFormatter(mask: '##########', filter: {"#": RegExp(r'[0-9]')});


var pinMask = MaskTextInputFormatter(
    mask: '######', filter: {"#": RegExp(r'[0-9]')});

var onlyYearMask = MaskTextInputFormatter(
    mask: '####', filter: {"#": RegExp(r'[0-9]')});

var onlyMonthMask = MaskTextInputFormatter(
    mask: '##', filter: {"#": RegExp(r'[0-9]')});