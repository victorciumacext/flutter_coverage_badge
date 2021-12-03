import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_coverage_badge/flutter_coverage_badge.dart';

Future main(List<String> args) async {
  final package = Directory.current;
  final parser = new ArgParser();

  parser.addFlag('help', abbr: 'h', help: 'Show usage', negatable: false);
  parser.addFlag('badge',
      help: 'Generate coverage badge SVG image in your package root',
      defaultsTo: true);
  parser.addFlag('test', abbr:  't', help: 'runs flutter test before generating badge ');

  final options = parser.parse(args);

  if (options.wasParsed('test')) {
    await runTestsWithCoverage(Directory.current.path).then((_) {
     print('Coverage report saved to "coverage/lcov.info".');
    });
  }

  if (options.wasParsed('help')) {
    print(parser.usage);
    return;
  }

  final lineCoverage = calculateLineCoverage(File('coverage/lcov.info'));
  generateBadge(package, lineCoverage);
  return;
}
