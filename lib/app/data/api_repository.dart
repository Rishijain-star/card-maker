import '../services/local_storage_services/local_storage_services.dart';
import '../services/secure_token_service/secure_token_service.dart';
import 'api_client.dart';

class ApiRepository {
  static final prefs = LocalStorageService.sharedPreferences!;
  static Future<void> _persistUser(Map<String, dynamic> user) async {
    final fullName = '${user['name'] ?? ''}'.trim();
    final parts = fullName
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final storage = LocalStorageService();
    await storage.setUserId('${user['id'] ?? ''}');
    await storage.setUserName(fullName);
    await storage.setFirstName(firstName);
    await storage.setLastName(lastName);
    await storage.setEmailId('${user['email'] ?? ''}'.trim().toLowerCase());

    if (user['is_premium'] != null) {
      await storage.setIsPremium(user['is_premium'] == true);
    }
    if (user['premium_plan'] != null) {
      await storage.setPremiumPlan('${user['premium_plan']}');
    }
    if (user['premium_expires_at'] != null) {
      await storage.setPremiumExpiresAt('${user['premium_expires_at']}');
    }
    if (user['save_limit'] != null) {
      final limit = (user['save_limit'] as num).toInt();
      await storage.setAccountSaveLimit(limit);
    }
    if (user['saved_cards_count'] != null) {
      final cnt = (user['saved_cards_count'] as num).toInt();
      await storage.setAccountSavedCardsCount(cnt);
    }
    if (user['remaining_capacity'] != null) {
      final rem = (user['remaining_capacity'] as num).toInt();
      await storage.setAccountRemainingCapacity(rem);
    }
  }
  // Auth Apis ********************************************************************************************************************************************************************************

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final response = await ApiClient().postRequest(
        endPoint: "auth/login",
        body: {"email": cleanEmail, "password": password},
        includeAuth: false,
      );

