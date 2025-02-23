import 'package:dokusend/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum RemoteJobStatus { pending, processing, completed, failed, unknown }

class JobService {
  JobService();

  Future<RemoteJobData> getJobData(String jobId) async {
    final response = await http.get(
      Uri.parse('${Config.jobApiUrl.value}/api/v1/jobs/$jobId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return RemoteJobData.fromJson(data['job']);
    } else {
      throw Exception('Failed to load job');
    }
  }
}

class RemoteJobData {
  final String id;
  final String jobType;
  final RemoteJobStatus status;
  final String payload;
  final String result;
  final String outMessage;
  final String createdAt;

  RemoteJobData({
    required this.id,
    required this.jobType,
    required this.status,
    required this.payload,
    required this.result,
    required this.outMessage,
    required this.createdAt,
  });

  factory RemoteJobData.fromJson(Map<String, dynamic> json) {
    return RemoteJobData(
      id: json['id'],
      jobType: json['jobType'],
      status: RemoteJobStatus.values.firstWhere(
        (e) => e.name == json['status'].toString().toLowerCase(),
        orElse: () => RemoteJobStatus.unknown,
      ),
      payload: json['payload'],
      result: json['result'],
      outMessage: json['outMessage'],
      createdAt: json['createdAt'],
    );
  }
}
