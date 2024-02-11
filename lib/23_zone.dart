import 'dart:async';

void main() async {
  var secret = 'arglebargle';

  var result = runZoned(
    () async {
      await Future.delayed(Duration(seconds: 2), () {
        print('${Zone.current[#_secret]} glop glyf');
      });
    },
    zoneValues: {
      #_secret: secret,
    },
    zoneSpecification: ZoneSpecification(
      print: (Zone self, parent, zone, String value) {
        if (value.contains(Zone.current[#_secret] as String)) {
          value = '--censored--';
        }
        parent.print(zone, value);
      },
    ),
  );

  secret = '';

  await result;
}
