import 'package:dio/dio.dart';
import 'package:hr_management_app/data/sockets/socket_service.dart';

class SocketsWebServices {
  late Dio dio;
  SocketsWebServices() {
    dio = Dio();
  }
  void makeRequest(
    String clientId, {
    required String receiverRole,
    String? receiverName,
    required String content,
    required String dateOfRequest,
    required String requestType,
  }) async {
    if (clientId == null) {
      print('Client ID not found in storage.');
      return;
    }

    // Example API request
    String endpoint = 'http://localhost:3000/requests';
    Map<String, dynamic> data = {
      "employeeid": clientId,
      "receiver_role": receiverRole,
      "receiver_name": receiverName,
      "content": content,
      "dateofrequest": dateOfRequest,
      "requestType": requestType
    };

    try {
      Response response = await dio.post(endpoint, data: data);
      print('Response: ${response.data}');
    } catch (e) {
      print('Error making request: $e');
    }
  }

  void connectToSocket(String? clientId, String role) async {
    if (clientId == null) {
      print('Client ID not found in storage.');
      return;
    }

    // Connect to socket and emit clientId
    SocketService.connectAndListen(clientId, role);
  }
}
