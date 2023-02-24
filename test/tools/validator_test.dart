
import 'package:flutter_test/flutter_test.dart';
import 'package:lifestep/features/tools/common/validator.dart';

void main() {
  FormValidator formValidator = FormValidator();
  test('Empty Optional Email Test', () {
    var result = formValidator.validEmail('', req: false);
    expect(result, true);
  });
  test('Empty Required Email Test', () {
    var result = formValidator.validEmail('', req: false);
    expect(result, true);
  });
  test('Wrong Email Format', () {
    var result = formValidator.validEmail('info@examplecom', req: false);
    expect(result, false);
  });
  test('Correct Email Format', () {
    var result = formValidator.validEmail('info@example.com', req: false);
    expect(result, true);
  });

  test('Empty Optional Full Name Test', () {
    var result = formValidator.validFullName('', req: false);
    expect(result, true);
  });
  test('Empty Required Full Name Test', () {
    var result = formValidator.validFullName('', req: false);
    expect(result, true);
  });
  test('Wrong Full Name format', () {
    var result = formValidator.validFullName('Atakhan', req: false);
    expect(result, false);
  });
  test('Correct Full Name Format', () {
    var result = formValidator.validFullName('Atakhan Rahimli', req: true);
    expect(result, true);
  });

  test('Empty Optional Date Test', () {
    var result = formValidator.validDate('', req: false);
    expect(result, true);
  });
  test('Empty Required Date Test', () {
    var result = formValidator.validDate('', req: false);
    expect(result, true);
  });
  test('Wrong Date format', () {
    var result = formValidator.validDate('22.22.1990', req: true);
    expect(result, false);
  });
  test('Correct Date Format', () {
    var result = formValidator.validDate('22.12.1990', req: true);
    expect(result, true);
  });
}