      if (response != null &&
          response['token'] != null &&
          response['user'] != null) {
        final token = '${response['token']}';
        final user = response['user'] as Map<String, dynamic>;
        await SecureTokenService().setAuthToken(token);
        await LocalStorageService().setAuthToken(token);
        await _persistUser(user);
        await LocalStorageService().setIsOnboardingCompleted(false);
        return true;
      }
    } catch (e, s) {
      print("login error: $e\n$s");
    }
    return false;
  }

  static Future<bool> socialLogin({
    required String email,
    required String name,
    required String provider,
    String? providerId,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final response = await ApiClient().postRequest(
        endPoint: "auth/social",
        body: {
          "email": cleanEmail,
          "name": name.trim(),
          "provider": provider,
          "device_id": providerId,
        },
        includeAuth: false,
      );

      if (response != null &&
          response['token'] != null &&
          response['user'] != null) {
        final token = '${response['token']}';
        final user = response['user'] as Map<String, dynamic>;
        await SecureTokenService().setAuthToken(token);
        await LocalStorageService().setAuthToken(token);
        await _persistUser(user);
        await LocalStorageService().setIsOnboardingCompleted(false);
        return true;
      }
    } catch (e, s) {
      print("socialLogin error: $e\n$s");
    }
    return false;
  }

  /// Returns [ok] and a user-visible [message] (empty when successful).
  static Future<({bool ok, String message})> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final response = await ApiClient().postRequest(
        endPoint: "auth/register",
        body: {"name": name.trim(), "email": cleanEmail, "password": password},
        includeAuth: false,
      );

      if (response != null &&
          response['token'] != null &&
          response['user'] != null) {
        final token = '${response['token']}';
        final user = response['user'] as Map<String, dynamic>;
        await SecureTokenService().setAuthToken(token);
        await LocalStorageService().setAuthToken(token);
        await _persistUser(user);
        return (ok: true, message: '');
      }

      if (response != null && response['account_exists'] == true) {
        return (ok: false, message: 'An account with this email already exists. Please log in.');
      }

      final err = _registerErrorMessage(response);
      return (ok: false, message: err);
    } catch (e, s) {
      print("register error: $e\n$s");
      return (ok: false, message: 'Something went wrong. Check your connection.');
    }
  }

  static String _registerErrorMessage(Map<String, dynamic>? r) {
    if (r == null) {
      return 'Could not reach the server. Check your connection and API URL.';
    }
    final top = r['message']?.toString().trim();
    final errs = r['errors'];
    if (errs is Map) {
      final lines = <String>[];
      for (final e in errs.entries) {
        final v = e.value;
        if (v is List && v.isNotEmpty) {
          lines.add(v.first.toString());
        } else if (v != null) {
          lines.add(v.toString());
        }
      }
      if (lines.isNotEmpty) {
        return lines.join('\n');
      }
    }
    if (top != null && top.isNotEmpty) return top;
    return 'Sign up failed. Please check your details.';
  }

  static Future<bool> forgotPassword({required String email}) async {
    try {
      final response = await ApiClient().postRequest(
        endPoint: "auth/forgot-password",
        body: {"email": email},
        includeAuth: false,
      );
      return response != null;
    } catch (e, s) {
      print("forgotPassword error: $e\n$s");
      return false;
    }
  }

  static Future<bool> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await ApiClient().postRequest(
        endPoint: "auth/reset-password",
        body: {
          "token": token,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
        includeAuth: false,
      );
      return response != null;
    } catch (e, s) {
      print("resetPassword error: $e\n$s");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> me() async {
    try {
      final mePayload = await ApiClient().getRequest(endPoint: "auth/me");
      if (mePayload != null && mePayload['user'] is Map<String, dynamic>) {
        await _persistUser(mePayload['user'] as Map<String, dynamic>);
      }
      return mePayload;
    } catch (e, s) {
      print("me error: $e\n$s");
      return null;
    }
  }

  static String _buildQuery(Map<String, dynamic> query) {
    final pairs = <String>[];
    query.forEach((key, value) {
      if (value == null) return;
      final v = "$value";
      if (v.isEmpty) return;
      pairs.add(
        "${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(v)}",
      );
    });
    return pairs.isEmpty ? "" : "?${pairs.join("&")}";
  }

  static Future<Map<String, dynamic>?> listResource({
    required String resource,
    int perPage = 12,
    int page = 1,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final query = <String, dynamic>{
        "per_page": perPage,
        "page": page,
        ...(filters ?? const {}),
      };
      return await ApiClient().getRequest(
        endPoint: "$resource${_buildQuery(query)}",
      );
    } catch (e, s) {
      print("listResource($resource) error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getOne({
    required String resource,
    required dynamic id,
  }) async {
    try {
      return await ApiClient().getRequest(endPoint: "$resource/$id");
    } catch (e, s) {
      print("getOne($resource) error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> create({
    required String resource,
    required Map<String, dynamic> body,
  }) async {
    try {
      return await ApiClient().postRequest(endPoint: resource, body: body);
    } catch (e, s) {
      print("create($resource) error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> update({
    required String resource,
    required dynamic id,
    required Map<String, dynamic> body,
  }) async {
    try {
      return await ApiClient().putRequest(
        endPoint: "$resource/$id",
        body: body,
      );
    } catch (e, s) {
      print("update($resource) error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> remove({
    required String resource,
    required dynamic id,
  }) async {
    try {
      return await ApiClient().deleteRequest(
        endPoint: "$resource/$id",
        body: {},
      );
    } catch (e, s) {
      print("remove($resource) error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> listUpcomingTasks({
    int perPage = 50,
    int page = 1,
  }) async {
    try {
      return await ApiClient().getRequest(
        endPoint:
            "tasks/upcoming${_buildQuery({"per_page": perPage, "page": page})}",
      );
    } catch (e, s) {
      print("listUpcomingTasks error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> listProjectMembers({
    required String projectId,
  }) async {
    try {
      return await ApiClient().getRequest(
        endPoint: "projects/$projectId/members",
      );
    } catch (e, s) {
      print("listProjectMembers error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> addProjectMember({
    required String projectId,
    required String userId,
    String role = "member",
  }) async {
    try {
      return await ApiClient().postRequest(
        endPoint: "projects/$projectId/members",
        body: {"user_id": int.tryParse(userId) ?? userId, "role": role},
      );
    } catch (e, s) {
      print("addProjectMember error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createTaskComment({
    required String taskId,
    required String body,
  }) async {
    try {
      return await ApiClient().postRequest(
        endPoint: "tasks/$taskId/comments",
        body: {"body": body},
      );
    } catch (e, s) {
      print("createTaskComment error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createTask({
    required String title,
    String? notes,
    String? dueDate,
    String? priority,
    String? status,
    String? projectId,
    String? assignedUserId,
    String? parentTaskId,
  }) async {
    final body = <String, dynamic>{
      "title": title,
      if (notes != null && notes.isNotEmpty) "notes": notes,
      if (dueDate != null && dueDate.isNotEmpty) "due_date": dueDate,
      if (priority != null && priority.isNotEmpty) "priority": priority,
      if (status != null && status.isNotEmpty) "status": status,
      if (projectId != null && projectId.isNotEmpty)
        "project_id": int.tryParse(projectId) ?? projectId,
      if (assignedUserId != null && assignedUserId.isNotEmpty)
        "assigned_user_id": int.tryParse(assignedUserId) ?? assignedUserId,
      if (parentTaskId != null && parentTaskId.isNotEmpty)
        "parent_task_id": int.tryParse(parentTaskId) ?? parentTaskId,
    };
    try {
      return await ApiClient().postRequest(endPoint: "tasks", body: body);
    } catch (e, s) {
      print("createTask error: $e\n$s");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> uploadTaskAttachment({
    required String taskId,
    required String filePath,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      return await ApiClient().uploadFileRequest(
        endPoint: "tasks/$taskId/attachments",
        filePath: filePath,
        onSendProgress: onSendProgress,
      );
    } catch (e, s) {
      print("uploadTaskAttachment error: $e\n$s");
      return null;
    }
  }

  // ===================== RAZORPAY PAYMENT APIS =====================

  /// Create Razorpay order on Laravel backend.
  static Future<Map<String, dynamic>?> createPaymentOrder({
    required String packageId,
  }) async {
    try {
      return await ApiClient().postRequest(
        endPoint: "payments/create-order",
        body: {"package_id": packageId},
      );
    } catch (e, s) {
      print("createPaymentOrder error: $e\n$s");
      return null;
    }
  }

  /// Verify payment signature on Laravel backend.
  static Future<Map<String, dynamic>?> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      return await ApiClient().postRequest(
        endPoint: "payments/verify",
        body: {
          "razorpay_order_id": orderId,
          "razorpay_payment_id": paymentId,
          "razorpay_signature": signature,
        },
      );
    } catch (e, s) {
      print("verifyPayment error: $e\n$s");
      return null;
    }
  }

  /// Fetch live premium / subscription status from Laravel backend.
  static Future<Map<String, dynamic>?> getPaymentStatus() async {
    try {
      return await ApiClient().getRequest(endPoint: "payments/status");
    } catch (e, s) {
      print("getPaymentStatus error: $e\n$s");
      return null;
    }
  }

  // ===================== PRODUCT CART ORDER APIS =====================

  /// Create Razorpay order for product cart checkout.
  static Future<Map<String, dynamic>?> createProductOrder({
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      return await ApiClient().postRequest(
        endPoint: "orders/create-payment",
        body: {"items": items},
      );
    } catch (e, s) {
      print("createProductOrder error: $e\n$s");
      return null;
    }
  }

  /// Verify product order payment signature on Laravel backend.
  static Future<Map<String, dynamic>?> verifyProductOrderPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      return await ApiClient().postRequest(
        endPoint: "orders/verify-payment",
        body: {
          "razorpay_order_id": orderId,
          "razorpay_payment_id": paymentId,
          "razorpay_signature": signature,
        },
      );
    } catch (e, s) {
      print("verifyProductOrderPayment error: $e\n$s");
      return null;
    }
  }

  /// Sync a saved card design (with base64 images) to Laravel backend
  static Future<Map<String, dynamic>?> syncSavedCard({
    required String clientPairId,
    required String title,
    required String studentName,
    required String instituteName,
    required String service,
    required String templateName,
    required String fontFamily,
    String? frontImageBase64,
    String? backImageBase64,
    int? savedAtMs,
  }) async {
    try {
      return await ApiClient().postRequest(
        endPoint: "cards/sync",
        body: {
          "client_pair_id": clientPairId,
          "title": title,
          "student_name": studentName,
          "institute_name": instituteName,
          "service": service,
          "template_name": templateName,
          "font_family": fontFamily,
          if (frontImageBase64 != null) "front_image_base64": frontImageBase64,
          if (backImageBase64 != null) "back_image_base64": backImageBase64,
          if (savedAtMs != null) "saved_at_ms": savedAtMs,
        },
      );
    } catch (e, s) {
      print("syncSavedCard error: $e\n$s");
      return null;
    }
  }

  /// Fetch user's product order history.
  static Future<Map<String, dynamic>?> fetchOrderHistory() async {
    try {
      return await ApiClient().getRequest(endPoint: "orders/history");
    } catch (e, s) {
      print("fetchOrderHistory error: $e\n$s");
      return null;
    }
  }

  /// Fetch all saved cards belonging to the authenticated account from server.
  static Future<List<Map<String, dynamic>>?> fetchSavedCards() async {
    try {
      final res = await ApiClient().getRequest(endPoint: "cards");
      if (res != null && res['status'] == true && res['data'] is List) {
        if (res['meta'] != null && res['meta'] is Map) {
          final meta = res['meta'] as Map;
          final storage = LocalStorageService();
          if (meta['save_limit'] != null) {
            await storage.setAccountSaveLimit((meta['save_limit'] as num).toInt());
          }
          if (meta['total_saved'] != null) {
            await storage.setAccountSavedCardsCount((meta['total_saved'] as num).toInt());
          }
          if (meta['remaining_capacity'] != null) {
            await storage.setAccountRemainingCapacity((meta['remaining_capacity'] as num).toInt());
          }
        }
        return List<Map<String, dynamic>>.from(res['data'] as List);
      }
    } catch (e, s) {
      print("fetchSavedCards error: $e\n$s");
    }
    return null;
  }

  /// Delete a saved card on the backend to free account quota.
  static Future<bool> deleteSavedCard(String idOrPairId) async {
    try {
      final res = await ApiClient().deleteRequest(
        endPoint: "cards/$idOrPairId",
        body: {},
      );
      return res != null && res['status'] == true;
    } catch (e, s) {
      print("deleteSavedCard error: $e\n$s");
      return false;
    }
  }

  /// Invalidate device session on backend and clear local session.
  static Future<void> logout() async {
    try {
      await ApiClient().postRequest(endPoint: "auth/logout", body: {});
    } catch (_) {}
    await LocalStorageService().logout();
  }
}
