import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/utils/time.dart';
import 'package:intl/intl.dart';
import 'package:iclean_mobile_app/models/cart_item.dart';
import 'package:iclean_mobile_app/widgets/details_fields.dart';

class ServiceInfo extends StatelessWidget {
  const ServiceInfo({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thời gian làm việc",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 8),
          DetailsContentField(
              text: "Ngày làm việc",
              text2: DateFormat('d/MM/yyyy').format(cartItem.workDate)),
          const SizedBox(height: 4),
          DetailsContentField(
              text: "Thời gian làm việc",
              text2:
                  "${cartItem.workTime.to24hours()}-${cartItem.workTime.addHour(cartItem.serviceUnit.equivalent.toInt()).to24hours()}"),
          const SizedBox(height: 8),
          const Text(
            "Chi tiết công việc",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 8),
          DetailsContentField(
              text: "Tên công việc", text2: cartItem.serviceName),
          const SizedBox(height: 4),
          DetailsContentField(
            text: "Khối lượng công việc",
            text2: cartItem.serviceUnit.value.toString(),
          ),
          const SizedBox(height: 4),
          DetailsContentField(text: "Giá", text2: cartItem.formatPriceInVND()),
          const SizedBox(height: 4),
          DetailsContentField(text: "Ghi chú", text2: cartItem.note),
        ],
      ),
    );
  }
}
