library dart_codecov.bin.src.executable;

import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';

import 'service.dart' as service;


Logger log;
bool verbose = false;


main(List<String> args) async {
  // Setup logger
  log = new Logger('dart_codecov');
  log.onRecord.listen((LogRecord record) {
    if (verbose || record.level >= Level.SEVERE) {
      print(record.message);
    }
  });
  log.shout('Running dart_codecov...');

  // Setup environment
  Env env = parseArgs(args);
  log.info('Environment:');
  log.info('\t         type = ${env.type}');
  log.info('\t       commit = ${env.commit}');
  log.info('\t       branch = ${env.branch}');
  log.info('\t        token = [SECURE]');
  log.info('\ttravis-job-id = ${env.travisJobId}');
  log.info('\t      verbose = ${env.verbose}');

  if (await service.sendToCodecov(env.coverage, env.type, env.commit, env.branch,
                                  env.codecovToken, env.travisJobId, env.verbose)) {
    log.shout('Coverage sent to codecov.io successfully.');
    exit(0);
  } else {
    log.severe('Coverage failed to send to codecov.io.');
    exit(1);
  }
}


class Env {
  final File coverage;
  final String type;
  final String commit;
  final String branch;
  final String codecovToken;
  final String travisJobId;
  final bool verbose;
  Env(this.coverage, this.type, this.commit, this.branch, this.codecovToken, this.travisJobId, this.verbose);
}


Env parseArgs(List<String> args) {
  ArgParser parser = new ArgParser()
    ..addOption('commit', abbr: 'c')
    ..addOption('branch', abbr: 'b')
    ..addOption('token', abbr: 't')
    ..addOption('travis-job-id', abbr: 'j')
    ..addFlag('verbose', abbr: 'v');
  ArgResults res = parser.parse(args);
  verbose = res['verbose'];

  if (res.rest.length < 1) {
    log.severe('Include a lcov, gcov, or json coverage file to send to codecov.');
    exit(1);
  }
  if (res.rest.length > 1) {
    log.severe('Only include a single coverage file to send to codecov.');
    exit(1);
  }
  if (!FileSystemEntity.isFileSync(res.rest[0])) {
    log.severe('Coverage file does not exist: ${res.rest[0]}');
    exit(1);
  }

  File coverage = new File(res.rest[0]);
  if (!coverage.path.endsWith('.lcov') && !coverage.path.endsWith('.gcov') && !coverage.path.endsWith('.json')) {
    log.severe('Coverage file must be in lcov, gcov, or json format.');
    exit(1);
  }
  String type = coverage.path.substring(coverage.path.length - 4);

  String getArgFromCliOrEnv(String cliKey, String envKey) {
    if (res[cliKey] != null) return res[cliKey];
    if (Platform.environment.containsKey(envKey)) return Platform.environment[envKey];
    log.severe('Missing info: --$cliKey not supplied and $envKey is not set.');
    exit(1);
  }

  var commit = getArgFromCliOrEnv('commit', 'TRAVIS_COMMIT');
  var branch = getArgFromCliOrEnv('branch', 'TRAVIS_BRANCH');
  var codecovToken = getArgFromCliOrEnv('token', 'CODECOV_TOKEN');
  var travisJobId = getArgFromCliOrEnv('travis-job-id', 'TRAVIS_JOB_ID');

  return new Env(coverage, type, commit, branch, codecovToken, travisJobId, res['verbose']);
}