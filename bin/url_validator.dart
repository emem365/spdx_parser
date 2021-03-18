class UrlValidator{
  static final RegExp regex = RegExp(r"^(?:http(s)?:\/\/)([\w.-])+(?:[\w\.-]+)+([\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.])+$");
  
  static bool isValid(String url){
    return regex.hasMatch(url);
  }

  static bool isGitHubUrl(String url){
    return url.contains('github.com');
  }
}