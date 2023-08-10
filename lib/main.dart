import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';

void main() {
  runApp(MyApp());
}

class Destination {
  final String name;
  final String description;
  final String image;

  Destination({required this.name, required this.description, required this.image});
}

class Activity {
  final String name;

  Activity({required this.name});
}

class Itinerary {
  final Destination destination;
  final Map<int, List<Activity>> daysActivities;

  Itinerary({required this.destination, required this.daysActivities});
}

class AppState extends ChangeNotifier {
  Destination? selectedDestination;
  Itinerary? currentItinerary;

  void selectDestination(Destination destination) {
    selectedDestination = destination;
    notifyListeners();
  }

  void createItinerary() {
    currentItinerary = Itinerary(destination: selectedDestination!, daysActivities: {});
    notifyListeners();
  }

  void addActivity(int day, Activity activity) {
    if (currentItinerary != null) {
      currentItinerary!.daysActivities.putIfAbsent(day, () => []);
      currentItinerary!.daysActivities[day]!.add(activity);
      notifyListeners();
    }
  }

  void removeActivity(int day, Activity activity) {
    if (currentItinerary != null && currentItinerary!.daysActivities.containsKey(day)) {
      currentItinerary!.daysActivities[day]!.remove(activity);
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  final router = FluroRouter();

  MyApp() {
    final appState = AppState();

    router.define(
      '/',
      handler: Handler(
        handlerFunc: (context, params) => HomePage(),
      ),
    );

    router.define(
      '/destination',
      handler: Handler(
        handlerFunc: (context, params) => DestinationPage(),
      ),
    );

    router.define(
      '/itinerary',
      handler: Handler(
        handlerFunc: (context, params) => ItineraryPage(),
      ),
    );

    router.define(
      '/day/:day',
      handler: Handler(
        handlerFunc: (context, params) {
          final dayParam = params['day']?.first;
          if (dayParam != null) {
            final day = int.tryParse(dayParam);
            if (day != null) {
              return DayPlannerPage(day: day);
            }
          }
          return SizedBox.shrink(); // Handle invalid route
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AppState(),
      child: MaterialApp(
        title: 'RouteRovers',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: router.generator,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RouteRovers')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to RouteRovers!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/destination');
              },
              child: Text('Select Destination'),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Destination> destinations = [
  Destination(
    name: 'Paris',
    description: 'The romantic city of France.',
    image: 'assets/images/paris.jpg', // Updated path
  ),
  Destination(
    name: 'Tokyo',
    description: 'Experience the vibrant culture of Japan.',
    image: 'assets/images/tokyo.jpg', // Updated path
  ),
  // Add more destinations...
];


class DestinationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Destination')),
      body: ListView.builder(
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(destinations[index].name),
            onTap: () {
              Provider.of<AppState>(context, listen: false).selectDestination(destinations[index]);
              Navigator.pushNamed(context, '/itinerary');
            },
            leading: Image.asset(destinations[index].image, height: 100),
          );
        },
      ),
    );
  }
}

// Rest of your code remains unchanged

// ... (ItineraryPage, DayPlannerPage, AddActivityDialog classes)


class ItineraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedDestination = appState.selectedDestination;

    return Scaffold(
      appBar: AppBar(title: Text('Itinerary')),
      body: Center(
        child: selectedDestination == null
            ? Text('No destination selected.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(selectedDestination.image, height: 200),
                  SizedBox(height: 20),
                  Text(selectedDestination.description),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      appState.createItinerary();
                      Navigator.pushNamed(context, '/day/1');
                    },
                    child: Text('Create Itinerary'),
                  ),
                  SizedBox(height: 20),
                  if (appState.currentItinerary != null)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/day/1');
                      },
                      child: Text('View Itinerary'),
                    ),
                ],
              ),
      ),
    );
  }
}

class DayPlannerPage extends StatelessWidget {
  final int day;

  DayPlannerPage({required this.day});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedDestination = appState.selectedDestination;
    final currentItinerary = appState.currentItinerary;

    if (selectedDestination == null || currentItinerary == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Day Planner')),
        body: Center(child: Text('No itinerary created.')),
      );
    }

    final activities = currentItinerary.daysActivities[day] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Day Planner')),
      body: Column(
        children: [
          Image.asset(selectedDestination.image, height: 150),
          SizedBox(height: 10),
          Text(selectedDestination.name),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(activities[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      appState.removeActivity(day, activities[index]);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddActivityDialog(
                  onAddActivity: (activityName) {
                    appState.addActivity(day, Activity(name: activityName));
                  },
                ),
              );
            },
            child: Text('Add Activity'),
          ),
        ],
      ),
    );
  }
}

class AddActivityDialog extends StatefulWidget {
  final Function(String) onAddActivity;

  AddActivityDialog({required this.onAddActivity});

  @override
  _AddActivityDialogState createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final TextEditingController _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Activity'),
      content: TextField(
        controller: _activityController,
        decoration: InputDecoration(labelText: 'Activity Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final activityName = _activityController.text;
            if (activityName.isNotEmpty) {
              widget.onAddActivity(activityName);
              Navigator.pop(context);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }
}
