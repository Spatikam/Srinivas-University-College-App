import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final Map<DateTime, List<String>> events;
  late DateTime selectedDay;
  late DateTime focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final List<Map<String, dynamic>> notif_events = [
    {"title": "Science Fair", "date": DateTime(2025, 2, 2, 18, 15)}, // Feb 5, 9 AM
    {"title": "Sports Day", "date": DateTime(2025, 2, 2, 18, 20)}, // Feb 10, 8:30 AM
    {"title": "Founder's Day", "date": DateTime(2025, 2, 14, 2, 16)}, // Feb 10, 8:30 AM
    //{"title": "Founder's Day", "date": DateTime(2025, 2, 14, 9, 0)} // Feb 20, 10 AM
  ];

  Map<DateTime, List<String>> predefinedEvents = {
    DateTime.utc(2025, 1, 1): ['New Year'],
    DateTime.utc(2025, 2, 14): ['Founder\'s day of Srinivas University'],
    DateTime.utc(2025, 1, 26): ['Republic day, January 26, happy holiday!'],
    DateTime.utc(2025, 2, 16): ['Cultural Day'],
    DateTime.utc(2024, 12, 9): ['Commencement of Classes'],
    DateTime.utc(2025, 1, 16): ['1st Phase Assesment Day 1'],
    DateTime.utc(2025, 1, 16): ['1st Phase Assesment Day 2'],
    DateTime.utc(2025, 1, 16): ['1st Phase Assesment Day 3'],
    DateTime.utc(2025, 3, 10): ['2nd Phase Assesment Day 1'],
    DateTime.utc(2025, 3, 11): ['2nd Phase Assesment Day 2'],
    DateTime.utc(2025, 3, 12): ['2nd Phase Assesment Day 3'],
    DateTime.utc(2025, 3, 22): ['Last Working Day'],
    DateTime.utc(2025, 3, 27): ['Practical Exams Begin'],
    DateTime.utc(2025, 4, 7): ['Theory Exams Begin'],
    DateTime.utc(2025, 6, 10): ['Commencement of Odd Semester'],
    DateTime.utc(2025, 2, 25): ['Srinivas Premier League Day 1'],
    DateTime.utc(2025, 2, 26): ['Srinivas Premier League Day 2'],
    DateTime.utc(2025, 2, 27): ['Srinivas Premier League Day 3'],
  };

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = selectedDay;
    events = {...predefinedEvents};
    _scheduleEventNotifications();
  }

  List<String> _getEventsForDay(DateTime day) => events[day] ?? [];

  List<Map<String, dynamic>> _getEventsForMonth() => events.entries
      .where((entry) => entry.key.month == focusedDay.month)
      .map((entry) => {
            'date': entry.key,
            'description': entry.value.join(', '),
          })
      .toList();

  void _onDateSelected(DateTime selected, DateTime focused) {
    setState(() {
      selectedDay = selected;
      focusedDay = focused;
    });
  }

  void _scheduleEventNotifications() {
    for (var event in notif_events) {
      NotificationService().scheduleNotification(
        event["title"],
        "Join Us in celebrating ${event["title"]}",
        event["date"],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Calendar with Events',
          style: TextStyle(color: iconColor),
        ),
      ),
      body: Column(
        children: [
          _buildCalendar(isDarkMode),
          const SizedBox(height: 16),
          _buildEventsHeader(isDarkMode),
          const SizedBox(height: 8),
          Expanded(child: _buildEventList(isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildCalendar(bool isDarkMode) {
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Container(
      color: themeColor,
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: _onDateSelected,
        onPageChanged: (day) => setState(() => focusedDay = day),
        eventLoader: _getEventsForDay,
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) => setState(() => _calendarFormat = format),
        calendarStyle: CalendarStyle(
          markerDecoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          todayTextStyle: GoogleFonts.kanit(color: iconColor),
          selectedTextStyle: GoogleFonts.kanit(color: themeColor),
          defaultTextStyle: GoogleFonts.kanit(
            color: iconColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEventsHeader(bool isDarkMode) {
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    return Text(
      'Special Events for the Month',
      style: GoogleFonts.kanit(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: iconColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEventList(bool isDarkMode) {
    final eventsForMonth = _getEventsForMonth();
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: ListView.separated(
        itemCount: eventsForMonth.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final event = eventsForMonth[index];
          return GestureDetector(
            onTap: () => _onDateSelected(event['date'], event['date']),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.lightBlue.shade900 : Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event['date'].day}-${event['date'].month}-${event['date'].year}',
                    style: GoogleFonts.kanit(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event['description'],
                    style: GoogleFonts.kanit(
                      color: iconColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);

    tz.initializeTimeZones(); // Required for scheduling
  }

  Future<void> scheduleNotification(String title, String body, DateTime eventTime) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(eventTime, tz.local);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return; // Prevent scheduling past events
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "event_channel",
      "Event Reminders",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      title.hashCode,
      title,
      body,
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅ Fixed
    );
  }
}
