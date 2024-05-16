import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TumorTreatmentPage extends StatefulWidget {
  final String? category;
  const TumorTreatmentPage({Key? key, this.category}) : super(key: key);

  @override
  State<TumorTreatmentPage> createState() => _TumorTreatmentPageState();
}

class _TumorTreatmentPageState extends State<TumorTreatmentPage> {
  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> cpTreatments = [
      {
        'type': 'SPASTIC CP',
        'treatments': [
          'Physical Therapy (PT): Focuses on stretching tight muscles, improving range of motion, and promoting functional mobility through exercises and activities.',
          'Occupational Therapy (OT): Addresses activities of daily living, fine motor skills, and adaptive techniques to enhance independence in self-care tasks.',
          'Orthotic Devices: Braces, splints, or orthopedic equipment may be prescribed to support posture, improve alignment, and manage spasticity.',
          'Medications: Muscle relaxants or medications targeting spasticity (e.g., baclofen, diazepam) may be prescribed to reduce muscle stiffness and spasticity.'
        ]
      },
      {
        'type': 'DYSKINETIC CP',
        'treatments': [
          'Physical Therapy (PT): Focuses on improving coordination, balance, and postural control while addressing involuntary movements.',
          'Speech Therapy (ST): Targets communication difficulties, including speech articulation, language development, and swallowing difficulties.',
          'Medications: Anticholinergic medications (e.g., trihexyphenidyl) may be prescribed to reduce dystonia and involuntary movements.',
          'Botulinum Toxin Injections: Injections of botulinum toxin (Botox) may be used to temporarily reduce muscle spasms and dystonic movements in specific muscles.'
        ]
      },
      {
        'type': 'ATAXTIC CP',
        'treatments': [
          'Physical Therapy (PT): Focuses on improving balance, coordination, and motor planning to enhance functional mobility and stability.',
          'Occupational Therapy (OT): Targets fine motor skills, hand-eye coordination, and activities of daily living to promote independence.',
          'Assistive Devices: Mobility aids, adaptive equipment, or orthotic devices may be recommended to support coordination and balance.',
          'Speech Therapy (ST): Addresses speech and communication difficulties related to ataxic movements.'
        ]
      },
      {
        'type': 'MIXED CP',
        'treatments': [
          'Comprehensive Therapy: Individuals with mixed types of CP may require a combination of therapies tailored to their specific needs, which may include elements of physical therapy, occupational therapy, speech therapy, and other interventions as appropriate.',
          'Multidisciplinary Approach: A team of healthcare professionals, including physicians, therapists, educators, and specialists, collaborate to develop an integrated treatment plan addressing the diverse challenges associated with mixed CP.'
        ]
      },
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Brain Tumor Treatment",
          style: TextStyle(color: AppTheme.colors.blue),
        ),
        backgroundColor: AppTheme.colors.white,
        iconTheme: IconThemeData(
          color: AppTheme.colors.blue, //change your color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20),
            // Mapping treatments based on category
            if (widget.category != null)
              ...cpTreatments.where((treatment) =>
              treatment['type'].toUpperCase() == widget.category!.toUpperCase()).map<Widget>((treatment) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Treatments for ${treatment['type']} CP:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Mapping individual treatments
                    ...(treatment['treatments'] as List<String>).map((t) {
                      return Text(
                        "• $t",
                        style: TextStyle(fontSize: 16),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
          ],
        ),
      ),
    );

  }
}
