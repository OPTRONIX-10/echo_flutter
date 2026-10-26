import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/colour_constant.dart';
import '../controllers/vendor_controller.dart';

class VendorView extends GetView<VendorController> {
  const VendorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(
          'ECHO',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: neutralColor ,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.79,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.vendors.length,
            itemBuilder: (context, index) {
              final vendor = controller.vendors[index];

              return Obx(() {
                final isSelected = controller.selectedVendors.contains(index);

                return GestureDetector(
                  onTap: () => controller.toggleSelection(index, !isSelected),
                  child: Card(
                    color: secondaryColor,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  vendor.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                checkColor: secondaryColor,
                                activeColor: primaryColor,
                                onChanged: (value) => controller
                                    .toggleSelection(index, value ?? false),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vendor.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: primaryColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vendor.contactNumber,
                            style: const TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton.icon(
            onPressed: controller.callSelectedVendor,
            icon: const Icon(Icons.call, color: secondaryColor),
            label: const Text(
              'Initiate Call',
              style: TextStyle(color: secondaryColor),
            ),
            style: TextButton.styleFrom(
              backgroundColor: neutralColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
