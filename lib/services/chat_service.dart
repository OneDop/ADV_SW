import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:advsw/models/message_model.dart';

class ChatService {
  StompClient? _stompClient;
  static const String _tokenKey = 'auth_token';
  static const String _serverHost = '10.236.55.75';
  static const int _serverPort = 8080;

  final _messageController = StreamController<MessageResponse>.broadcast();
  Stream<MessageResponse> get messages => _messageController.stream;

  final Set<int> _subscribedProjects = {};

  void connect(int projectId) async {
    if (_stompClient != null && _stompClient!.isActive) {
      _subscribeToProject(projectId);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey) ?? '';

    final wsUrl = 'ws://$_serverHost:$_serverPort/ws?token=$token';

    _stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (frame) {
          _subscribeToProject(projectId);
        },
        stompConnectHeaders: {},
        webSocketConnectHeaders: {},
        onWebSocketError: (dynamic error) => print('WS Error: $error'),
        onDisconnect: (frame) => print('Disconnected from STOMP'),
      ),
    );

    _stompClient?.activate();
  }

  void _subscribeToProject(int projectId) {
    if (_subscribedProjects.contains(projectId)) return;

    _stompClient?.subscribe(
      destination: '/topic/project/$projectId',
      callback: (frame) {
        if (frame.body != null) {
          try {
            final Map<String, dynamic> data = json.decode(frame.body!);
            _messageController.add(MessageResponse.fromJson(data));
          } catch (e) {
            print('Error parsing message: $e');
          }
        }
      },
    );
    _subscribedProjects.add(projectId);
  }

  void sendMessage(int projectId, SendMessageRequest request) {
    if (_stompClient != null && _stompClient!.connected) {
      _stompClient?.send(
        destination: '/app/chat/$projectId',
        body: json.encode(request.toJson()),
      );
    }
  }

  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
    _subscribedProjects.clear();
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
