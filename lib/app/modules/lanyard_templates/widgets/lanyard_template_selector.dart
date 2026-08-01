import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import 'lanyard_template_widget.dart';

Widget buildLanyardTemplate({
  required int variant,
  required LanyardData data,
}) {
  return LanyardTemplateWidget(data: data, variant: variant);
}
