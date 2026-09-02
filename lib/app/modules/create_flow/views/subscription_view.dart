import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/app_product.dart';
import '../../../data/api_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../services/razorpay_payment_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/create_flow_controller.dart';
import '../controllers/products_controller.dart';

const String _kHeaderBg =
    'imagesss/ChatGPT Image Jun 2, 2026, 01_02_17 PM.png';

const Color _kPrimaryBlue = Color(0xFF1E88E5);
const Color _kText = Color(0xFF0F172A);
const Color _kSubText = Color(0xFF475569);
const Color _kBorder = Color(0xFFE2E8F0);

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView>
    with WidgetsBindingObserver {
  final ProductsController _productsController = Get.find<ProductsController>();

  int _selectedTab = 2;
  AppProduct? _focusedProduct;
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';
  DateTime _selectedDate = DateTime.now();
  final Map<String, String> _selectedSizes = <String, String>{};

  List<String> get _categories {
    final list = <String>['All'];
    for (final p in _productsController.products) {
      final cat = p.category.trim();
      if (cat.isNotEmpty && !list.contains(cat)) {
        list.add(cat);
      }
    }
    return list;
  }

  final List<_OrderHistoryItem> _history = const [
    _OrderHistoryItem(
      orderId: 'ORD-1001',
      title: 'ID CARDS',
      qty: 50,
      amount: 1250,
      status: 'Delivered',
      dateLabel: '02 Jun 2026',
    ),
    _OrderHistoryItem(
      orderId: 'ORD-0985',
      title: 'LANYARDS',
      qty: 20,
      amount: 600,
      status: 'Delivered',
      dateLabel: '27 May 2026',
    ),
  ];

  final List<_OrderHistoryItem> _liveHistory = [];
  final RazorpayPaymentService _paymentService = RazorpayPaymentService();
  bool _isProcessingPayment = false;

  final List<_CartDesignEntry> _cartEntries = [];
  final Set<String> _removedDesignIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _productsController.fetchProducts(force: true);
    Get.find<CreateFlowController>().syncSavedCardsFromServer();
    _paymentService.init(
      onSuccess: _onProductPaymentSuccess,
      onFailure: _onProductPaymentFailure,
    );
    _loadOrderHistory();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchCtrl.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isProcessingPayment) {
      setState(() => _isProcessingPayment = false);
    }
  }

  Future<void> _loadOrderHistory() async {
    final res = await ApiRepository.fetchOrderHistory();
    if (res != null && res['status'] == true && res['data'] is List) {
      final items = (res['data'] as List).map((raw) {
        final item = raw as Map<String, dynamic>;
        return _OrderHistoryItem(
          orderId: item['order_id']?.toString() ?? 'ORD-0000',
          title: item['title']?.toString() ?? 'ORDER',
          qty: (item['qty'] as num?)?.toInt() ?? 1,
          amount: (item['amount'] as num?)?.toInt() ?? 0,
          status: item['status']?.toString() ?? 'Paid',
          dateLabel: item['date']?.toString() ?? '',
        );
      }).toList();
      if (mounted) {
        setState(() {
          _liveHistory.clear();
          _liveHistory.addAll(items);
        });
      }
    }
  }

  Future<void> _onProductPaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;

    final orderId = response.orderId ?? '';
    final paymentId = response.paymentId ?? '';
    final signature = response.signature ?? '';

    if (orderId.isEmpty || paymentId.isEmpty || signature.isEmpty) {
      setState(() => _isProcessingPayment = false);
      Get.snackbar(
        'Verification Incomplete',
        'Could not verify payment details with server.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
      );
      return;
    }

    final verifyRes = await ApiRepository.verifyProductOrderPayment(
      orderId: orderId,
      paymentId: paymentId,
      signature: signature,
    );

    if (!mounted) return;
    setState(() => _isProcessingPayment = false);

    if (verifyRes != null && verifyRes['status'] == true) {
      final data = verifyRes['data'] as Map<String, dynamic>?;
      final orderNumber = data?['order_number']?.toString() ?? 'Order';

      // Clear cart ONLY after successful backend verification
      _clearCart();
      await _loadOrderHistory();

      if (!mounted) return;

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      setState(() {
        _focusedProduct = null;
        _selectedTab = 1; // Switch to Orders tab
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment verified! $orderNumber placed successfully.',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      final msg = verifyRes?['message']?.toString() ??
          'Payment verification failed. Please contact support.';
      Get.snackbar(
        'Order Verification Failed',
        msg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
      );
    }
  }

  void _onProductPaymentFailure(PaymentFailureResponse response) {
    if (!mounted) return;
    setState(() => _isProcessingPayment = false);
    final msg = response.message ?? 'Payment was cancelled or failed.';
    Get.snackbar(
      'Payment Failed',
      msg,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFDC2626),
      colorText: Colors.white,
    );
  }

  int get _cartCount => _cartEntries.length;

  int get _cartGrandTotal =>
      _cartEntries.fold<int>(0, (sum, e) => sum + e.product.unitPrice);

  List<_CartDesignEntry> _cartEntriesForProduct(AppProduct product) =>
      _cartEntries.where((e) => e.product.id == product.id).toList();

  void _removeFromCart(String id) {
    setState(() {
      _cartEntries.removeWhere((e) => e.id == id);
      _removedDesignIds.add(id);
    });
  }

  void _clearCart() {
    setState(() {
      _cartEntries.clear();
      _removedDesignIds.clear();
    });
  }

  int _savedCountFor(AppProduct item) {
    final flow = Get.find<CreateFlowController>();
    return flow.savedDesignsForProduct(item, onDate: _selectedDate).length;
  }

  List<_SavedDesign> _savedDesignsFor(AppProduct item) {
    final flow = Get.find<CreateFlowController>();
    final designs = flow.savedDesignsForProduct(item, onDate: _selectedDate);
    return designs
        .map(
          (d) => _SavedDesign(
            id: d.templatePairId,
            title: d.productListTitle,
            subtitle: '${d.templateName} · Saved on $_selectedDateLabel',
            instituteName: d.instituteName,
            studentName: d.studentName,
            frontImagePath: d.frontImagePath,
            backImagePath: d.backImagePath,
          ),
        )
        .toList();
  }

  void _openProductDesigns(AppProduct item) {
    final flow = Get.find<CreateFlowController>();
    var designs = _savedDesignsFor(item);

    if (designs.isEmpty) {
      final allProductDesigns = flow.savedDesigns
          .where((d) => item.matchesSavedDesignService(d.service))
          .toList();

      if (allProductDesigns.isNotEmpty) {
        final mostRecent = allProductDesigns.first;
        final designDate =
            DateTime.fromMillisecondsSinceEpoch(mostRecent.savedAtMs);
        setState(() {
          _selectedDate = designDate;
        });
        designs = _savedDesignsFor(item);
      }
    }

    if (designs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No saved designs for $_selectedDateLabel. Save a template first.',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      _focusedProduct = item;
      _selectedTab = 5;
      final defaultSize =
          item.supportsSizes && item.sizes.isNotEmpty ? item.sizes.first : null;
      for (final design in designs) {
        if (_removedDesignIds.contains(design.id)) continue;
        if (_cartEntries.any((e) => e.id == design.id)) continue;
        if (defaultSize != null) {
          _selectedSizes[design.id] = defaultSize;
        }
        _cartEntries.add(_CartDesignEntry(
          id: design.id,
          product: item,
          design: design,
          selectedSize: defaultSize,
        ));
      }
    });
  }

  void _backToServices() {
    setState(() {
      _focusedProduct = null;
      _selectedTab = 2;
    });
  }

  final Map<int, int> _productQuantities = {};

  int _getQuantity(int productId) => _productQuantities[productId] ?? 1;

  void _setQuantity(int productId, int qty) {
    setState(() {
      _productQuantities[productId] = qty.clamp(1, 9999);
    });
  }

  void _openDirectProductOrderSheet(AppProduct product, int initialQty) {
    final storage = LocalStorageService();
    if (!storage.isLoggedIn()) {
      Get.snackbar(
        'Login Required',
        'Please login to place an order.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF2563EB),
        colorText: Colors.white,
      );
      Get.toNamed(Routes.LOGIN);
      return;
    }

    int currentQty = initialQty.clamp(1, 9999);
    String? selectedSize = product.supportsSizes && product.sizes.isNotEmpty
        ? product.sizes.first
        : null;
    final notesController = TextEditingController();
    bool isProcessing = false;
    File? selectedLogoFile;
    String? selectedLogoBase64;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final lineTotal = product.price * currentQty;

            Future<void> pickLogo(ImageSource source) async {
              try {
                final picker = ImagePicker();
                final picked =
                    await picker.pickImage(source: source, imageQuality: 85);
                if (picked != null) {
                  final file = File(picked.path);
                  final bytes = await file.readAsBytes();
                  final b64 = 'data:image/png;base64,${base64Encode(bytes)}';
                  setModalState(() {
                    selectedLogoFile = file;
                    selectedLogoBase64 = b64;
                  });
                }
              } catch (e) {
                Get.snackbar('Image Picker Notice', 'Could not pick image: $e');
              }
            }

            Future<void> handlePayNow() async {
              if (isProcessing) return;

              setModalState(() => isProcessing = true);
              setState(() => _isProcessingPayment = true);

              final orderNote = notesController.text.trim();
              final items = <Map<String, dynamic>>[
                {
                  'product_id': product.id,
                  'quantity': currentQty,
                  'size': selectedSize ?? 'Standard',
                  'design_title':
                      orderNote.isNotEmpty ? orderNote : product.name,
                  if (selectedLogoBase64 != null)
                    'front_image': selectedLogoBase64,
                }
              ];

              final orderRes =
                  await ApiRepository.createProductOrder(items: items);

              if (orderRes == null || orderRes['status'] != true) {
                setModalState(() => isProcessing = false);
                setState(() => _isProcessingPayment = false);
                final errorMsg = orderRes?['message']?.toString() ??
                    'Could not connect to payment server. Please check your connection.';
                Get.snackbar(
                  'Order Creation Failed',
                  errorMsg,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: const Color(0xFFDC2626),
                  colorText: Colors.white,
                );
                return;
              }

              final data = orderRes['data'] as Map<String, dynamic>;
              final orderId = '${data['order_id'] ?? ''}';
              final amount = (data['amount'] as num?)?.toInt() ?? 0;
              final keyId = '${data['key_id'] ?? ''}';
              final orderNumber = '${data['order_number'] ?? ''}';

              final email = storage.getEmailId();
              final phone = storage.getUserPhone();

              if (sheetContext.mounted && Navigator.canPop(sheetContext)) {
                Navigator.pop(sheetContext);
              }
              setModalState(() => isProcessing = false);
              setState(() => _isProcessingPayment = false);

              _paymentService.openCheckout(
                keyId: keyId,
                orderId: orderId,
                amount: amount,
                planId: 'product_direct_order',
                planTitle: 'Order $orderNumber (${product.name})',
                userEmail: email,
                userPhone: phone,
              );
            }

            final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;

            return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: product.accent.withValues(alpha: 0.12),
                            border: Border.all(
                              color: product.accent.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: product.imageUrl != null &&
                                  product.imageUrl!.isNotEmpty
                              ? Image.network(
                                  product.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    product.icon,
                                    color: product.accent,
                                    size: 26,
                                  ),
                                )
                              : Icon(
                                  product.icon,
                                  color: product.accent,
                                  size: 26,
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: GoogleFonts.poppins(
                                  color: _kText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '₹${product.price} / piece',
                                style: GoogleFonts.poppins(
                                  color: _kPrimaryBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: _kSubText),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: _kBorder),
                    const SizedBox(height: 16),

                    if (product.supportsSizes && product.sizes.isNotEmpty) ...[
                      Text(
                        'Select Size:',
                        style: GoogleFonts.poppins(
                          color: _kText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: product.sizes.map((size) {
                          final isSelected = selectedSize == size;
                          return ChoiceChip(
                            label: Text(size),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() => selectedSize = size);
                              }
                            },
                            selectedColor: _kPrimaryBlue,
                            backgroundColor: const Color(0xFFF1F5F9),
                            labelStyle: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : _kText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity:',
                          style: GoogleFonts.poppins(
                            color: _kText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: Row(
                            children: [
                              _QtyButton(
                                icon: Icons.remove_rounded,
                                onTap: currentQty > 1
                                    ? () {
                                        setModalState(() {
                                          currentQty--;
                                          _setQuantity(product.id, currentQty);
                                        });
                                      }
                                    : null,
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 44),
                                alignment: Alignment.center,
                                child: Text(
                                  '$currentQty',
                                  style: GoogleFonts.poppins(
                                    color: _kText,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              _QtyButton(
                                icon: Icons.add_rounded,
                                onTap: () {
                                  setModalState(() {
                                    currentQty++;
                                    _setQuantity(product.id, currentQty);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Order Details / Instructions (Optional):',
                      style: GoogleFonts.poppins(
                        color: _kText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Enter your details, instructions or notes here and upload your logo or image',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _kBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: _kPrimaryBlue, width: 1.5),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: _kText,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Logo / Reference Image Upload Section
                    Text(
                      'Upload Logo / Image (Optional):',
                      style: GoogleFonts.poppins(
                        color: _kText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (selectedLogoFile == null)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: _kBorder),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: () =>
                                  pickLogo(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_outlined,
                                  size: 18, color: _kPrimaryBlue),
                              label: Text(
                                'Gallery',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _kText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: _kBorder),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: () =>
                                  pickLogo(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt_outlined,
                                  size: 18, color: _kPrimaryBlue),
                              label: Text(
                                'Camera',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _kText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                selectedLogoFile!,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          size: 15, color: Color(0xFF16A34A)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Logo Attached',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF16A34A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    selectedLogoFile!.path.split('/').last,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: _kSubText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: Color(0xFFEF4444)),
                              onPressed: () {
                                setModalState(() {
                                  selectedLogoFile = null;
                                  selectedLogoBase64 = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _kBorder),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price (₹${product.price} × $currentQty):',
                                style: GoogleFonts.poppins(
                                  color: _kSubText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '₹$lineTotal',
                                style: GoogleFonts.poppins(
                                  color: _kText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1, color: _kBorder),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total to Pay:',
                                style: GoogleFonts.poppins(
                                  color: _kText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '₹$lineTotal',
                                style: GoogleFonts.poppins(
                                  color: _kPrimaryBlue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPrimaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: isProcessing ? null : handlePayNow,
                        child: isProcessing
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.payment_rounded, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Pay Now · ₹$lineTotal',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPaymentSheet() {
    if (_cartEntries.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void refreshSheet() => setModalState(() {});

            void removeItem(String id) {
              _removeFromCart(id);
              refreshSheet();
              if (_cartEntries.isEmpty) {
                Navigator.pop(sheetContext);
              }
            }

            Future<void> handlePay() async {
              if (_isProcessingPayment || _cartEntries.isEmpty) return;

              setModalState(() => _isProcessingPayment = true);
              setState(() => _isProcessingPayment = true);

              final items = <Map<String, dynamic>>[];
              for (final e in _cartEntries) {
                String? frontBase64;
                String? backBase64;

                if (e.design.frontImagePath.isNotEmpty) {
                  final f = File(e.design.frontImagePath);
                  if (f.existsSync()) {
                    try {
                      final bytes = await f.readAsBytes();
                      frontBase64 = base64Encode(bytes);
                    } catch (_) {}
                  }
                }

                if (e.design.backImagePath.isNotEmpty) {
                  final b = File(e.design.backImagePath);
                  if (b.existsSync()) {
                    try {
                      final bytes = await b.readAsBytes();
                      backBase64 = base64Encode(bytes);
                    } catch (_) {}
                  }
                }

                items.add(<String, dynamic>{
                  'product_id': e.product.id,
                  'quantity': 1,
                  'size': e.selectedSize ?? 'Standard',
                  'design_title': e.design.title,
                  'student_name': e.design.studentName,
                  'institute_name': e.design.instituteName,
                  'front_image': frontBase64 ?? e.design.frontImagePath,
                  'back_image': backBase64 ?? e.design.backImagePath,
                });
              }

              final orderRes = await ApiRepository.createProductOrder(items: items);

              if (!mounted) return;

              if (orderRes == null ||
                  orderRes['status'] != true ||
                  orderRes['data'] == null) {
                setModalState(() => _isProcessingPayment = false);
                setState(() => _isProcessingPayment = false);
                final errorMsg = orderRes?['message']?.toString() ??
                    'Could not connect to payment server. Please check your connection.';
                Get.snackbar(
                  'Order Creation Failed',
                  errorMsg,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: const Color(0xFFDC2626),
                  colorText: Colors.white,
                );
                return;
              }

              final data = orderRes['data'] as Map<String, dynamic>;
              final orderId = '${data['order_id'] ?? ''}';
              final amount = (data['amount'] as num?)?.toInt() ?? 0;
              final keyId = '${data['key_id'] ?? ''}';
              final orderNumber = '${data['order_number'] ?? ''}';

              final storage = LocalStorageService();
              final email = storage.getEmailId();
              final phone = storage.getUserPhone();

              // Close the bottom sheet BEFORE opening native Razorpay checkout
              // to prevent Android modal overlay freeze on back navigation from UPI apps
              if (sheetContext.mounted && Navigator.canPop(sheetContext)) {
                Navigator.pop(sheetContext);
              }
              setModalState(() => _isProcessingPayment = false);
              setState(() => _isProcessingPayment = false);

              // Open Razorpay Checkout with server-returned order_id & key_id
              _paymentService.openCheckout(
                keyId: keyId,
                orderId: orderId,
                amount: amount,
                planId: 'product_order',
                planTitle: 'Order $orderNumber',
                userEmail: email,
                userPhone: phone,
              );
            }

            return _PaymentSheet(
              entries: _cartEntries,
              total: _cartGrandTotal,
              isPaying: _isProcessingPayment,
              onRemove: removeItem,
              onClose: () => Navigator.pop(sheetContext),
              onPay: handlePay,
            );
          },
        );
      },
    );
  }

  List<AppProduct> get _visibleProducts {
    final query = _searchCtrl.text.trim().toLowerCase();
    List<AppProduct> all = _productsController.products.toList();
    if (_selectedCategory != 'All') {
      all = all
          .where((p) =>
              p.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }
    if (query.isEmpty) return all;
    return all
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query))
        .toList();
  }

  String get _headerTitle {
    if (_selectedTab == 5 && _focusedProduct != null) {
      return _focusedProduct!.name;
    }
    switch (_selectedTab) {
      case 1:
        return 'Your Orders';
      case 3:
        return 'Your Cart';
      case 4:
        return 'Your Profile';
      default:
        return 'Place Your Order';
    }
  }

  String get _headerSubtitle {
    if (_selectedTab == 5 && _focusedProduct != null) {
      final inCart = _cartEntriesForProduct(_focusedProduct!).length;
      return '$_selectedDateLabel · $inCart in cart';
    }
    switch (_selectedTab) {
      case 1:
        return 'See your new and previous orders';
      case 3:
        return _cartCount == 0
            ? 'Your cart is empty'
            : '$_cartCount items · ₹$_cartGrandTotal';
      case 4:
        return 'Registered details from your account';
      default:
        return 'Pick a date to view saved designs';
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _kPrimaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _kText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _cartEntries.clear();
        _removedDesignIds.clear();
        _focusedProduct = null;
        if (_selectedTab == 5) _selectedTab = 2;
      });
    }
  }

  String get _selectedDateLabel {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final d = _selectedDate;
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final width = MediaQuery.sizeOf(context).width;
    final headerHeight = width < 380 ? 210.0 : 228.0;

    return Scaffold(
      backgroundColor: _kPrimaryBlue,
      body: Column(
        children: [
          SizedBox(
            height: headerHeight + topInset,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: Image.asset(_kHeaderBg, fit: BoxFit.cover)),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _kPrimaryBlue.withValues(alpha: 0.55),
                          _kPrimaryBlue.withValues(alpha: 0.35),
                          _kPrimaryBlue.withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  top: topInset + 6,
                  child: Row(
                    children: [
                      _TopIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          if (_selectedTab == 5) {
                            _backToServices();
                          } else {
                            Get.back<void>();
                          }
                        },
                      ),
                      const Spacer(),
                      _TopIconButton(icon: Icons.notifications_none_rounded, onTap: () {}),
                      const SizedBox(width: 8),
                      _TopIconButton(
                        icon: Icons.shopping_cart_outlined,
                        onTap: () => setState(() => _selectedTab = 3),
                        badgeCount: _cartCount,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _HeaderIllustration(),
                      const SizedBox(height: 8),
                      Text(
                        _headerTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: (width * 0.068).clamp(24.0, 34.0),
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _headerSubtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: (width * 0.035).clamp(12.0, 14.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: Column(
                    children: [
                      if (_selectedTab == 2) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                          child: _DateFilterBar(
                            dateLabel: _selectedDateLabel,
                            onPickDate: _pickDate,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: _SearchBar(controller: _searchCtrl, onChanged: (_) => setState(() {})),
                        ),
                        // Horizontal Categories Filter
                        Obx(() {
                          final cats = _categories;
                          if (cats.length <= 1) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SizedBox(
                              height: 38,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: cats.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, idx) {
                                  final cat = cats[idx];
                                  final isSelected =
                                      _selectedCategory.toLowerCase() == cat.toLowerCase();
                                  return _CategoryFilterChip(
                                    label: cat,
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = cat;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                        Expanded(
                          child: Obx(
                            () {
                              if (_productsController.isLoading.value &&
                                  _productsController.products.isEmpty) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: _kPrimaryBlue,
                                  ),
                                );
                              }

                              if (_productsController.errorMessage.value.isNotEmpty &&
                                  _productsController.products.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _productsController.errorMessage.value,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: _kSubText,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _productsController.fetchProducts(force: true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _kPrimaryBlue,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final items = _visibleProducts;
                              if (items.isEmpty) {
                                return const _EmptyBox(
                                  label: 'No products yet. Add products from admin panel.',
                                );
                              }

                              return RefreshIndicator(
                                color: _kPrimaryBlue,
                                onRefresh: () async {
                                  await Future.wait([
                                    _productsController.fetchProducts(force: true),
                                    Get.find<CreateFlowController>().syncSavedCardsFromServer(),
                                  ]);
                                },
                                child: ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    final qty = _getQuantity(item.id);
                                    final savedCount = _savedCountFor(item);
                                    return _ProductRowCard(
                                      item: item,
                                      quantity: qty,
                                      savedCount: savedCount,
                                      onQuantityChanged: (newQty) {
                                        _setQuantity(item.id, newQty);
                                      },
                                      onOrderNow: () {
                                        _openDirectProductOrderSheet(item, qty);
                                      },
                                      onTapCard: () {
                                        _openProductDesigns(item);
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ] else if (_selectedTab == 5 && _focusedProduct != null) ...[
                        Expanded(
                          child: _ProductSavedTab(
                            product: _focusedProduct!,
                            dateLabel: _selectedDateLabel,
                            entries: _cartEntriesForProduct(_focusedProduct!),
                            lineTotal: _cartEntriesForProduct(_focusedProduct!)
                                    .length *
                                _focusedProduct!.unitPrice,
                            selectedSizes: _selectedSizes,
                            onSizeChanged: (entryId, size) {
                              setState(() {
                                _selectedSizes[entryId] = size;
                                final index =
                                    _cartEntries.indexWhere((e) => e.id == entryId);
                                if (index >= 0) {
                                  final old = _cartEntries[index];
                                  _cartEntries[index] = _CartDesignEntry(
                                    id: old.id,
                                    product: old.product,
                                    design: old.design,
                                    selectedSize: size,
                                  );
                                }
                              });
                            },
                            onBack: _backToServices,
                            onRemove: _removeFromCart,
                            onCheckout: _showPaymentSheet,
                          ),
                        ),
                      ] else if (_selectedTab == 1) ...[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Obx(
                              () => _OrdersTab(
                                liveItems: _productsController.products,
                                history: _liveHistory.isNotEmpty
                                    ? _liveHistory
                                    : _history,
                                savedCountFor: _savedCountFor,
                              ),
                            ),
                          ),
                        ),
                      ] else if (_selectedTab == 3) ...[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: _CartTab(
                              entries: _cartEntries,
                              grandTotal: _cartGrandTotal,
                              dateLabel: _selectedDateLabel,
                              onRemove: _removeFromCart,
                              onCheckout: _showPaymentSheet,
                            ),
                          ),
                        ),
                      ] else ...[
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: _ProfileTab(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _kBorder.withValues(alpha: 0.6))),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _BottomTabs(
                selectedIndex: _selectedTab == 5 ? 2 : _selectedTab,
                onSelected: (index) {
                  if (index == 0) {
                    Get.offAllNamed<void>(Routes.SPLASH);
                    return;
                  }
                  setState(() {
                    _focusedProduct = null;
                    _selectedTab = index;
                  });
                  if (index == 2) {
                    _productsController.fetchProducts(force: true);
                  }
                },
              ),
            ),
          ),
          if (_isProcessingPayment)
            Container(
              color: Colors.black.withValues(alpha: 0.35),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: _kPrimaryBlue,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Processing Payment...',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _kText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderIllustration extends StatelessWidget {
  const _HeaderIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: 72,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.inventory_2_rounded,
            size: 46,
            color: const Color(0xFFE8A835).withValues(alpha: 0.95),
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          Positioned(
            top: 2,
            right: 4,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: _kPrimaryBlue, size: 20),
            ),
          ),
          Positioned(
            top: -4,
            left: 0,
            child: Icon(Icons.auto_awesome, size: 14, color: Colors.amber.shade300),
          ),
          Positioned(
            bottom: 2,
            right: -2,
            child: Icon(Icons.auto_awesome, size: 12, color: Colors.orange.shade200),
          ),
        ],
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
        if (badgeCount != null && badgeCount! > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              constraints: const BoxConstraints(minWidth: 16),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: const BoxDecoration(
                color: Color(0xFFF43F5E),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                badgeCount! > 99 ? '99+' : '$badgeCount',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search services...',
                border: InputBorder.none,
                isDense: true,
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: GoogleFonts.poppins(
                color: _kText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateFilterBar extends StatelessWidget {
  const _DateFilterBar({
    required this.dateLabel,
    required this.onPickDate,
  });

  final String dateLabel;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPickDate,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _kPrimaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: _kPrimaryBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select date',
                      style: GoogleFonts.poppins(
                        color: _kSubText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateLabel,
                      style: GoogleFonts.poppins(
                        color: _kText,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: _kSubText.withValues(alpha: 0.8)),
            ],
          ),
        ),
      ),
    );
  }
}

void _showFullProductImageDialog(BuildContext context, AppProduct item) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.75),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Title & Close
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
                color: const Color(0xFFF8FAFC),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          color: _kText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: _kSubText),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: _kBorder),

              // Full Image View with Zoom / Pinch
              Container(
                width: double.infinity,
                constraints:
                    const BoxConstraints(maxHeight: 380, minHeight: 220),
                color: const Color(0xFFFAFAFA),
                padding: const EdgeInsets.all(16),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4.0,
                        child: Center(
                          child: Image.network(
                            item.imageUrl!,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                    color: _kPrimaryBlue),
                              );
                            },
                            errorBuilder: (_, __, ___) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(item.icon, size: 54, color: item.accent),
                                const SizedBox(height: 8),
                                Text(
                                  'Image not available',
                                  style: GoogleFonts.poppins(
                                      color: _kSubText, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(item.icon, size: 64, color: item.accent),
                      ),
              ),
              const Divider(height: 1, color: _kBorder),

              // Bottom Bar with Price & Close Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${item.price}',
                          style: GoogleFonts.poppins(
                            color: _kPrimaryBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'per piece',
                          style: GoogleFonts.poppins(
                            color: _kSubText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: _kText,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'Close',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ProductRowCard extends StatelessWidget {
  const _ProductRowCard({
    required this.item,
    required this.quantity,
    required this.savedCount,
    required this.onQuantityChanged,
    required this.onOrderNow,
    this.onTapCard,
  });

  final AppProduct item;
  final int quantity;
  final int savedCount;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onOrderNow;
  final VoidCallback? onTapCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Circle Product Image (62x62) - uncropped, full image, tap to open modal
          GestureDetector(
            onTap: () => _showFullProductImageDialog(context, item),
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: item.accent.withValues(alpha: 0.35),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              clipBehavior: Clip.antiAlias,
              child: ClipOval(
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          item.icon,
                          color: item.accent,
                          size: 26,
                        ),
                      )
                    : Icon(
                        item.icon,
                        color: item.accent,
                        size: 26,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Center: Title + Full Description + Saved Count Badge + Quantity Selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTapCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.poppins(
                                color: _kText,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          if (item.matchesSavedDesignService('Student ID Card') ||
                              item.matchesSavedDesignService('Lanyard'))
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 11,
                              color: Color(0xFF94A3B8),
                            ),
                        ],
                      ),
                      if (item.description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          item.description,
                          style: GoogleFonts.poppins(
                            color: _kSubText,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Saved Cards indicator badge for this date
                if (savedCount > 0) ...[
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: onTapCard,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _kPrimaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: _kPrimaryBlue.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.badge_outlined,
                              size: 13, color: _kPrimaryBlue),
                          const SizedBox(width: 4),
                          Text(
                            '$savedCount saved for this date',
                            style: GoogleFonts.poppins(
                              color: _kPrimaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (item.matchesSavedDesignService('Student ID Card') ||
                    item.matchesSavedDesignService('Lanyard')) ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: onTapCard,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.folder_open_rounded,
                              size: 13, color: _kPrimaryBlue),
                          const SizedBox(width: 4),
                          Text(
                            'View saved designs',
                            style: GoogleFonts.poppins(
                              color: _kPrimaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),

                // Quantity Stepper
                Row(
                  children: [
                    Text(
                      'Qty:',
                      style: GoogleFonts.poppins(
                        color: _kSubText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _QtyButton(
                            icon: Icons.remove_rounded,
                            onTap: quantity > 1
                                ? () => onQuantityChanged(quantity - 1)
                                : null,
                          ),
                          Container(
                            constraints: const BoxConstraints(minWidth: 32),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            child: Text(
                              '$quantity',
                              style: GoogleFonts.poppins(
                                color: _kText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _QtyButton(
                            icon: Icons.add_rounded,
                            onTap: () => onQuantityChanged(quantity + 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right side: Price + Order Now Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.price}',
                style: GoogleFonts.poppins(
                  color: _kPrimaryBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'per piece',
                style: GoogleFonts.poppins(
                  color: _kSubText,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: _kPrimaryBlue,
                borderRadius: BorderRadius.circular(10),
                elevation: 0,
                child: InkWell(
                  onTap: onOrderNow,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Order Now',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 16,
          color: isEnabled ? _kText : const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? _kPrimaryBlue : Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: isSelected ? 2 : 0,
      shadowColor: _kPrimaryBlue.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? _kPrimaryBlue : _kBorder,
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : _kText,
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomTabs extends StatelessWidget {
  const _BottomTabs({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      _TabData(icon: Icons.home_outlined, label: 'Home'),
      _TabData(icon: Icons.description_outlined, label: 'Orders'),
      _TabData(icon: Icons.grid_view_rounded, label: 'Services'),
      _TabData(icon: Icons.shopping_cart_outlined, label: 'Cart'),
      _TabData(icon: Icons.person_outline_rounded, label: 'Profile'),
    ];

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: tabs
            .asMap()
            .map(
              (index, tab) => MapEntry(
                index,
                Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelected(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    decoration: selectedIndex == index
                        ? BoxDecoration(
                            color: _kPrimaryBlue.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab.icon,
                          color: selectedIndex == index ? _kPrimaryBlue : const Color(0xFF64748B),
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
                          style: GoogleFonts.poppins(
                            color:
                                selectedIndex == index ? _kPrimaryBlue : const Color(0xFF64748B),
                            fontSize: 11,
                            fontWeight: selectedIndex == index ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({
    required this.liveItems,
    required this.history,
    required this.savedCountFor,
  });

  final List<AppProduct> liveItems;
  final List<_OrderHistoryItem> history;
  final int Function(AppProduct) savedCountFor;

  @override
  Widget build(BuildContext context) {
    final active = liveItems.where((e) => savedCountFor(e) > 0).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      children: [
        Text('New Orders',
            style: GoogleFonts.poppins(
              color: _kText,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            )),
        const SizedBox(height: 8),
        if (active.isEmpty)
          const _EmptyBox(label: 'No new orders yet.')
        else
          ...active.map(
            (e) {
              final count = savedCountFor(e);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _OrderTile(
                  orderId: 'NEW-${e.name.replaceAll(' ', '')}',
                  title: e.name,
                  qty: count,
                  amount: e.unitPrice * count,
                  status: 'Pending',
                ),
              );
            },
          ),
        const SizedBox(height: 10),
        Text('Previous Orders',
            style: GoogleFonts.poppins(
              color: _kText,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            )),
        const SizedBox(height: 8),
        ...history.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _OrderTile(
              orderId: e.orderId,
              title: e.title,
              qty: e.qty,
              amount: e.amount,
              status: e.status,
              dateLabel: e.dateLabel,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({
    required this.orderId,
    required this.title,
    required this.qty,
    required this.amount,
    required this.status,
    this.dateLabel,
  });

  final String orderId;
  final String title;
  final int qty;
  final int amount;
  final String status;
  final String? dateLabel;

  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'Delivered' ? const Color(0xFF16A34A) : _kPrimaryBlue;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderId,
                    style: GoogleFonts.poppins(color: _kSubText, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(title,
                    style: GoogleFonts.poppins(color: _kText, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Qty: $qty   Amount: ₹ ${amount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(color: _kSubText, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              if (dateLabel != null) ...[
                const SizedBox(height: 4),
                Text(dateLabel!, style: GoogleFonts.poppins(color: _kSubText, fontSize: 11)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductSavedTab extends StatelessWidget {
  const _ProductSavedTab({
    required this.product,
    required this.dateLabel,
    required this.entries,
    required this.lineTotal,
    required this.selectedSizes,
    required this.onSizeChanged,
    required this.onBack,
    required this.onRemove,
    required this.onCheckout,
  });

  final AppProduct product;
  final String dateLabel;
  final List<_CartDesignEntry> entries;
  final int lineTotal;
  final Map<String, String> selectedSizes;
  final void Function(String entryId, String size) onSizeChanged;
  final VoidCallback onBack;
  final ValueChanged<String> onRemove;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                color: _kText,
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Text(
                  'Back to services',
                  style: GoogleFonts.poppins(
                    color: _kSubText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: product.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: product.accent.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: product.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(product.icon, color: product.accent, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.poppins(
                          color: _kText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : '${entries.length} in cart · $dateLabel',
                        style: GoogleFonts.poppins(
                          color: _kSubText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (product.supportsSizes && product.sizes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _kBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: entries.isNotEmpty
                      ? selectedSizes[entries.first.id] ?? product.sizes.first
                      : product.sizes.first,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: product.sizes
                      .map(
                        (size) => DropdownMenuItem<String>(
                          value: size,
                          child: Text(
                            'Size: $size',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _kText,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (size) {
                    if (size == null) return;
                    for (final entry in entries) {
                      onSizeChanged(entry.id, size);
                    }
                  },
                ),
              ),
            ),
          ),
        if (entries.isEmpty)
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _EmptyBox(label: 'No items in cart for this product.'),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _kBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: product.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _DesignThumbSmall(design: entry.design),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.design.instituteName.isNotEmpty
                                  ? entry.design.instituteName
                                  : entry.design.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: _kText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              [
                                if (entry.design.studentName.isNotEmpty)
                                  entry.design.studentName,
                                if (entry.selectedSize != null)
                                  'Size: ${entry.selectedSize}',
                              ].join(' · ').isEmpty
                                  ? entry.design.subtitle
                                  : [
                                      if (entry.design.studentName.isNotEmpty)
                                        entry.design.studentName,
                                      if (entry.selectedSize != null)
                                        'Size: ${entry.selectedSize}',
                                    ].join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: _kSubText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${product.unitPrice}',
                        style: GoogleFonts.poppins(
                          color: _kSubText,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => onRemove(entry.id),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: const Color(0xFFEF4444),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: ₹$lineTotal',
                      style: GoogleFonts.poppins(
                        color: _kPrimaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '₹${product.unitPrice} each',
                      style: GoogleFonts.poppins(color: _kSubText, fontSize: 11),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: entries.isEmpty ? null : onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _kBorder,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  'Checkout',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartTab extends StatelessWidget {
  const _CartTab({
    required this.entries,
    required this.grandTotal,
    required this.dateLabel,
    required this.onRemove,
    required this.onCheckout,
  });

  final List<_CartDesignEntry> entries;
  final int grandTotal;
  final String dateLabel;
  final ValueChanged<String> onRemove;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: _EmptyBox(label: 'Cart is empty. Open a service to add designs.'),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _kPrimaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kPrimaryBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: _kPrimaryBlue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${entries.length} items · $dateLabel',
                    style: GoogleFonts.poppins(
                      color: _kPrimaryBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            itemCount: entries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final product = entry.product;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _kBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: product.accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(product.icon, color: product.accent, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.design.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: _kText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            product.name,
                            style: GoogleFonts.poppins(color: _kSubText, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${product.unitPrice}',
                      style: GoogleFonts.poppins(
                        color: product.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onRemove(entry.id),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      color: const Color(0xFFEF4444),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Grand Total: ₹$grandTotal',
                  style: GoogleFonts.poppins(color: _kPrimaryBlue, fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Checkout', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentSheet extends StatefulWidget {
  const _PaymentSheet({
    required this.entries,
    required this.total,
    required this.onRemove,
    required this.onClose,
    required this.onPay,
    this.isPaying = false,
  });

  final List<_CartDesignEntry> entries;
  final int total;
  final ValueChanged<String> onRemove;
  final VoidCallback onClose;
  final VoidCallback onPay;
  final bool isPaying;

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  int _selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final total = widget.entries.fold<int>(0, (sum, e) => sum + e.product.unitPrice);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Payment',
                    style: GoogleFonts.poppins(
                      color: _kText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded),
                  color: _kSubText,
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: widget.entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = widget.entries[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.design.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _kText,
                              ),
                            ),
                            Text(
                              entry.product.name,
                              style: GoogleFonts.poppins(fontSize: 11, color: _kSubText),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${entry.product.unitPrice}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: entry.product.accent,
                          fontSize: 13,
                        ),
                      ),
                      IconButton(
                        onPressed: () => widget.onRemove(entry.id),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: const Color(0xFFEF4444),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                _PaymentMethodChip(
                  label: 'UPI',
                  icon: Icons.account_balance_wallet_outlined,
                  selected: _selectedMethod == 0,
                  onTap: () => setState(() => _selectedMethod = 0),
                ),
                const SizedBox(width: 8),
                _PaymentMethodChip(
                  label: 'Card',
                  icon: Icons.credit_card_outlined,
                  selected: _selectedMethod == 1,
                  onTap: () => setState(() => _selectedMethod = 1),
                ),
                const SizedBox(width: 8),
                _PaymentMethodChip(
                  label: 'Cash',
                  icon: Icons.payments_outlined,
                  selected: _selectedMethod == 2,
                  onTap: () => setState(() => _selectedMethod = 2),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 12 + bottomInset),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kPrimaryBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _kPrimaryBlue.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Amount to pay',
                        style: GoogleFonts.poppins(color: _kSubText, fontSize: 13),
                      ),
                    ),
                    Text(
                      '₹$total',
                      style: GoogleFonts.poppins(
                        color: _kPrimaryBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.entries.isEmpty || widget.isPaying ? null : widget.onPay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimaryBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: _kBorder,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: widget.isPaying
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Pay Now',
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  const _PaymentMethodChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? _kPrimaryBlue.withValues(alpha: 0.12) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? _kPrimaryBlue : _kBorder,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, size: 20, color: selected ? _kPrimaryBlue : _kSubText),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? _kPrimaryBlue : _kSubText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final storage = LocalStorageService();
    final name = storage.getUserName();
    final email = storage.getEmailId();
    final phone = storage.getUserPhone();

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _kPrimaryBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: _kPrimaryBlue, size: 36),
              ),
              const SizedBox(height: 10),
              _ProfileField(label: 'Full Name', value: name.isNotEmpty ? name : 'Not provided'),
              _ProfileField(label: 'Email Address', value: email.isNotEmpty ? email : 'Not provided'),
              _ProfileField(label: 'Mobile Number', value: phone.isNotEmpty ? phone : 'Not provided'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(color: _kSubText, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.poppins(color: _kText, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(color: _kSubText, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _TabData {
  const _TabData({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class _CartDesignEntry {
  const _CartDesignEntry({
    required this.id,
    required this.product,
    required this.design,
    this.selectedSize,
  });

  final String id;
  final AppProduct product;
  final _SavedDesign design;
  final String? selectedSize;
}

class _SavedDesign {
  const _SavedDesign({
    required this.id,
    required this.title,
    required this.subtitle,
    this.instituteName = '',
    this.studentName = '',
    this.frontImagePath = '',
    this.backImagePath = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final String instituteName;
  final String studentName;
  final String frontImagePath;
  final String backImagePath;
}

class _DesignThumbSmall extends StatelessWidget {
  const _DesignThumbSmall({required this.design});

  final _SavedDesign design;

  @override
  Widget build(BuildContext context) {
    final path = design.frontImagePath;
    if (path.isNotEmpty && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(File(path), fit: BoxFit.cover),
      );
    }
    return const Icon(Icons.description_outlined, size: 20);
  }
}

class _OrderHistoryItem {
  const _OrderHistoryItem({
    required this.orderId,
    required this.title,
    required this.qty,
    required this.amount,
    required this.status,
    required this.dateLabel,
  });

  final String orderId;
  final String title;
  final int qty;
  final int amount;
  final String status;
  final String dateLabel;
}
