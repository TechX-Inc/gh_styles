import 'package:email_validator/email_validator.dart';
import 'package:string_validator/string_validator.dart';

class ValidateShopData{


  // static String validateShop
  //optional
  //required
  //email validator
  //phone number validator
  //website validator

  static String checkRequired(String name){
    if (name.isEmpty){
      return "This field is required";
    }
    return null;
  }

    static String validateEmail(String email){
    if (email.isEmpty){
      return "This field is required";
    }else if(!EmailValidator.validate(email)){
      return "Enter a valid email";
    }
    return null;
  }


  static String validateNumber(String phone){
     if (phone.isEmpty){
      return "This field is required";
    }else if(!isNumeric(phone) && phone.length < 3){
      return "Enter a valid mobile number";
    }
    return null;
  }

  static String validateUrl(String url){
    if (url.isNotEmpty && !isURL(url)) {
      return "Enter a valid url";
    }
    return null;
  }



}