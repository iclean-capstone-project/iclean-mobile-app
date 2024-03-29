import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/address.dart';
import 'package:iclean_mobile_app/services/api_location_repo.dart';
import 'package:iclean_mobile_app/widgets/confirm_dialog.dart';
import 'package:iclean_mobile_app/widgets/my_app_bar.dart';
import 'package:iclean_mobile_app/view/common/profile/location/add_location/add_location_screen.dart';
import 'package:iclean_mobile_app/view/common/profile/location/update_location/update_location_screen.dart';
import 'package:iclean_mobile_app/widgets/my_bottom_app_bar.dart';
import 'package:iclean_mobile_app/widgets/shimmer_loading.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<Address>> fetchNotifications() async {
      final ApiLocationRepository repository = ApiLocationRepository();
      try {
        final locations = await repository.getLocation(context);
        return locations;
      } catch (e) {
        // ignore: avoid_print
        print(e);
        return <Address>[];
      }
    }

    void showConfirmationDialog(BuildContext context, Address location) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmDialog(
            title: "Chọn ${location.addressName} làm địa chỉ mặc định",
            confirm: "Xác nhận",
            onTap: () {
              final ApiLocationRepository repository = ApiLocationRepository();
              repository.setDefault(context, location.id!).then((_) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationScreen()));
              }).catchError((error) {
                // ignore: avoid_print
                print('Failed to update location: $error');
              });
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: const MyAppBar(text: "Vị trí của tôi"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<List<Address>>(
          future: fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                    children: List.generate(5, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const ShimmerLoadingWidget.circular(
                                  height: 16, width: 16),
                              const SizedBox(width: 16),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerLoadingWidget.rectangular(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height: 16,
                                    ),
                                    const SizedBox(height: 8),
                                    const ShimmerLoadingWidget.rectangular(
                                      height: 12,
                                    ),
                                    const SizedBox(height: 4),
                                    ShimmerLoadingWidget.rectangular(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (index != 4)
                          Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                      ],
                    ),
                  );
                })),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<Address> locations = snapshot.data ?? [];
              return Column(
                children: [
                  const SizedBox(height: 16),
                  for (int i = 0; i < locations.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (locations[i].isDefault == false) {
                                      showConfirmationDialog(
                                          context, locations[i]);
                                    }
                                  },
                                  child: Icon(
                                    locations[i].isDefault
                                        ? Icons.circle_rounded
                                        : Icons.circle_outlined,
                                    color: Colors.deepPurple.shade300,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            locations[i].addressName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateLocationScreen(
                                                              address:
                                                                  locations[
                                                                      i])));
                                            },
                                            child: const Text(
                                              "Sửa",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(locations[i].description,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontFamily: 'Lato',
                                          ),
                                          textAlign: TextAlign.justify,
                                          maxLines: null),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (i != locations.length - 1)
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                        ],
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(
        text: "Thêm vị trí mới",
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddLocationScreen()));
        },
      ),
    );
  }
}
