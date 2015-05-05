library dart_codecov.bin.src.report;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';


Future<bool> sendToCodecov(File coverage, String type, String commit, String branch, String codecovToken,
                           String travisJobId, bool verbose) async {
  Logger log = new Logger('dart_codecov');
  Uri url = Uri.parse('https://codecov.io/upload/v1');
  url = url.replace(queryParameters: {
    'token': codecovToken,
    'commit': commit,
    'branch': branch,
    'travis_job_id': travisJobId,
  });
  log.info('Sending coverage to codecov.io...');
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.postUrl(url);
  request.headers.add('Content-Type', 'text/$type');
  await request.addStream(coverage.openRead());
  HttpClientResponse response = await request.close();
  String responseData = await response.transform(UTF8.decoder).join('');
  if (response.statusCode >= 200 && response.statusCode < 300) {
    log.info(responseData);
    return true;
  } else {
    log.info(responseData);
    return false;
  }
}