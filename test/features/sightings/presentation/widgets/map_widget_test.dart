import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_watch/features/sightings/presentation/widgets/map_widget.dart';
import '../../../../helpers/helpers.dart';

void main() {
  Future<void> _setupMapWidget(WidgetTester tester) async {
    await tester.pumpApp(
      const MapWidget(),
    );
  }

  group('renders MapWidget', () {
    testWidgets('renders GoogleMap', (tester) async {
      await _setupMapWidget(tester);
      await tester.pumpAndSettle();
      expect(find.byType(GoogleMap), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
