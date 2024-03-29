import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/booking_detail.dart';
import 'package:iclean_mobile_app/models/booking_status.dart';
import 'package:iclean_mobile_app/models/bookings.dart';
import 'package:iclean_mobile_app/provider/loading_state_provider.dart';
import 'package:iclean_mobile_app/services/api_booking_repo.dart';
import 'package:iclean_mobile_app/utils/color_palette.dart';
import 'package:iclean_mobile_app/view/helper/nav_bar_bottom/helper_screen.dart';
import 'package:iclean_mobile_app/widgets/checkout_success_dialog.dart';
import 'package:iclean_mobile_app/widgets/details_fields.dart';
import 'package:iclean_mobile_app/widgets/main_color_inkwell_full_size.dart';
import 'package:iclean_mobile_app/widgets/my_app_bar.dart';
import 'package:iclean_mobile_app/widgets/note_content.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'components/address_content.dart';
import 'components/detail_content_for_helper.dart';
import 'components/renter_content.dart';
import '../../../../widgets/timeline_content.dart';
import 'components/timeline_details/timeline_details_for_helper.dart';

class BookingDetailsForHelperScreen extends StatelessWidget {
  const BookingDetailsForHelperScreen({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    Future<BookingDetail> fetchBookingDetail(int id) async {
      final ApiBookingRepository repository = ApiBookingRepository();
      try {
        final bookingDetail =
            await repository.getBookingDetailsByIdForHelper(context, id);
        return bookingDetail;
      } catch (e) {
        // ignore: avoid_print
        print(e);
        throw Exception("Failed to fetch BookingDetail");
      }
    }

    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    Future<void> cancelBooking(int id) async {
      final ApiBookingRepository repository = ApiBookingRepository();
      await repository.cancelBookingForHelper(id).then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) => CheckoutSuccessDialog(
            title: "Bạn đã hủy dịch vụ thành công!",
            description: "Bạn sẽ được hoàn tiền theo số tiền của dịch vụ này.",
            image: 'assets/images/success.png',
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HelperScreens(selectedIndex: 1)));
            },
          ),
        );
      }).catchError((error) {
        // ignore: avoid_print
        print('Failed to cancel booking: $error');
      });
    }

    final loadingState = Provider.of<LoadingStateProvider>(context);
    return Scaffold(
      appBar: const MyAppBar(text: 'Chi tiết đơn'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (booking.status == BookingStatus.finished ||
                booking.status == BookingStatus.reported)
              Container(
                color: ColorPalette.mainColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Dịch vụ đã hoàn thành",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Cám ơn bạn đã hoàn thành công việc!",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.domain_verification_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: FutureBuilder<BookingDetail>(
                future: fetchBookingDetail(booking.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    BookingDetail bookingDetail = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: TimelineContent(booking: booking),
                        ),
                        const SizedBox(height: 16),
                        TimelineDetailsForHelper(
                            listStatus: bookingDetail.listStatus),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DetailsContentField(
                              text: "Mã đặt dịch vụ",
                              text2: bookingDetail.bookingCode),
                        ),
                        const SizedBox(height: 16),
                        AddressContent(booking: bookingDetail),
                        const SizedBox(height: 16),
                        RenterContent(booking: bookingDetail),
                        const SizedBox(height: 16),
                        DetailContentForHelper(booking: bookingDetail),
                        const SizedBox(height: 16),
                        NoteContent(booking: bookingDetail),
                        const SizedBox(height: 16),
                        const Text(
                          "Hóa đơn",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              DetailsContentField(
                                text: "Thu nhập từ dịch vụ",
                                text2: bookingDetail.formatTotalPriceInVND(),
                              ),
                              if (bookingDetail.status ==
                                      BookingStatus.finished &&
                                  bookingDetail.reported)
                                const SizedBox(height: 8),
                              if (bookingDetail.status ==
                                      BookingStatus.finished &&
                                  bookingDetail.reported)
                                DetailsContentField(
                                  text: "Tiền phạt",
                                  text2:
                                      '- ${bookingDetail.formatPenaltyMoneyInVND()}',
                                ),
                              Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                              if (booking.status ==
                                      BookingStatus.cancelByHelper ||
                                  booking.status ==
                                      BookingStatus.cancelByRenter ||
                                  booking.status ==
                                      BookingStatus.cancelBySystem)
                                const DetailsContentField(
                                  text: "Thu nhập thực tế",
                                  text2: "0 đ",
                                  color: ColorPalette.mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              if (booking.status == BookingStatus.finished ||
                                  booking.status == BookingStatus.reported)
                                DetailsContentField(
                                  text: "Thu nhập thực tế",
                                  text2: NumberFormat.currency(
                                          locale: 'vi_VN', symbol: 'đ')
                                      .format(bookingDetail.price -
                                          bookingDetail.penaltyMoney!),
                                  color: ColorPalette.mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (booking.status == BookingStatus.upcoming)
                          if (daysBetween(
                                  bookingDetail.workDate, DateTime.now()) <
                              1)
                            MainColorInkWellFullSize(
                              onTap: () async {
                                loadingState.setLoading(true);
                                try {
                                  await cancelBooking(bookingDetail.id);
                                } finally {
                                  loadingState.setLoading(false);
                                }
                              },
                              text: "Hủy đơn",
                            ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
