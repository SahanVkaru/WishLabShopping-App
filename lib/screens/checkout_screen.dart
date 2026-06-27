import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import '../utils/formatters.dart';
import '../utils/routes.dart';
import '../widgets/order_details_sheet.dart';
import '../widgets/interactive_credit_card.dart';
import '../constants/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _notesController = TextEditingController();
  String _paymentMethod = 'Credit Card';
  bool _isLoading = false;

  // State variables for interactive checkout
  String _shippingAddress = '1470 Coder Lane, Petaluma\nCA 9495, Australia';
  String _shippingTitle = 'Home';
  
  String _cardNumber = '4315024544800345';
  String _cardName = 'MAHMUDUR RAHMAN';
  String _cvv = '123';
  String _expiryDate = '12/26';
  bool _showCardBack = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _placeOrder(BuildContext context, CartProvider cart, OrderProvider orderProvider) async {
    setState(() => _isLoading = true);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final order = OrderModel(
      id: '#ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      items: cart.items.values.toList(),
      totalAmount: cart.totalAmount,
      shippingAddress: _shippingAddress,
      paymentMethod: _paymentMethod,
      status: OrderStatus.placed,
      date: DateTime.now(),
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    orderProvider.addOrder(order);
    cart.clearCart();
    
    setState(() => _isLoading = false);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline, color: Color(0xFF2ECC71), size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Order Placed!', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        content: const Text('Thank you for shopping! Your order has been placed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // pop checkout screen
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              
              // Open order details (this will show above the home screen)
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => OrderDetailsSheet(order: order),
              );
            },
            child: Text('View Order', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
            child: Text('Continue Shopping', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _editShippingAddress() {
    final titleController = TextEditingController(text: _shippingTitle);
    final addressController = TextEditingController(text: _shippingAddress.replaceAll('\n', ', '));
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Shipping Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Address Title (e.g., Home, Work)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Full Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _shippingTitle = titleController.text.isNotEmpty ? titleController.text : 'Custom';
                    _shippingAddress = addressController.text.isNotEmpty ? addressController.text : _shippingAddress;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Address'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _editCreditCard() {
    final numberController = TextEditingController(text: _cardNumber);
    final nameController = TextEditingController(text: _cardName);
    final expiryController = TextEditingController(text: _expiryDate);
    final cvvController = TextEditingController(text: _cvv);

    final cvvFocus = FocusNode();
    final numberFocus = FocusNode();

    // Listen to CVV focus to flip card
    cvvFocus.addListener(() {
      setState(() {
        _showCardBack = cvvFocus.hasFocus;
      });
    });

    numberController.addListener(() {
      final text = numberController.text.replaceAll(' ', '');
      if (text.length >= 16 && numberFocus.hasFocus) {
        // Auto-flip to CVV when 16 digits are entered
        numberFocus.unfocus();
        cvvFocus.requestFocus();
      }
      setState(() {
        _cardNumber = text;
      });
    });

    nameController.addListener(() {
      setState(() {
        _cardName = nameController.text;
      });
    });

    cvvController.addListener(() {
      setState(() {
        _cvv = cvvController.text;
      });
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final colorScheme = Theme.of(context).colorScheme;
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Card Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  // Live Card Preview
                  InteractiveCreditCard(
                    cardNumber: _cardNumber,
                    cardName: _cardName,
                    cvv: _cvv,
                    showBack: _showCardBack,
                  ),
                  const SizedBox(height: 32),

                  TextField(
                    controller: numberController,
                    focusNode: numberFocus,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.credit_card),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Cardholder Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryController,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
                          focusNode: cvvFocus,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            counterText: '',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validation
                        if (_cardNumber.length < 16) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid 16-digit card number')));
                          return;
                        }
                        if (_cvv.length < 3) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid 3-digit CVV')));
                          return;
                        }
                        if (_cardName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the cardholder name')));
                          return;
                        }

                        // Ensure card flips back to front when modal closes
                        setState(() {
                          _showCardBack = false;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Card', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }
      ),
    ).whenComplete(() {
      // Ensure card flips back to front when modal is dismissed
      if (mounted) {
        setState(() {
          _showCardBack = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF7F7F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer2<CartProvider, OrderProvider>(
        builder: (context, cart, orderProvider, child) {
          if (cart.itemCount == 0 && !_isLoading) {
            return const Center(child: Text('Your cart is empty'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping to Section
                Text(
                  'Shipping to',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _editShippingAddress,
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              color: colorScheme.onSurface.withValues(alpha: 0.05),
                              size: 40,
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _shippingTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Icon(Icons.edit, size: 16, color: colorScheme.primary),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _shippingAddress,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Add Payment Method Section
                Text(
                  'Add Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPaymentLogo(
                        isSelected: _paymentMethod == 'Credit Card',
                        onTap: () => setState(() => _paymentMethod = 'Credit Card'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(-6, 0),
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildPaymentLogo(
                        isSelected: _paymentMethod == 'PayPal',
                        onTap: () => setState(() => _paymentMethod = 'PayPal'),
                        child: const Text(
                          'P',
                          style: TextStyle(
                            color: Color(0xFF003087),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildPaymentLogo(
                        isSelected: _paymentMethod == 'Apple Pay',
                        onTap: () => setState(() => _paymentMethod = 'Apple Pay'),
                        child: const Icon(Icons.apple, size: 28),
                      ),
                      const SizedBox(width: 12),
                      _buildPaymentLogo(
                        isSelected: _paymentMethod == 'Google Pay',
                        onTap: () => setState(() => _paymentMethod = 'Google Pay'),
                        child: const Text(
                          'G',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildPaymentLogo(
                        isSelected: _paymentMethod == 'Cash on Delivery',
                        onTap: () => setState(() => _paymentMethod = 'Cash on Delivery'),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_shipping, size: 18, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'COD',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Dynamic Payment Details Display
                if (_paymentMethod == 'Credit Card') ...[
                  GestureDetector(
                    onTap: _editCreditCard,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        InteractiveCreditCard(
                          cardNumber: _cardNumber,
                          cardName: _cardName,
                          cvv: _cvv,
                          showBack: _showCardBack,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text('Edit', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (_paymentMethod == 'Cash on Delivery') ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF2ECC71).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.local_shipping, size: 48, color: Color(0xFF2ECC71)),
                        const SizedBox(height: 16),
                        const Text(
                          'Cash on Delivery',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2ECC71),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You will pay the delivery executive when your order arrives.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.payment, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'Pay with $_paymentMethod',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You will be redirected to complete your payment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 48),

                // Total Payment Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          Formatters.formatCurrency(cart.totalAmount),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'USD',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Confirm Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _placeOrder(context, cart, orderProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(
                            color: Colors.white, 
                            strokeWidth: 2
                          )
                        )
                      : const Text(
                          'Confirm Order', 
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentLogo({required bool isSelected, required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: Colors.orange.withValues(alpha: 0.5), width: 2)
              : Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
