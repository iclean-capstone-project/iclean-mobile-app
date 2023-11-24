import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/booking_detail.dart';
import 'package:iclean_mobile_app/widgets/details_fields.dart';

import 'package:intl/intl.dart';

class PaymentContent extends StatelessWidget {
  const PaymentContent({
    super.key,
    required this.booking,
  });

  final BookingDetail booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hóa đơn",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              for (int i = 0; i < booking.transaction.service!.length; i++)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking.transaction.service![i].serviceName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                          ),
                        ),
                        Text(
                          booking.transaction.service![i].formatPriceInVND(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ],
                    ),
                    if (i < booking.transaction.service!.length - 1)
                      const SizedBox(height: 8),
                  ],
                ),
              const SizedBox(height: 4),
              DetailsContentField(
                  text: "Tổng cộng", text2: booking.formatTotalPriceInVND()),
              const SizedBox(height: 4),
              DetailsContentField(
                  text:
                      "Sử dụng ${booking.transaction.discount?.toStringAsFixed(0)} iClean Point",
                  text2: '- ${booking.transaction.formatDiscountInVND()}'),
              Divider(
                thickness: 0.5,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 4),
              DetailsContentField(
                  text: "Thành tiền",
                  text2: booking.transaction.formatAmountInVND()),
              const SizedBox(height: 8),
              DetailsContentField(
                text: "Thời gian",
                text2: DateFormat('d/MM/yyyy | hh:mm aaa')
                    .format(booking.orderDate),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Trạng thái",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.transaction.status.name,
                      style: TextStyle(
                        color: Colors.deepPurple.shade400,
                        fontSize: 15,
                        fontFamily: 'Lato',
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}