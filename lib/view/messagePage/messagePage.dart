import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../model/messagePage/messageFetching.dart';
import '../../res/app_colors/app_clolrs.dart';
import '../../view_model/chatPage/groupInfoPage.dart';

class MessageScreen extends StatefulWidget {
  final String groupId;
  const MessageScreen({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController messageController = TextEditingController();

  final _scrollController = ScrollController();
  var myId = FirebaseAuth.instance.currentUser!.uid;

  late Stream<QuerySnapshot<Map<String, dynamic>>>? groupMessages;

  String groupName = '';
  // String groupIcon = '';

  @override
  void initState() {
    groupMessages = FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupId)
        .collection('messages')
        .orderBy('date', descending: false)
        .snapshots(includeMetadataChanges: true);

    fetchGroupDetails(); // Fetch group details when the screen initializes
    super.initState();
  }

  // Fetch group details using the GroupId
  void fetchGroupDetails() async {
    DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupId)
        .get();

    if (groupSnapshot.exists) {
      setState(() {
        groupName = groupSnapshot["groupName"] ?? '';
        //  groupIcon = groupSnapshot["groupIcon"] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolor.primaryColor,
          centerTitle: true,
          title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupDetails(
                            groupId: widget.groupId,
                          )));
            },
            child: Text(
              groupName,
              style: const TextStyle(
                  color: Appcolor.textcolor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          iconTheme: const IconThemeData(color: Appcolor.textcolor),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: groupMessages,
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Appcolor.buttonclolor,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final messages = snapshot.data?.docs ?? [];

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  });
                  return GroupedListView<
                      QueryDocumentSnapshot<Map<String, dynamic>>, DateTime>(
                    elements: messages,
                    groupBy: (message) {
                      final messageTime =
                          (message['date'] as Timestamp).toDate();
                      final messageDate = DateTime(
                          messageTime.year, messageTime.month, messageTime.day);
                      return messageDate;
                    },
                    order: GroupedListOrder.ASC,
                    controller: _scrollController,
                    groupSeparatorBuilder: (DateTime date) {
                      final now = DateTime.now();
                      if (date.year == now.year &&
                          date.month == now.month &&
                          date.day == now.day) {
                        return const Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 170, right: 170),
                          child: Card(
                              color: Appcolor.primaryColor,
                              child: Center(
                                  child: AutoSizeText(
                                'Today',
                                maxLines: 1,
                                style: TextStyle(
                                    color: Appcolor.textcolor,
                                    fontWeight: FontWeight.bold),
                              ))),
                        );
                      } else if (date.year == now.year &&
                          date.month == now.month &&
                          date.day == now.day - 1) {
                        return const Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 160, right: 160),
                          child: Card(
                              color: Appcolor.primaryColor,
                              child: Center(
                                  child: AutoSizeText(
                                'Yesterday',
                                maxLines: 1,
                                style: TextStyle(
                                    color: Appcolor.textcolor,
                                    fontWeight: FontWeight.bold),
                              ))),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 140, right: 140),
                          child: Card(
                              color: Appcolor.primaryColor,
                              child: Center(
                                  child: AutoSizeText(
                                DateFormat('MMMM dd, yyyy').format(date),
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Appcolor.textcolor,
                                    fontWeight: FontWeight.bold),
                              ))),
                        );
                      }
                    },
                    itemBuilder: (context, element) {
                      final messageData = element.data();
                      final messageTime =
                          (messageData['date'] as Timestamp).toDate();
                      final formattedTime =
                          DateFormat('H:mm').format(messageTime);
                      return Padding(
                        padding: messageData['senderId'] == myId
                            ? const EdgeInsets.only(left: 50, right: 10)
                            : const EdgeInsets.only(left: 10, right: 50),
                        child: Align(
                            alignment: messageData['senderId'] == myId
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messageData['message'],
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(
                                            color: Appcolor.buttonclolor,
                                            fontSize: 12),
                                      ),
                                    ]),
                              ),
                            )),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              width: 3, color: Appcolor.buttonclolor)),
                      child: TextFormField(
                        controller: messageController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        maxLines: 3,
                        minLines: 1,
                        cursorColor: Appcolor.buttonclolor,
                        cursorWidth: 3,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your message...',
                          contentPadding: EdgeInsets.only(
                              left: 10, top: 4, bottom: 4, right: 10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        MessageHandling(widget.groupId)
                            .sendMessage(messageController.text);
                        messageController.clear();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 40,
                      color: Appcolor.buttonclolor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
