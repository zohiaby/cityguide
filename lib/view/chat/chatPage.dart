import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/authentication/userAuthentication.dart';
import '../../view_model/chatPage/groupsPage.dart';
import '../../view_model/chatPage/searchPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController groupname = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolor.primaryColor,
        centerTitle: true,
        title: const AutoSizeText(
          maxLines: 1,
          'CityGuide',
          style: TextStyle(
              color: Appcolor.textcolor,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Appcolor.buttonclolor,
          unselectedLabelColor: Appcolor.textcolor,
          indicatorColor: Appcolor.buttonclolor,
          tabs: const <Widget>[
            Tab(
                icon: Icon(
                  Icons.group,
                ),
                text: "All Groups"),
            Tab(
              icon: Icon(Icons.search),
              text: "search Groups",
            ),
          ],
        ),
      ),
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Appcolor.buttonclolor,
        child: IconButton(
          onPressed: () {
            DialoPopup();
          },
          color: Colors.white,
          icon: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Appcolor.primaryColor,
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          LoadGroups(),
          SearchPage(),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> DialoPopup() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                "Enter Group Name",
                style: TextStyle(
                  color: Appcolor.buttonclolor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: TextField(
              maxLength: 12,
              controller: groupname,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Appcolor.buttonclolor),
                ),
              ),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.textcolor),
              cursorColor: Appcolor.buttonclolor,
              inputFormatters: [
                _Utf8LengthLimitingTextInputFormatter(12),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    // ignore: unrelated_type_equality_checks
                    if (groupname != '') {
                      FireBaseFuncationalities().uploadGroupData(
                        groupname.text,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Appcolor.buttonclolor),
                  ))
            ],
          );
        });
  }
}

class _Utf8LengthLimitingTextInputFormatter extends TextInputFormatter {
  _Utf8LengthLimitingTextInputFormatter(this.maxLength)
      // ignore: unnecessary_null_comparison
      : assert(maxLength == null || maxLength == -1 || maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // ignore: unnecessary_null_comparison
    if (maxLength != null &&
        maxLength > 0 &&
        bytesLength(newValue.text) > maxLength) {
      // If already at the maximum and tried to enter even more, keep the old value.
      if (bytesLength(oldValue.text) == maxLength) {
        return oldValue;
      }
      return truncate(newValue, maxLength);
    }
    return newValue;
  }

  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    var newValue = '';
    if (bytesLength(value.text) > maxLength) {
      var length = 0;

      value.text.characters.takeWhile((char) {
        var nbBytes = bytesLength(char);
        if (length + nbBytes <= maxLength) {
          newValue += char;
          length += nbBytes;
          return true;
        }
        return false;
      });
    }
    return TextEditingValue(
      text: newValue,
      selection: value.selection.copyWith(
        baseOffset: min(value.selection.start, newValue.length),
        extentOffset: min(value.selection.end, newValue.length),
      ),
      composing: TextRange.empty,
    );
  }

  static int bytesLength(String value) {
    return utf8.encode(value).length;
  }
}
