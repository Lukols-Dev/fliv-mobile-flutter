import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/features/route/domain/dispatcher_route_polyline_decoder.dart';

void main() {
  const decoder = DispatcherRoutePolylineDecoder();
  const polyline = 'BFoz5xJ67i1B1B7PzIhaxL7Y';

  test('decodes a HERE flexible polyline section', () {
    final sections = decoder.decodeSections(polyline);

    expect(sections, hasLength(1));
    expect(sections.single, hasLength(4));
    expect(sections.single.first.latitude, closeTo(50.10228, 0.00001));
    expect(sections.single.first.longitude, closeTo(8.69821, 0.00001));
    expect(sections.single.last.latitude, closeTo(50.09878, 0.00001));
    expect(sections.single.last.longitude, closeTo(8.68752, 0.00001));
  });

  test('decodes multiple route sections separated by pipe', () {
    final sections = decoder.decodeSections('$polyline | $polyline');

    expect(sections, hasLength(2));
    expect(sections.first, hasLength(4));
    expect(sections.last, hasLength(4));
  });
}
