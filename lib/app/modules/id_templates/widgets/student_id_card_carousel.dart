import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/employee_data.dart';
import '../../../data/models/student_data.dart';
import '../../create_flow/controllers/create_flow_controller.dart';
import '../controllers/template_controller.dart';
import '../design_system/id_card_dimensions.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'company_id_template_selector.dart';
import 'id_card_scaled_preview.dart';
import 'student_id_card_side.dart';
import 'student_id_template_selector.dart';

/// Editor — full-width portrait card, swipe front ↔ back.
class StudentIdCardCarousel extends StatefulWidget {
  const StudentIdCardCarousel({
    super.key,
    this.studentData,
    this.employeeData,
    this.isEmployee = false,
    required this.fontFamily,
    required this.templateIndex,
    this.repaintBoundaryKey,
  });

  final StudentData? studentData;
  final EmployeeData? employeeData;
  final bool isEmployee;
  final String fontFamily;
  final int templateIndex;
  final GlobalKey? repaintBoundaryKey;

  @override
  State<StudentIdCardCarousel> createState() => _StudentIdCardCarouselState();
}

class _StudentIdCardCarouselState extends State<StudentIdCardCarousel> {
  late final PageController _pageController;
  int _page = 0;

  int get _pageCount {
    if (widget.isEmployee) {
      return (widget.employeeData?.hasBackContent ?? true) ? 2 : 1;
    }
    final flow = Get.find<CreateFlowController>();
    if (flow.studentTemplateIsFrontOnly(widget.templateIndex)) return 1;
    return (widget.studentData?.hasBackContent ?? false) ? 2 : 1;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.94);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_pageCount > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              _page == 0 ? 'Front — swipe for back →' : '← Back side',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final flow = Get.find<CreateFlowController>();
              final landscape = !widget.isEmployee &&
                  flow.studentTemplateIsLandscape(widget.templateIndex);
              final cardWidth = constraints.maxWidth;
              final cardHeight = cardWidth *
                  (landscape
                      ? IdCardDimensions.height / IdCardDimensions.width
                      : IdCardPortraitDimensions.height /
                          IdCardPortraitDimensions.width);

              return PageView.builder(
                controller: _pageController,
                itemCount: _pageCount,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final side = index == 0
                      ? StudentIdCardSide.front
                      : StudentIdCardSide.back;
                  final innerCard = SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: landscape
                        ? IdCardScaledPreview.landscapeCard(
                            child: buildStudentPortraitTemplate(
                              globalIndex: widget.templateIndex,
                              data: widget.studentData!,
                              side: side,
                              fontFamily: widget.fontFamily,
                            ),
                          )
                        : IdCardScaledPreview.portraitCard(
                            child: widget.isEmployee
                                ? buildCompanyPortraitTemplate(
                                    globalIndex: widget.templateIndex,
                                    data: widget.employeeData!,
                                    side: side,
                                    fontFamily: widget.fontFamily,
                                  )
                                : buildStudentPortraitTemplate(
                                    globalIndex: widget.templateIndex,
                                    data: widget.studentData!,
                                    side: side,
                                    fontFamily: widget.fontFamily,
                                  ),
                          ),
                  );

                  if (index == 0 && widget.repaintBoundaryKey != null) {
                    return Center(
                      child: RepaintBoundary(
                        key: widget.repaintBoundaryKey,
                        child: innerCard,
                      ),
                    );
                  }
                  return Center(child: innerCard);
                },
              );
            },
          ),
        ),
        if (_pageCount > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pageCount, (i) {
              final active = _page == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

/// Binds carousel to current service (student vs employee) from [TemplateController].
class LiveIdCardCarousel extends StatelessWidget {
  const LiveIdCardCarousel({
    super.key,
    required this.templateIndex,
    this.repaintBoundaryKey,
  });

  final int templateIndex;
  final GlobalKey? repaintBoundaryKey;

  @override
  Widget build(BuildContext context) {
    final flow = Get.find<CreateFlowController>();
    final templateCtrl = Get.find<TemplateController>();

    return Obx(
      () {
        flow.selectedFont.value;
        final isEmployee = flow.isEmployeeService;
        return StudentIdCardCarousel(
          studentData: isEmployee ? null : templateCtrl.studentData.value,
          employeeData: isEmployee ? templateCtrl.employeeData.value : null,
          isEmployee: isEmployee,
          fontFamily: flow.selectedFontFamily,
          templateIndex: templateIndex,
          repaintBoundaryKey: repaintBoundaryKey,
        );
      },
    );
  }
}
