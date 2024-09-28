import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LegalSearchScreen extends StatefulWidget {
  const LegalSearchScreen({Key? key}) : super(key: key);

  @override
  _LegalSearchScreenState createState() => _LegalSearchScreenState();
}

class _LegalSearchScreenState extends State<LegalSearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  List<ChatMessage> _chatMessages = [];
  String _selectedTaskType = 'Legal Advisory';
  String _selectedCourt = 'All';
  List<html.File> _uploadedFiles = [];
  bool _loading = false;
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = prefs.getString('conversations') ?? '[]';
    final List<dynamic> conversationsData = json.decode(conversationsJson);
    setState(() {
      _conversations = conversationsData.map((data) => Conversation.fromJson(data)).toList();
    });
  }

  Future<void> _saveConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = json.encode(_conversations.map((conv) => conv.toJson()).toList());
    await prefs.setString('conversations', conversationsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar (History)
          Container(
            width: 250,
            color: Colors.brown[700],
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.history, color: Colors.white),
                      SizedBox(width: 8),
                      Text('History', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Spacer(),
                      Icon(Icons.search, color: Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _conversations.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          leading: const Icon(Icons.add, color: Colors.white),
                          title: const Text('New Conversation', style: TextStyle(color: Colors.white)),
                          onTap: _startNewConversation,
                        );
                      }
                      final conversation = _conversations[index - 1];
                      return ListTile(
                        title: Text(conversation.title, style: const TextStyle(color: Colors.white)),
                        onTap: () => _loadConversation(conversation),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Container(
              color: const Color(0xFFF5F1EB),
              child: Column(
                children: [
                  // Top bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('LawNavigator', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Text('Templates'),
                            SizedBox(width: 16),
                            Text('🌐 Eng'),
                            SizedBox(width: 16),
                            Icon(Icons.file_download),
                            SizedBox(width: 16),
                            Icon(Icons.edit),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Chat area
                  Expanded(
                    child: ListView.builder(
                      itemCount: _chatMessages.length,
                      itemBuilder: (context, index) {
                        return _chatMessages[index];
                      },
                    ),
                  ),

                  // Input area
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _queryController,
                            decoration: InputDecoration(
                              hintText: 'Enter your query',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.brown,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_upward, color: Colors.white),
                            onPressed: _handleSubmit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right sidebar (Filters)
          Container(
            width: 250,
            color: Colors.grey[600],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filters', style: TextStyle(color: Colors.white, fontSize: 18)),
                    Icon(Icons.filter_list, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Select task type:', style: TextStyle(color: Colors.white)),
                CheckboxListTile(
                  title: const Text('Legal Report Generation', style: TextStyle(color: Colors.white)),
                  value: _selectedTaskType == 'Legal Report Generation',
                  onChanged: (value) => _updateTaskType('Legal Report Generation'),
                ),
                CheckboxListTile(
                  title: const Text('Case Outcome Prediction', style: TextStyle(color: Colors.white)),
                  value: _selectedTaskType == 'Case Outcome Prediction',
                  onChanged: (value) => _updateTaskType('Case Outcome Prediction'),
                ),
                CheckboxListTile(
                  title: const Text('Legal Advisory', style: TextStyle(color: Colors.white)),
                  value: _selectedTaskType == 'Legal Advisory',
                  onChanged: (value) => _updateTaskType('Legal Advisory'),
                ),
                const SizedBox(height: 16),
                const Text('Select Court:', style: TextStyle(color: Colors.white)),
                DropdownButton<String>(
                  value: _selectedCourt,
                  dropdownColor: Colors.grey[700],
                  style: const TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCourt = newValue!;
                    });
                  },
                  items: <String>['All', 'Supreme Court', 'High Court', 'District Court']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Documents'),
                  onPressed: _uploadDocuments,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ..._uploadedFiles.map((file) => _buildDocumentItem(file.name)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String docName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.description, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(docName, style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis)),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 16),
            onPressed: () => _removeDocument(docName),
          ),
        ],
      ),
    );
  }

  void _updateTaskType(String taskType) {
    setState(() {
      _selectedTaskType = taskType;
    });
  }

  void _uploadDocuments() async {
    final uploadInput = html.FileUploadInputElement()..accept = '.pdf';
    uploadInput.click();

    await uploadInput.onChange.first;
    if (uploadInput.files!.isNotEmpty) {
      setState(() {
        _uploadedFiles.addAll(uploadInput.files!);
      });
    }
  }

  void _removeDocument(String docName) {
    setState(() {
      _uploadedFiles.removeWhere((file) => file.name == docName);
    });
  }

  void _handleSubmit() async {
    if (_queryController.text.isNotEmpty) {
      final query = _queryController.text;
      setState(() {
        _chatMessages.add(UserMessage(query));
        _loading = true;
      });
      _queryController.clear();

      try {
        final response = await _submitQuery(query);
        setState(() {
          _chatMessages.add(AssistantMessage(response));
          _loading = false;
        });

        // Update conversation history
        if (_conversations.isEmpty || _conversations.last.messages.length >= 5) {
          _conversations.add(Conversation(title: "Conversation ${_conversations.length + 1}", messages: []));
        }
        _conversations.last.messages.add(ChatMessageData(isUser: true, text: query));
        _conversations.last.messages.add(ChatMessageData(isUser: false, text: response));
        _saveConversations();
      } catch (e) {
        setState(() {
          _chatMessages.add(AssistantMessage("Error: $e"));
          _loading = false;
        });
      }
    }
  }

  Future<String> _submitQuery(String query) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://navilaw-ai.onrender.com/legal-assistance/'),
    );
    request.fields['query'] = query;
    request.fields['option'] = _selectedTaskType;

    for (var file in _uploadedFiles) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      final bytes = reader.result as Uint8List;
      request.files.add(http.MultipartFile.fromBytes(
        'files',
        bytes,
        filename: file.name,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(responseBody);
      return decodedResponse['result'] ??
          decodedResponse['report'] ??
          decodedResponse['prediction'] ??
          'Response received';
    } else {
      throw Exception(json.decode(responseBody)['detail'] ?? 'An error occurred');
    }
  }

  void _startNewConversation() {
    setState(() {
      _chatMessages.clear();
      _uploadedFiles.clear();
      _selectedTaskType = 'Legal Advisory';
      _selectedCourt = 'All';
    });
  }

  void _loadConversation(Conversation conversation) {
    setState(() {
      _chatMessages = conversation.messages
          .map((msg) => msg.isUser ? UserMessage(msg.text) : AssistantMessage(msg.text))
          .toList();
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage(this.text, {Key? key, required this.isUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: Colors.brown,
              child: Text('AI', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.white : Colors.brown[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(text, style: TextStyle(color: isUser ? Colors.black : Colors.white)),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('U', style: TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }
}

class UserMessage extends ChatMessage {
  UserMessage(String text) : super(text, isUser: true);
}

class AssistantMessage extends ChatMessage {
  AssistantMessage(String text) : super(text, isUser: false);
}

class Conversation {
  String title;
  List<ChatMessageData> messages;

  Conversation({required this.title, required this.messages});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      title: json['title'],
      messages: (json['messages'] as List).map((msg) => ChatMessageData.fromJson(msg)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
    };
  }
}

class ChatMessageData {
  bool isUser;
  String text;

  ChatMessageData({required this.isUser, required this.text});

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    return ChatMessageData(
      isUser: json['isUser'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isUser': isUser,
      'text': text,
    };
  }
}