import 'dart:io';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'url_validator.dart';
import 'xml_to_markdown.dart';

const String kDomain = 'raw.githubusercontent.com';
void main(List<String> arguments) async {
  if (arguments.length != 1) {
    print('Invalid command');
    print('Usage: dart */main.dart <url>');
    exit(1);
  }

  final url = arguments[0].trim();
  if (!UrlValidator.isValid(url)) {
    print('Invalid URL');
    exit(2);
  }

  if (!UrlValidator.isGitHubUrl(url)) {
    print('Invalid URL: URL should to be a GitHub URL');
    exit(3);
  }

  final endsAt = url.indexOf('github.com') + 10; // 'github.com' is 10 chars
  final path = url.substring(endsAt).replaceAll('/blob', '');

  try {
    print('Getting the source...');
    final source = await http.read(Uri.https(kDomain, path));
    print('Got source\n');
    print('Parsing...');
    final xmlDoc = XmlDocument.parse(source);
    final converter = XmlToMarkdown(xmlDoc);
    final markdown = converter.parse();
    print('\nOutput:');
    print(markdown);
  } catch (e) {
    print('Error: ${e.toString()}');
    exit(4);
  }
}

// name email dob degree - college or school   standard board   college- degree / +year
