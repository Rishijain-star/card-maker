import 'package:flutter/material.dart';

class TaskTemplate {
  final String id;
  final String title;
  final String description;
  final List<String> steps;
  final IconData icon;
  final Color color;
  final String category;

  const TaskTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    required this.icon,
    this.color = Colors.blue,
    this.category = 'Property Management',
  });
}

class TemplateCategory {
  final String name;
  final List<TaskTemplate> templates;

  TemplateCategory({required this.name, required this.templates});
}

final List<TaskTemplate> propertyManagementTemplates = [
  TaskTemplate(
    id: 'move-out',
    title: 'Move-Out Workflow',
    description: 'Comprehensive checklist for tenant vacating process.',
    icon: Icons.exit_to_app_rounded,
    color: Colors.orange,
    category: 'Property Inspection',
    steps: [
      'Open move-out case',
      'Confirm move-out date',
      'Collect forwarding address',
      'Prepare inspection documents',
      'Conduct inspection',
      'Capture photos/evidence',
      'Record key return',
      'Finalize report',
      'Review charges',
      'Approve refund',
      'Send statement (Day 10)',
      'Close case',
    ],
  ),
  TaskTemplate(
    id: 'move-in',
    title: 'Move-In Workflow',
    description: 'Seamless onboarding process for new tenants.',
    icon: Icons.login_rounded,
    color: Colors.green,
    category: 'Property Inspection',
    steps: [
      'Finalize lease agreement',
      'Collect security deposit',
      'Collect first month rent',
      'Set up utility accounts',
      'Conduct move-in inspection',
      'Hand over keys',
      'Provide welcome pack',
      'Confirm emergency contacts',
      'Create tenant profile in system',
    ],
  ),
  TaskTemplate(
    id: 'periodic-inspection',
    title: 'Periodic Inspection',
    description: 'Routine property condition check and maintenance audit.',
    icon: Icons.fact_check_rounded,
    color: Colors.blue,
    category: 'Property Inspection',
    steps: [
      'Schedule inspection with tenant',
      'Send inspection notice',
      'Review previous inspection report',
      'Inspect exterior and grounds',
      'Inspect interior rooms',
      'Check smoke alarms & safety devices',
      'Identify maintenance needs',
      'Take representative photos',
      'Send report to owner',
    ],
  ),
  TaskTemplate(
    id: 'maintenance-request',
    title: 'Maintenance Request',
    description: 'Standard procedure for handling repair requests.',
    icon: Icons.build_rounded,
    color: Colors.red,
    category: 'Maintenance',
    steps: [
      'Receive and log request',
      'Assess urgency and scope',
      'Get owner approval if required',
      'Assign contractor',
      'Schedule repair with tenant',
      'Verify completion of work',
      'Process contractor invoice',
      'Update maintenance log',
      'Follow up with tenant',
    ],
  ),
  TaskTemplate(
    id: 'lease-onboarding',
    title: 'Lease Onboarding',
    description: 'Steps to prepare and sign a new lease agreement.',
    icon: Icons.assignment_ind_rounded,
    color: Colors.purple,
    category: 'Leasing',
    steps: [
      'Screen applicant documents',
      'Run credit & background check',
      'Verify employment/income',
      'Check rental references',
      'Prepare lease documents',
      'Send for digital signature',
      'Countersign lease',
      'Store signed documents',
    ],
  ),
  TaskTemplate(
    id: 'lease-renewal',
    title: 'Lease Renewal',
    description: 'Managing the process of extending an existing lease.',
    icon: Icons.autorenew_rounded,
    color: Colors.teal,
    category: 'Leasing',
    steps: [
      'Review market rent levels',
      'Consult owner on renewal terms',
      'Send renewal offer to tenant (90 days out)',
      'Negotiate terms if necessary',
      'Prepare renewal agreement',
      'Get signatures from all parties',
      'Update lease end date in system',
    ],
  ),
];

