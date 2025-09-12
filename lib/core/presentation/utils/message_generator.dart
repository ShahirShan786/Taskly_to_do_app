class MessageGenerator {
  static const Map<String, Map<String, String>> _messageMap = {
    "en": {
      "un-expected-error": "Some un expected error happened!",
      "un-expected-error-message": "Some un expected error happened!",
      "auth-welcome": "Input your credentials here to log in to the system.",
      "auth-visit-site-guide":
          "To explore in-depth instructions for utilizing this rapid starter Flutter project, head over to https://github.com/midhunarmid/taskly_to_do_app to kick off your journey.",
    }
  };

  static const Map<String, Map<String, String>> _labelMap = {
    "en": {
      "OK": "OK",
      "Email" : "Email",
      "Password" : "Password",
      "Login" : "Login",
      "Account_havent" : "Don't have an account?",
      "Account_have" :"Already have an account?",
      "Signup" : "Sign Up",
      
    }
  };

  static String getMessage(String message) {
    return (_messageMap[getLanguage()] ?? {})[message] ?? message;
  }

  static String getLabel(String label) {
    return (_labelMap[getLanguage()] ?? {})[label] ?? label;
  }

  static String getLanguage() {
    // Implement multi language support here
    return "en";
  }
}
