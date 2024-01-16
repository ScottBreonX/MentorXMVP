import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mentorx_mvp/components/rounded_button.dart';
import 'package:mentorx_mvp/constants.dart';
import 'package:mentorx_mvp/models/user.dart';

final apiKey = '';
final apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';

// Future<String> getChatResponse(String input) async {
//   print(input);
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       'Authorization': 'Bearer $apiKey',
//     },
//     body: {
//       'prompt': input,
//     },
//   );
//
//   if (response.statusCode == 200) {
//     return response.body;
//   } else {
//     throw Exception('Failed to get a response from the API');
//   }
// }

class ChatGPTScreen extends StatefulWidget {
  final myUser loggedInUser;
  static const String id = 'chat_gpt_screen';
  const ChatGPTScreen({
    this.loggedInUser,
  });

  @override
  _ChatGPTScreenState createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  final _formKey1 = GlobalKey<FormState>();
  String textInput;

  Material _textFormFieldInput() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        key: _formKey1,
        textCapitalization: TextCapitalization.sentences,
        initialValue: textInput,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        minLines: 4,
        maxLines: null,
        textAlign: TextAlign.start,
        cursorColor: Theme.of(context).indicatorColor,
        onChanged: (value) => textInput = value,
        style: Theme.of(context).textTheme.labelLarge,
        autocorrect: true,
        decoration: kTextFieldDecoration.copyWith(
          fillColor: Theme.of(context).cardColor,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kMentorXPSecondary, width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).cardColor, width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  String responseTxt;

  completionFun(String textInputGPT) async {
    print(apiKey);

    setState(() => responseTxt = 'Loading...');

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode(
        {
          "model": "gpt-3.5-turbo-instruct",
          "prompt": textInputGPT,
          "max_tokens": 250,
          "temperature": 0,
          "top_p": 1,
          "n": 1,
          "stream": false,
          "logprobs": null,
        },
      ),
    );

    final responseText = jsonDecode(response.body) as Map<String, dynamic>;

    setState(() {
      responseTxt = responseText['choices'][0]['text'].toString().trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: kMentorXPPrimary,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 35.0, bottom: 10),
            child: Image.asset(
              'assets/images/MentorXP.png',
              fit: BoxFit.contain,
              height: 35,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      // height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          '${responseTxt ?? "enter a prompt"}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  _textFormFieldInput(),
                  RoundedButton(
                    title: 'Submit to GPT',
                    buttonColor: kMentorXPSecondary,
                    fontColor: Colors.white,
                    textAlignment: MainAxisAlignment.center,
                    onPressed: () {
                      // print(textInput);
                      completionFun(textInput);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
