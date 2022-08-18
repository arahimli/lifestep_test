
import 'package:flutter/material.dart';

class PagePadding extends EdgeInsets{
  PagePadding.leftRight16() : super.symmetric(horizontal: 16);
  PagePadding.all16() : super.symmetric(horizontal: 16, vertical: 16);
}