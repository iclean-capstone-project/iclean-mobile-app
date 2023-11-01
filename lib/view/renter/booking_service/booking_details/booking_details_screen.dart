import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:iclean_mobile_app/models/cart.dart';
import 'package:iclean_mobile_app/models/services.dart';
import 'package:iclean_mobile_app/widgets/my_app_bar.dart';
import 'package:iclean_mobile_app/widgets/my_bottom_app_bar_with_two_inkwell.dart';
import 'package:iclean_mobile_app/view/renter/nav_bar_bottom/renter_screen.dart';
import 'package:iclean_mobile_app/view/renter/booking_service/checkout/checkout_screen.dart';

import '../../../../provider/booking_details_provider.dart';
import 'components/my_calendar.dart';
import 'components/start_time_option.dart';
import 'components/time_working_option.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({
    super.key,
    required this.service,
  });

  final Service service;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    BookingDetailsProvider bookingDetailsProvider =
        Provider.of<BookingDetailsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: MyAppBar(
        text: widget.service.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RenterScreens(selectedIndex: 3)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Chọn ngày làm",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 8),
              MyCalendar(bookingDetailsProvider: bookingDetailsProvider),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  thickness: 1,
                ),
              ),
              const Text(
                "Chọn thời lượng",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TimeWorkingOption(bookingDetailsProvider: bookingDetailsProvider),
              const SizedBox(height: 16),
              const Text(
                "Chọn giờ làm",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const StartTimeOption(),
              const SizedBox(height: 16),
              const Text(
                "Ghi chú",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Thêm ghi chú",
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Tùy chọn",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                  Icon(Icons.online_prediction_outlined)
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomAppBarTwoInkWell(
        text1: "Thêm vào giỏ",
        onTap1: () {
          cartProvider.addToCart(
            CartItem(
              service: widget.service,
              day: bookingDetailsProvider.selectedDay,
              time: bookingDetailsProvider.selectedOption,
              timeStart: bookingDetailsProvider.selectedTime,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.service.name} đã được thêm vào giỏ hàng'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        text2: "Đặt dịch vụ",
        onTap2: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutScreen1(
                        service: widget.service,
                      )));
        },
      ),
    );
  }
}
