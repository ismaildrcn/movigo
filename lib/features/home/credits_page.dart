import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movigo/app/topbar.dart';
import 'package:movigo/data/model/movie/credits_model.dart';
import 'package:movigo/data/model/movie/person_model.dart';
import 'package:movigo/data/services/constant/api_constants.dart';
import 'package:movigo/data/services/person_service.dart';
import 'package:movigo/features/home/utils/image_utils.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreditsPage extends StatefulWidget {
  final Credits credits;
  const CreditsPage({super.key, required this.credits});

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  int stackIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: "Credits", callback: () => Navigator.pop(context)),
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.all(18),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ToggleSwitch(
                        initialLabelIndex: stackIndex,
                        totalSwitches: 2,
                        minWidth: 100.0,
                        activeBgColor: [Theme.of(context).colorScheme.primary],
                        inactiveBgColor: Colors.grey[500],
                        labels: ['Cast', 'Crew'],
                        onToggle: (index) {
                          setState(() {
                            stackIndex = index!;
                          });
                        },
                      ),
                      SizedBox(height: 18),
                      Expanded(
                        child: IndexedStack(
                          index: stackIndex,
                          children: [
                            widget.credits.cast.isEmpty
                                ? const Center(child: Text("No cast available"))
                                : _createCreditsView(widget.credits.cast),
                            widget.credits.crew.isEmpty
                                ? const Center(child: Text("No crew available"))
                                : _createCreditsView(widget.credits.crew),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView _createCreditsView(List<dynamic> list) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        childAspectRatio: 0.75, // Yüksekliği artırmak için oranı düşürün
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final actor = list[index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              barrierDismissible: true,
              builder: (context) => PersonDetailDialog(personId: actor.id),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (actor.profilePath != null)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: ImageHelper.getImage(
                        actor.profilePath,
                        ApiConstants.posterSize.m,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary.withAlpha(128),
                  ),
                ),
              SizedBox(height: 12),
              Text(
                actor.originalName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class PersonDetailDialog extends StatelessWidget {
  final int personId;
  const PersonDetailDialog({super.key, required this.personId});

  @override
  Widget build(BuildContext context) {
    final personService = PersonService();
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FutureBuilder<PersonModel>(
        future: personService.fetchPerson(personId: personId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 200,
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Hata: ${snapshot.error}'),
            );
          }

          final person = snapshot.data!;
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 24,
                  children: [
                    if (person.profilePath != null)
                      Container(
                        width: 125,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ImageHelper.getImage(
                              person.profilePath,
                              ApiConstants.posterSize.original,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      )
                    else
                      Container(
                        width: 125,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(128),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.name!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              person.birthday != null
                                  ? Text(
                                      DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(person.birthday!),
                                    )
                                  : Text("-"),
                            ],
                          ),
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Expanded(
                                child: Text(
                                  person.placeOfBirth ?? "-",
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                "${person.popularity!.toStringAsFixed(1)}/10.0",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (person.biography != null &&
                    person.biography!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    "Biography",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(person.biography!),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
