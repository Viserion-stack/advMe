String validateemail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}

String validateTitle(String value) {
  if (!value.isNotEmpty) {
    return 'Please enter some text';
  }
  print(value);
  return null;
}

String validateDescription(String value) {
  if (value.isEmpty) {
    return 'Please enter a description.';
  }
  if (value.length < 10) {
    return 'Should be at least 10 characters long.';
  }
  return null;
}

String validatePrice(String value) {
  if (value.isEmpty) {
    return 'Please enter a price.';
  }
  if (double.tryParse(value) == null) {
    return 'Please enter a valid number.';
  }
  if (double.parse(value) <= 0) {
    return 'Please enter a number greater than zero.';
  }
  if (double.parse(value) > 9999999) {
    return 'Please enter a number in range 1-9999999.';
  }
  return null;
}

String validatePhone(String value) {
  if (value.isEmpty) {
    return 'Please enter a valid phone number.';
  }
  if (double.tryParse(value) == null) {
    return 'Please enter a valid number.';
  }
  if (value.length < 4) {
    return 'Should be at least 4 characters long.';
  }
  return null;
}

String validateWebsite(String value) {
  if (!value.startsWith('http') &&
      !value.startsWith('https') &&
      !value.startsWith('www')) {
    return 'Please enter a valid URL adress.';
  }
  if (!value.contains('.')) {
    return 'Please enter a valid URL adress.';
  }
  return null;
}
