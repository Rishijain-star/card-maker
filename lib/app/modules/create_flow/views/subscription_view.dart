import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/app_product.dart';
import '../../../routes/app_pages.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
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

class _SubscriptionViewState extends State<SubscriptionView> {
  final ProductsController _productsController = Get.find<ProductsController>();

  int _selectedTab = 2;
  AppProduct? _focusedProduct;
  final TextEditingController _searchCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final Map<String, String> _selectedSizes = <String, String>{};

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

  final List<_CartDesignEntry> _cartEntries = [];
  final Set<String> _removedDesignIds = {};

  @override
  void initState() {
    super.initState();
    _productsController.fetchProducts(force: true);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
    final designs = _savedDesignsFor(item);
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

            return _PaymentSheet(
              entries: _cartEntries,
              total: _cartGrandTotal,
              onRemove: removeItem,
              onClose: () => Navigator.pop(sheetContext),
              onPay: () {
                Navigator.pop(sheetContext);
                _clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Payment successful!',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<AppProduct> get _visibleProducts {
    final query = _searchCtrl.text.trim().toLowerCase();
    final all = _productsController.products;
    if (query.isEmpty) return all;
    return all
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query))
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: _SearchBar(controller: _searchCtrl, onChanged: (_) => setState(() {})),
                        ),
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
                                onRefresh: () =>
                                    _productsController.fetchProducts(force: true),
                                child: GridView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: width >= 520 ? 2.15 : 1.95,
                                  ),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    return _ProductCard(
                                      item: item,
                                      onTap: () => _openProductDesigns(item),
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
                                history: _history,
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.item,
    required this.onTap,
  });

  final AppProduct item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(item.icon, color: item.accent, size: 24),
                      )
                    : Icon(item.icon, color: item.accent, size: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: _kText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: _kSubText,
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _kPrimaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chevron_right_rounded, color: _kPrimaryBlue, size: 18),
              ),
            ],
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
  });

  final List<_CartDesignEntry> entries;
  final int total;
  final ValueChanged<String> onRemove;
  final VoidCallback onClose;
  final VoidCallback onPay;

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
                    onPressed: widget.entries.isEmpty ? null : widget.onPay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimaryBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: _kBorder,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
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
