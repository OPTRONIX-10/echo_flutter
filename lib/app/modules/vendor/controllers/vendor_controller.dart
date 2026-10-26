import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Vendor {
  const Vendor({
    required this.title,
    required this.address,
    required this.contactNumber,
  });

  final String title;
  final String address;
  final String contactNumber;
}

class VendorController extends GetxController {
  final vendors = const [
    Vendor(
      title: 'Sharma Electricals',
      address: '12 MG Road, Bengaluru',
      contactNumber: '+91 98765 43210',
    ),
    Vendor(
      title: 'Patel Hardware',
      address: '45 Market Street, Ahmedabad',
      contactNumber: '+91 98765 12345',
    ),
    Vendor(
      title: 'Kumar Supplies',
      address: '8 Station Road, Chennai',
      contactNumber: '+91 91234 56789',
    ),
    Vendor(
      title: 'Modern Traders',
      address: '27 Park Avenue, Hyderabad',
      contactNumber: '+91 99887 76655',
    ),
    Vendor(
      title: 'Modern Traders',
      address: '27 Park Avenue, Hyderabad',
      contactNumber: '+91 99887 76655',
    ),
    Vendor(
      title: 'Modern Traders',
      address: '27 Park Avenue, Hyderabad',
      contactNumber: '+91 99887 76655',
    ),
    Vendor(
      title: 'Modern Traders',
      address: '27 Park Avenue, Hyderabad',
      contactNumber: '+91 99887 76655',
    ),
    Vendor(
      title: 'Modern Traders',
      address: '27 Park Avenue, Hyderabad',
      contactNumber: '+91 99887 76655',
    ),
    Vendor(
      title: 'Modern Traders',
      address: '27 Park Avenue, Hyderabad',
      contactNumber: '+91 99887 76655',
    ),
    Vendor(
      title: 'Modern Traders',
      address: '27 Park Avenue, Hyderabad',
      contactNumber: '+91 99887 76655',
    ),
  ];

  final selectedVendors = <int>{}.obs;

  void toggleSelection(int index, bool selected) {
    if (selected) {
      selectedVendors.add(index);
    } else {
      selectedVendors.remove(index);
    }
  }

  Future<void> callSelectedVendor() async {
    if (selectedVendors.isEmpty) {
      Get.snackbar('No vendor selected', 'Select a vendor before calling.');
      return;
    }

    await callVendor(vendors[selectedVendors.first]);
  }

  Future<void> callVendor(Vendor vendor) async {
    final phoneUri = Uri(
      scheme: 'tel',
      path: vendor.contactNumber.replaceAll(RegExp(r'[^\d+]'), ''),
    );

    if (!await launchUrl(phoneUri)) {
      Get.snackbar(
        'Unable to call vendor',
        'No phone application is available on this device.',
      );
    }
  }
}
