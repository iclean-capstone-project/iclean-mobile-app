import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/bookings.dart';

import 'components/my_timeline.dart';

class TimelineContent extends StatelessWidget {
  final Booking booking;
  const TimelineContent({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTimeline(
            isFirst: true,
            isLast: false,
            statusTitle: "Đã đặt",
            date: DateTime.now(),
            //date: booking.timeCreated,
            booking: booking),
        MyTimeline(
            isFirst: false,
            isLast: false,
            statusTitle: "Được duyệt",
            date: DateTime.now(),
            //date: booking.timeWork,
            booking: booking),
        MyTimeline(
            isFirst: false,
            isLast: false,
            statusTitle: "Làm việc",
            date: DateTime.now(),
            //date: booking.timeStart,
            booking: booking),
        MyTimeline(
            isFirst: false,
            isLast: true,
            statusTitle: "hoàn thành",
            date: DateTime.now(),
            //date: booking.timeEnd,
            booking: booking),
      ],
    );
  }
}