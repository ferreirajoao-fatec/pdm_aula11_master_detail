import 'package:flutter_test/flutter_test.dart';

import 'package:pdm_aula11_master_detail/main.dart';

void main() {
  testWidgets('Exibe a tela Portal de Notícias', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());
    expect(find.text('Portal de Notícias'), findsOneWidget);
  });
}
