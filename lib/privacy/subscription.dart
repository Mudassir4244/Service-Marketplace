import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  bool _isLoading = true;
  List<ProductDetails> _products = [];
  bool _isPremium = false;
  String? _planType; // "silver" or "golden"
  String? _subscriptionPlan;
  String? _subscriptionEndDate;
  User? _user;

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'subscription': 'Subscription',
      'silverPlan': 'Silver Plan',
      'goldenPlan': 'Golden Plan',
      'silverBenefits': 'Silver Plan Benefits',
      'goldenBenefits': 'Golden Plan Benefits',
      'adFree': 'Ad-free experience',
      'prioritySupport': 'Priority support',
      'exclusiveContent': 'Exclusive content',
      'monthly': 'Monthly',
      'yearly': 'Yearly',
      'manageSubscriptions': 'Manage Subscriptions',
      'loading': 'Loading...',
      'purchaseError': 'Failed to purchase subscription',
      'purchaseSuccess': 'Subscription purchased successfully',
      'noSubscriptions': 'No subscriptions available',
      'alreadySubscribed': 'You are subscribed to the %s Plan',
      'manageInPlayStore': 'Manage in Google Play Store',
    },
    'ur': {
      'subscription': 'سبسکرپشن',
      'silverPlan': 'سلور پلان',
      'goldenPlan': 'گولڈن پلان',
      'silverBenefits': 'سلور پلان کے فوائد',
      'goldenBenefits': 'گولڈن پلان کے فوائد',
      'adFree': 'اشتہارات سے پاک تجربہ',
      'prioritySupport': 'ترجیحی سپورٹ',
      'exclusiveContent': 'خصوصی مواد',
      'monthly': 'ماہانہ',
      'yearly': 'سالانہ',
      'manageSubscriptions': 'سبسکرپشنز کا انتظام کریں',
      'loading': 'لوڈ ہو رہا ہے...',
      'purchaseError': 'سبسکرپشن خریدنے میں ناکام',
      'purchaseSuccess': 'سبسکرپشن کامیابی سے خریدی گئی',
      'noSubscriptions': 'کوئی سبسکرپشنز دستیاب نہیں',
      'alreadySubscribed': 'آپ %s پلان کے سبسکرائبر ہیں',
      'manageInPlayStore': 'گوگل پلے اسٹور میں انتظام کریں',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _initializeInAppPurchase();
    _checkSubscriptionStatus();
  }

  // Initialize InAppPurchase
  Future<void> _initializeInAppPurchase() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!mounted) return;

    setState(() {
      _isAvailable = available;
      _isLoading = true;
    });

    if (available) {
      const Set<String> productIds = {
        'silver_plan_monthly',
        'silver_plan_yearly',
        'golden_plan_monthly',
        'golden_plan_yearly',
      };
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
      if (!mounted) return;

      setState(() {
        _products = response.productDetails;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // Check subscription status from Firestore
  Future<void> _checkSubscriptionStatus() async {
    if (_user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
    if (!mounted) return;

    setState(() {
      _isPremium = doc.exists && (doc.data()?['isPremium'] ?? false);
      _planType = doc.data()?['planType'];
      _subscriptionPlan = doc.data()?['subscriptionPlan'];
      _subscriptionEndDate = doc.data()?['subscriptionEndDate'];
    });
  }

  // Handle purchase
  Future<void> _buyProduct(ProductDetails product) async {
    if (_user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('purchaseError', Provider.of<LanguageProvider>(context, listen: false).language)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_translate('purchaseError', Provider.of<LanguageProvider>(context, listen: false).language)}: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Launch Google Play Subscriptions
  Future<void> _launchPlayStoreSubscriptions() async {
    final Uri playStoreUri = Uri.parse('https://play.google.com/store/account/subscriptions');
    if (await canLaunchUrl(playStoreUri)) {
      await launchUrl(playStoreUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('purchaseError', Provider.of<LanguageProvider>(context, listen: false).language)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to purchase updates
    _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> purchases) async {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          await _inAppPurchase.completePurchase(purchase);
          if (_user != null) {
            final endDate = purchase.productID.contains('monthly')
                ? DateTime.now().add(const Duration(days: 30))
                : DateTime.now().add(const Duration(days: 365));
            final planType = purchase.productID.contains('silver') ? 'silver' : 'golden';
            await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
              'isPremium': true,
              'planType': planType,
              'subscriptionPlan': purchase.productID,
              'subscriptionEndDate': endDate.toIso8601String(),
              'name': _user!.displayName ?? '',
              'email': _user!.email ?? '',
            }, SetOptions(merge: true));
            if (!mounted) return;
            setState(() {
              _isPremium = true;
              _planType = planType;
              _subscriptionPlan = purchase.productID;
              _subscriptionEndDate = endDate.toIso8601String();
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_translate('purchaseSuccess', Provider.of<LanguageProvider>(context, listen: false).language)),
                backgroundColor: const Color(0xFF00A86B),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else if (purchase.status == PurchaseStatus.error || purchase.status == PurchaseStatus.canceled) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_translate('purchaseError', Provider.of<LanguageProvider>(context, listen: false).language)),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (purchase.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchase);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          _translate('subscription', language),
          style: TextStyle(
            color: textColor,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF00A86B),
          size: 28,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: maxHeight * 0.03),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark ? Colors.grey[800]! : Colors.white,
                      isDark ? Colors.grey[850]! : const Color(0xFFF1FCF7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(maxWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    if (_isPremium)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _translate('alreadySubscribed', language).replaceFirst(
                              '%s',
                              _planType == 'silver' ? _translate('silverPlan', language) : _translate('goldenPlan', language),
                            ),
                            style: TextStyle(
                              color: const Color(0xFF00A86B),
                              fontWeight: FontWeight.bold,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.01),
                          Text(
                            '${_translate(_subscriptionPlan!.contains('monthly') ? 'monthly' : 'yearly', language)}: $_subscriptionPlan',
                            style: TextStyle(
                              color: textColor,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          Text(
                            'Ends: ${_subscriptionEndDate != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(_subscriptionEndDate!)) : 'N/A'}',
                            style: TextStyle(
                              color: textColor,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.02),
                          GestureDetector(
                            onTap: _launchPlayStoreSubscriptions,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00A86B), Colors.teal],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  _translate('manageInPlayStore', language),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else ...[
                      // Silver Plan
                      Text(
                        _translate('silverBenefits', language),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth * 0.05,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      _buildBenefitItem(
                        icon: Icons.block,
                        text: _translate('adFree', language),
                        textColor: textColor,
                        isUrdu: isUrdu,
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
                      else if (!_isAvailable || _products.isEmpty)
                        Text(
                          _translate('noSubscriptions', language),
                          style: TextStyle(
                            color: textColor,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        )
                      else
                        Column(
                          children: _products
                              .where((product) => product.id.contains('silver'))
                              .map((product) => _buildPlanItem(
                                    product: product,
                                    planName: _translate('silverPlan', language),
                                    isUrdu: isUrdu,
                                    textColor: textColor,
                                    maxWidth: maxWidth,
                                    maxHeight: maxHeight,
                                    language: language,
                                  ))
                              .toList(),
                        ),
                      SizedBox(height: maxHeight * 0.03),
                      // Golden Plan
                      Text(
                        _translate('goldenBenefits', language),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth * 0.05,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      _buildBenefitItem(
                        icon: Icons.block,
                        text: _translate('adFree', language),
                        textColor: textColor,
                        isUrdu: isUrdu,
                      ),
                      _buildBenefitItem(
                        icon: Icons.support_agent,
                        text: _translate('prioritySupport', language),
                        textColor: textColor,
                        isUrdu: isUrdu,
                      ),
                      _buildBenefitItem(
                        icon: Icons.star,
                        text: _translate('exclusiveContent', language),
                        textColor: textColor,
                        isUrdu: isUrdu,
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
                      else if (!_isAvailable || _products.isEmpty)
                        Text(
                          _translate('noSubscriptions', language),
                          style: TextStyle(
                            color: textColor,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        )
                      else
                        Column(
                          children: _products
                              .where((product) => product.id.contains('golden'))
                              .map((product) => _buildPlanItem(
                                    product: product,
                                    planName: _translate('goldenPlan', language),
                                    isUrdu: isUrdu,
                                    textColor: textColor,
                                    maxWidth: maxWidth,
                                    maxHeight: maxHeight,
                                    language: language,
                                  ))
                              .toList(),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String text,
    required Color textColor,
    required bool isUrdu,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Icon(icon, color: const Color(0xFF00A86B), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem({
    required ProductDetails product,
    required String planName,
    required bool isUrdu,
    required Color textColor,
    required double maxWidth,
    required double maxHeight,
    required String language,
  }) {
    return GestureDetector(
      onTap: () => _buyProduct(product),
      child: Container(
        margin: EdgeInsets.only(bottom: maxHeight * 0.02),
        padding: EdgeInsets.all(maxWidth * 0.04),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              product.id.contains('silver') ? Colors.grey[400]! : Colors.amber[700]!,
              product.id.contains('silver') ? Colors.grey[500]! : Colors.amber[800]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              Icons.star,
              color: Colors.white,
              size: maxWidth * 0.06,
            ),
            SizedBox(width: maxWidth * 0.03),
            Expanded(
              child: Text(
                '$planName (${_translate(product.id.contains('monthly') ? 'monthly' : 'yearly', language)})',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                ),
              ),
            ),
            Text(
              product.price,
              style: TextStyle(
                color: Colors.white,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}