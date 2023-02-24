
import 'package:flutter/material.dart';

class PagePadding extends EdgeInsets{
  const PagePadding.leftRight16() : super.symmetric(horizontal: 16);
  const PagePadding.all16() : super.symmetric(horizontal: 16, vertical: 16);
}