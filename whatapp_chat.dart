import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<MessageModel> messageList = [];
  TextEditingController messageController = TextEditingController();

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      messageList.add(
          MessageModel(message: messageController.text, time: DateTime.now()));
      messageController.clear();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Enter Message...!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Henil Mepani",
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                messageList.clear();
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(Icons.delete),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                itemCount: messageList.length,
                itemBuilder: (context, index) => MessageBubble(
                    message: messageList[index].message ?? "",
                    time: messageList[index].time ?? DateTime.now()),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
              )),
              const SizedBox(height: 15),
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Enter Message",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, // Increase this to control height
                    horizontal: 20,
                  ),
                  // fillColor: const Color(0xFFDCF8C6).withOpacity(.6),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.teal,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageModel {
  String? message;
  DateTime? time;

  MessageModel({this.message, this.time});
}

class MessageBubble extends StatelessWidget {
  final String message;
  final DateTime time;

  const MessageBubble({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: const Color(0xFFDCF8C6).withOpacity(.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            // padding: const EdgeInsets.only(left: 10,top: 8,right: 5,bottom:8),
            child: Stack(
              children: [
                RichText(
                  text: TextSpan(
                    text: message,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: const [
                      TextSpan(
                          text: '           .',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.transparent)),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      DateFormat.jm().format(time),
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
