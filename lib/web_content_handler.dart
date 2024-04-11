import "dart:convert";
import "dart:io";
import "package:sansadtv_app/constants.dart";
import "package:universal_html/html.dart";
import "package:universal_html/parsing.dart";

Future<dynamic> fetchHTML(String url) async {
  try {
    SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(certificate.codeUnits);

    HttpClient client = HttpClient(context: context);
    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      String html = await response.transform(const Utf8Decoder()).join();
      final document = parseHtmlDocument(html);
      return document;
    } else {
      throw Exception();
    }
  } catch (e) {
    rethrow;
  }
}

class NavItem {
  late String label;
  late String href;
  late List<NavItem> children;

  NavItem(Element element) {
    label = element.children[0].innerHtml!;
    href = element.children[0].getAttribute('href') ?? "";
    children = [];
    element.children.skip(1).forEach((body) {
      if (body is! AnchorElement && body is! UListElement) {
        return;
      }
      for (var child in body.children) {
        children.add(NavItem(child));
      }
    });
  }
}
