// ignore_for_file: prefer_const_constructors

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:trial_app/api_services.dart';
import 'package:trial_app/chat_model.dart';
import 'package:trial_app/colors.dart';


class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  SpeechToText speechToText = SpeechToText();

  var text = "Hold the button and start speaking";
  var isListening = false;

  final List<ChatMessage> messages = [];

  var scrollController = ScrollController();

  scrollMethod(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: textcolor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async{
            if(!isListening){
              var available = await speechToText.initialize();

              if(available){
                setState(() {
                  isListening = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                      });
                    },
                    );
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            speechToText.stop();

            messages.add(ChatMessage(text: text, type: ChatMessageType.user));
            var msg = await ApiServices.sendMessage(text);

            setState(() {
              messages.add(ChatMessage(text: msg, type: ChatMessageType.bot));
            });
            
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(isListening ? Icons.mic : Icons.mic_none, 
            color: textcolor)
            ),
        ),
      ),
      appBar: AppBar(
        leading: Icon(Icons.sort_rounded, color: textcolor,),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text("Chatbot for anything", style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textcolor ),
          ),
      ),
      body: Container(
          
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),

          child: Column(
            children: [
              Text(text, 
              style: const TextStyle(
                fontSize: 17, 
                color: darktext,
                fontWeight: FontWeight.w600,
              )),
              SizedBox(
                height: 18,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),

                  ),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index){

                      var chat = messages[index];
                      if (chat.type ==  ChatMessageType.bot) {
                        return chatBubblebot(
                        chattext: chat.text,
                        type: chat.type
                      );

                      } else {
                        return chatBubbleperson(
                        chattext: chat.text,
                        type: chat.type
                      );
                      }

                      
                    }
                  ),


                  )
                ),
              SizedBox(
                height: 12,
              )

            ],
          ),

      
        ),

    );
  }
  

  Widget chatBubbleperson({required chattext, required ChatMessageType? type}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(Icons.person_rounded, color: textcolor,),
        ),
        SizedBox(
          height: 12,
          width: 8,
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12))
            ),
            child: Text(
              "$chattext",
              style: TextStyle(
                color: darktext,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              )
            ),
          ),
        ),
      ],
    );
  }


  Widget chatBubblebot({required chattext, required ChatMessageType? type}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12))
            ),
            child: Text(
              "$chattext",
              style: TextStyle(
                color: darktext,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              )
            ),
          ),
        ),
        SizedBox(
          height: 12,
          width: 8,
        ),

        CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(Icons.cruelty_free_outlined, color: textcolor,),
        ),
        
      ],
    );
  }


}
