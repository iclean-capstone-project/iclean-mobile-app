// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/provider/loading_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:iclean_mobile_app/models/service.dart';
import 'package:iclean_mobile_app/widgets/my_app_bar.dart';
import 'package:iclean_mobile_app/services/api_cart_repo.dart';
import 'package:iclean_mobile_app/widgets/my_textfield.dart';
import 'package:iclean_mobile_app/provider/booking_details_provider.dart';
import 'package:iclean_mobile_app/widgets/my_bottom_app_bar_with_two_inkwell.dart';
import 'package:iclean_mobile_app/view/renter/nav_bar_bottom/renter_screen.dart';
import 'package:iclean_mobile_app/view/renter/checkout/checkout/checkout_screen.dart';

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
  final noteController = TextEditingController();

  Future<void> addToCart(bookingDetailsProvider) async {
    final selectedDate = bookingDetailsProvider.selectedDay;
    final selectedTime = bookingDetailsProvider.selectedTime;
    final startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      0,
    );
    final serviceUnitId = bookingDetailsProvider.selectedServiceUnit.id;
    final note = noteController.text;
    final ApiCartRepository repository = ApiCartRepository();
    bool check =
        await repository.addToCart(context, startTime, serviceUnitId, note);
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Dịch vụ ${widget.service.name} đã được thêm vào giỏ hàng'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn không thể đặt đơn với thời gian trong quá khứ'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingStateProvider>(context);
    final bookingDetailsProvider = Provider.of<BookingDetailsProvider>(context);
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
              TimeWorkingOption(service: widget.service),
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
              MyTextField(
                controller: noteController,
                hintText: 'Thêm ghi chú',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomAppBarTwoInkWell(
        text1: "Thêm vào giỏ",
        onTap1: () async {
          loadingState.setLoading(true);
          try {
            await addToCart(bookingDetailsProvider);
          } finally {
            loadingState.setLoading(false);
          }
        },
        text2: "Đặt dịch vụ",
        onTap2: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                        note: noteController.text,
                      )));
        },
      ),
    );
  }
}
