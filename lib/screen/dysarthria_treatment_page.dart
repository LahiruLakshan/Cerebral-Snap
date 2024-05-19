import 'package:flutter/material.dart';

import '../theme/app_theme.dart';


class DysarthriaTreatmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeechExercisesScreen(),
    );
  }
}

class SpeechExercisesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> exercises = [
    {
      'title': 'Sounds in Isolation',
      'content': [
        'Puh',
        'Paw',
        'Pee',
        'Poo',
        'Buh',
        'Bee',
        'Boo',
        'Bow',
        'Muh',
        'Me',
        'Mow',
        'My',
      ],
    },
    {
      'title': 'Words',
      'content': [
        'Page',
        'Peace',
        'Peer',
        'Puck',
        'Peek',
        'Bake',
        'Beak',
        'Bed',
        'Bash',
        'Beef',
        'Meat',
        'Maze',
        'Move',
        'More',
        'Met',
      ],
    },
    {
      'title': 'Longer Words',
      'content': [
        'Parking',
        'Painful',
        'Polite',
        'Peaceful',
        'Package',
        'Birthday',
        'Bottle',
        'Baggage',
        'Breathy',
        'Boyish',
        'Marvel',
        'Master',
        'Molar',
        'Minimal',
        'Multitude',
      ],
    },
    {
      'title': 'Minimal Pairs',
      'content': [
        'Ten/Hen',
        'Name/Lame',
        'Lane/Lake',
        'Cut/Cup',
        'Knit/Sit',
        'Pass/Pad',
        'Zen/Pen',
        'Gain/Game',
        'Bank/Sank',
        'Set/Get',
      ],
    },
    {
      'title': 'Phrases',
      'content': [
        'I say ____',
        '____ is the word',
        'The word is ____',
        'Two bananas',
        'Credit Card',
        'Rest Area',
        'Good Luck',
        'Local bank',
        'The end',
        'Left turn only',
        'How are you?',
      ],
    },
    {
      'title': 'Sentences for Dysarthria Treatment',
      'content': [
        'Good to see you!',
        'I hope to arrive early.',
        'Take one pill with water.',
        'The best bookseller for board books is in Boston.',
        'Pass the pepper to my plate.',
        'Must we move to Montana on Monday?',
      ],
    },
    {
      'title': 'Conversations for Dysarthria Treatment',
      'content': [
        'What is your favorite season and why?',
        'What would you do if you inherited a million dollars?',
        'What are your favorite sporting events and why?',
        'What would you do if you were 25 again?',
        'Coffee or tea? Why?',
      ],
    },
    {
      'title': 'Strategies for Clear Speech',
      'content': [
        'Think SLOW. The slower you speak, the easier it is for others to understand you. This also allows time for your tongue, lips, and other articulators to get where they need to for certain speech sounds.',
        'Open your mouth and OVER pronounce your words.',
        'Make sure you are face to face with your listener and use gestures and eye contact to add to your message.',
        'Reduce or eliminate background noise. Turn the TV or radio volume down when you are about to speak to someone.',
        'Provide the listener with context. This helps prepare the listener to expect certain words.',
        'Do not be afraid to repeat yourself if someone does not understand you the first time.',
      ],
    },
    {
      'title': 'Practice Exercises',
      'content': [
        'PRACTICE saying Days of the Week',
        'PRACTICE counting 1-20',
        'PRACTICE saying favorite sports teams',
        'PRACTICE saying “My name is _______”',
        'PRACTICE saying Months of the Year',
        'PRACTICE saying the alphabet “A, B, C, D, E, F....”',
        'PRACTICE saying “My birthday is _____”',
        'PRACTICE saying different holidays (Thanksgiving, Christmas)',
        'PRACTICE saying names of family members',
        'PRACTICE saying individual sounds with extra strength: “P”, “B”, “K”, “G”',
        'PRACTICE saying common sentences and phrases you say frequently',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech Exercises", style: TextStyle(color: AppTheme.colors.blue),),
        backgroundColor: AppTheme.colors.white,
        iconTheme: IconThemeData(
          color: AppTheme.colors.blue, //change your color here
        ),
      ),

      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final section = exercises[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ExpansionTile(
              title: Text(section['title']),
              children: (section['content'] as List<String>).map((item) => ListTile(title: Text(item))).toList(),
            ),
          );
        },
      ),
    );
  }
}
