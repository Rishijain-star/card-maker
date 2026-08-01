import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_flow_controller.dart';
import 'employee_details_form_view.dart';
import 'lanyard_details_form_view.dart';
import 'student_details_form_view.dart';

class DetailsFormView extends GetView<CreateFlowController> {
  const DetailsFormView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.selectedService.value == 'Student ID Card') {
      return const StudentDetailsFormView();
    }
    if (controller.selectedService.value == 'Employee ID Card') {
      return const EmployeeDetailsFormView();
    }
    if (controller.selectedService.value == 'Lanyard') {
      return const LanyardDetailsFormView();
    }
    return const StudentDetailsFormView();
  }
}
