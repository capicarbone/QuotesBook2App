import 'package:flutter/material.dart';

@Deprecated("Access data throush Localizations class instead.")
class LocalizeLang extends StatelessWidget {

  Function builder;

  LocalizeLang({required this.builder});

  @override
  Widget build(BuildContext context) {
    var lang = Localizations.localeOf(context).languageCode;
    return builder(lang);
  }
}
