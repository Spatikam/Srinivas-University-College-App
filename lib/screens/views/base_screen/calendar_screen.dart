import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CalendarScreen extends StatefulWidget {
  final String collegeName;
  const CalendarScreen({super.key, required this.collegeName});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final Map<DateTime, List<String>> events;
  late DateTime selectedDay;
  late DateTime focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final List<Map<String, dynamic>> notif_events = [
    //{"title": "Science Fair", "date": DateTime(2025, 2, 24, 12, 40)}, // Feb 5, 9 AM
    //Odd Sem
    {"title": "Commencement of Classes for 3rd, 5th & 7th Sem", "date": DateTime(2025, 7, 7, 8, 0)},
    {"title": "Internal Assesment-1 for 3rd, 5th & 7th Sem", "date": DateTime(2025, 8, 18, 8, 0)},
    {"title": "Internal Assesment-2 for 3rd, 5th & 7th Sem", "date": DateTime(2025, 10, 6, 8, 0)},
    {"title": "Internal Assesment-3 for 3rd, 5th & 7th Sem", "date": DateTime(2025, 10, 13, 8, 0)},
    {"title": "Practical Exam begins for 3rd, 5th & 7th Sem", "date": DateTime(2025, 11, 3, 8, 0)},
    {"title": "Sem-end Exam begins for 3rd, 5th & 7th Sem", "date": DateTime(2025, 11, 17, 8, 0)},
    {"title": "Results Announcement for 3rd, 5th & 7th Sem", "date": DateTime(2025, 12, 1, 8, 0)},
    
    {"title": "Commencement of Classes for 1st Sem", "date": DateTime(2025, 8, 18, 8, 0)},
    {"title": "Internal Assesment-1 for 1st Sem", "date": DateTime(2025, 10, 6, 8, 0)},
    {"title": "Internal Assesment-2 for 1st Sem", "date": DateTime(2025, 11, 17, 8, 0)},
    {"title": "Internal Assesment-3 for 1st Sem", "date": DateTime(2025, 11, 25, 8, 0)},
    {"title": "Practical Exam begins for 1st Sem", "date": DateTime(2025, 12, 10, 8, 0)},
    {"title": "Sem-end Exam begins for 1st Sem", "date": DateTime(2025, 12, 22, 8, 0)},
    {"title": "Results Announcement for 1st Sem", "date": DateTime(2026, 1, 5, 8, 0)},

    //Even Sem
    {"title": "Commencement of Classes for 4th, 6th & 8th Sem", "date": DateTime(2025, 12, 8, 8, 0)},
    {"title": "Internal Assesment-1 for 4th, 6th & 8th Sem", "date": DateTime(2026, 1, 12, 8, 0)},
    {"title": "Internal Assesment-2 for 4th, 6th & 8th Sem", "date": DateTime(2026, 2, 23, 8, 0)},
    {"title": "Internal Assesment-3 for 4th, 6th & 8th Sem", "date": DateTime(2026, 3, 2, 8, 0)},
    {"title": "Practical Exam begins for 4th, 6th & 8th Sem", "date": DateTime(2026, 4, 1, 8, 0)},
    {"title": "Sem-end Exam begins for 4th, 6th & 8th Sem", "date": DateTime(2026, 4, 13, 8, 0)},
    {"title": "Results Announcement for 4th, 6th & 8th Sem", "date": DateTime(2026, 5, 10, 8, 0)},
    
    {"title": "Commencement of Classes for 2nd Sem", "date": DateTime(2026, 1, 10, 8, 0)},
    {"title": "Internal Assesment-1 for 2nd Sem", "date": DateTime(2026, 2, 19, 8, 0)},
    {"title": "Internal Assesment-2 for 2nd Sem", "date": DateTime(2026, 3, 23, 8, 0)},
    {"title": "Internal Assesment-3 for 2nd Sem", "date": DateTime(2026, 4, 1, 8, 0)},
    {"title": "Practical Exam begins for 2nd Sem", "date": DateTime(2026, 4, 21, 8, 0)},
    {"title": "Sem-end Exam begins for 2nd Sem", "date": DateTime(2026, 5, 5, 8, 0)},
    {"title": "Results Announcement for 2nd Sem", "date": DateTime(2026, 5, 25, 8, 0)},
    //{"title": "", "date": DateTime(2025, 7, 7, 8, 0)}
  ];

  Map<String, Map<DateTime, List<String>>> predefinedEvents = {
    'Engineering & Technology': {
      //DateTime.utc(2025, 2, 14): ['Founder\'s day of Srinivas University'],
      //Odd Sem
      DateTime.utc(2025, 7, 7): ['Commencement of Classes for 3rd, 5th & 7th Sem'],
      DateTime.utc(2025, 8, 18): ['Internal Assesment-1 for 3rd, 5th & 7th Sem\nCommencement of Classes for 1st Sem'],
      DateTime.utc(2025, 10, 6): ['Internal Assesment-2 for 3rd, 5th & 7th Sem\nInternal Assesment-1 for 1st Sem'],
      DateTime.utc(2025, 10, 13): ['Internal Assesment-3 for 3rd, 5th & 7th Sem'],
      DateTime.utc(2025, 10, 21): ['Sem-end Exam Announcement for 3rd, 5th & 7th Sem'],
      DateTime.utc(2025, 10, 30): ['Last Working Day for 3rd, 5th & 7th Sem'],
      DateTime.utc(2025, 11, 3): ['Practical Exam begins for 3rd, 5th & 7th Sem'],
      DateTime.utc(2025, 11, 10): ['Practical Exam ends for 3rd, 5th & 7th Sem'],
      DateTime.utc(2025, 11, 17): ['Sem-end Exam begins for 3rd, 5th & 7th Sem\nInternal Assesment-2 for 1st Sem'],
      DateTime.utc(2025, 11, 25): ['Sem-end Exam ends for 3rd, 5th & 7th Sem\nInternal Assesment-3 for 1st Sem'],
      DateTime.utc(2025, 12, 1): ['Results Announcement for 3rd, 5th & 7th Sem'],

      DateTime.utc(2025, 8, 30): ['Last Date for Admission without Penalty'],
      DateTime.utc(2025, 9, 30): ['Last Date for Admission with Penalty'],
      DateTime.utc(2025, 11, 30): ['Sem-end Exam Announcement for 1st Sem'],
      DateTime.utc(2025, 12, 6): ['Last Working Day for 1st Sem'],
      DateTime.utc(2025, 12, 10): ['Practical Exam begins for 1st Sem'],
      DateTime.utc(2025, 12, 20): ['Practical Exam ends for 1st Sem'],
      DateTime.utc(2025, 12, 22): ['Sem-end Exam begins for 1st Sem'],
      DateTime.utc(2025, 12, 30): ['Sem-end Exam ends for 1st Sem'],
      DateTime.utc(2026, 1, 5): ['Results Announcement for 1st Sem'],
      // Even Sem
      DateTime.utc(2025, 12, 8): ['Commencement of Classes for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 1, 12): ['Internal Assesment-1 for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 2, 23): ['Internal Assesment-2 for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 3, 2): ['Internal Assesment-3 for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 3, 23): ['Sem-end Exam Announcement for 4th, 6th & 8th Sem\nInternal Assesment-2 for 2nd Sem'],
      DateTime.utc(2026, 3, 30): ['Last Working Day for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 4, 1): ['Practical Exam begins for 4th, 6th & 8th Sem\nInternal Assesment-3 for 2nd Sem'],
      DateTime.utc(2026, 4, 10): ['Practical Exam ends for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 4, 13): ['Sem-end Exam begins for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 4, 25): ['Sem-end Exam ends for 4th, 6th & 8th Sem'],
      DateTime.utc(2026, 5, 10): ['Results Announcement for 4th, 6th & 8th Sem'],

      DateTime.utc(2026, 1, 10): ['Commencement of Classes for 2nd Sem'],
      DateTime.utc(2026, 2, 19): ['Internal Assesment-1 for 2nd Sem'],
      DateTime.utc(2026, 4, 6): ['Sem-end Exam Announcement for 2nd Sem'],
      DateTime.utc(2026, 4, 19): ['Last Working Day for 2nd Sem'],
      DateTime.utc(2026, 4, 21): ['Practical Exam begins for 2nd Sem'],
      DateTime.utc(2026, 4, 30): ['Practical Exam ends for 2nd Sem'],
      DateTime.utc(2026, 5, 5): ['Sem-end Exam begins for 2nd Sem'],
      DateTime.utc(2026, 5, 17): ['Sem-end Exam ends for 2nd Sem'],
      DateTime.utc(2026, 5, 25): ['Results Announcement for 2nd Sem'],

      //DateTime.utc(2025, , ): [''],
    },
    'Hotel Management & Tourism': {},
    'Management & Commerce': {},
    'Computer Science & Information Science': {},
    'Physiotherapy': {},
    'Allied Health Sciences': {},
    'Social Sciences & Humanities': {},
    'Education': {},
    'Nursing Science': {},
    'Aviation Studies': {},
    'Port Shipping and Logistics': {}
  };

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = selectedDay;
    events = {...predefinedEvents[widget.collegeName]!};
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

  Future<bool> requestNotificationPermission() async {
    PermissionStatus status;

    if (await Permission.notification.isGranted) {
      return true;
    }

    status = await Permission.notification.request();

    if (status.isDenied) {
      return false;
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  void _scheduleEventNotifications() async {
    bool hasPermission = await requestNotificationPermission();
    if (hasPermission) {
      for (var event in notif_events) {
        NotificationService().scheduleNotification(
          event["title"],
          "Join Us in celebrating ${event["title"]}",
          event["date"],
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Media access permission required')),
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
          style: GoogleFonts.kanit(
            fontSize: 20,
            color: iconColor,
          ),
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
        lastDay: DateTime.utc(2026, 12, 31),
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

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails("event_channel", "Event Reminders", importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      title.hashCode,
      title,
      body,
      scheduledDate,
      details,
      //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅ Fixed
    );
  }
}