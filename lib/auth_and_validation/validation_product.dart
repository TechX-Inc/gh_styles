class ValidateProducts {
  static String validateProductName(String name) {
    if (name.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }

  static String validateQuantity(String quantity) {
    if (quantity.isEmpty) {
      return "Enter quantity";
    }
    return null;
  }

  static String validatePrice(String password) {
    if (password.isEmpty) {
      return "Enter price";
    }
    return null;
  }
}
