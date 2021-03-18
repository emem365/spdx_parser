import 'package:xml/xml.dart';

class XmlToMarkdown {
  final XmlDocument source;

  XmlToMarkdown(this.source);

  String parse() {
    var buffer = StringBuffer();
    convertToMarkDown(buffer, source);
    return buffer.toString();
  }

  void convertToMarkDown(StringBuffer buffer, XmlNode xml) {
    if (xml.toString().startsWith('<p') || xml.toString().startsWith('<item')) {
      var localBuffer = StringBuffer();
      convertElement(localBuffer, xml);
      final text = localBuffer.toString().trim();
      if (text.isNotEmpty) {
        buffer.write('$text\n\n');
      }
      return;
    } else if (xml.nodeType == XmlNodeType.TEXT) {
      var localBuffer = StringBuffer();
      convertText(localBuffer, xml);
      final text = localBuffer.toString().trim();
      if (text.isNotEmpty) {
        buffer.write('$text\n\n');
      }
      return;
    }

    for (var node in xml.nodes) {
      convertToMarkDown(buffer, node);
    }
  }

  void convertText(StringBuffer buffer, XmlNode node) {
    var strg = node.text.replaceAll(RegExp('[\n][ ]{2,}'), '\n').trim();
    if (strg.isNotEmpty) {
      buffer.write('$strg ');
    }
  }

  void convertElement(StringBuffer buffer, XmlNode node) {
    if (node.nodeType == XmlNodeType.TEXT) {
      convertText(buffer, node);
      return;
    }
    for (var newNode in node.nodes) {
      convertElement(buffer, newNode);
    }
  }
}
