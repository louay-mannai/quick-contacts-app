import 'package:flutter/material.dart';
import '../models/contact.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;
  const ChatPage({Key? key, required this.contact}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageCtrl = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageCtrl.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'text': _messageCtrl.text.trim(),
        'isMe': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageCtrl.clear();

    // Simulated response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          messages.add({
            'text': 'Merci pour votre message ! 👋',
            'isMe': false,
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contact.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'En ligne',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.call, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Fonction d'appel bientôt 📞")),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Messages List
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chat_outlined, size: 48, color: Colors.white54),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucun message pour le moment',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Commencez la conversation',
                              style: TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg['isMe'] as bool;

                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFF1E3C72)
                                    : Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 18),
                                ),
                                border: Border.all(
                                  color: isMe
                                      ? Colors.white24
                                      : Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    msg['text'],
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.white.withOpacity(0.87),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTime(msg['timestamp']),
                                    style: TextStyle(
                                      color: isMe ? Colors.white60 : Colors.white54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Message Input
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Emoji button
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined, color: Color(0xFF1E3C72)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ajout d\'émojis bientôt 😊')),
                        );
                      },
                    ),

                    // Text input
                    Expanded(
                      child: TextField(
                        controller: _messageCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Écrivez un message...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(color: Color(0xFF1E3C72)),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),

                    // Image button
                    IconButton(
                      icon: const Icon(Icons.image_outlined, color: Color(0xFF1E3C72)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Envoi d\'images bientôt 🖼️')),
                        );
                      },
                    ),

                    // Send button
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
