import 'package:chronoclass/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// importa o arquivo principal do app
// ou, se quiser testar outra tela, troque para:
// exemplo: testar a tela de login

void main() {
  testWidgets('Tela principal carrega corretamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(),
    ); // ou LoginPage() se estiver testando ela

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
