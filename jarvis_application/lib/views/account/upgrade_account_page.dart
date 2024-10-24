import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_application/models/account_plan_model.dart';
import 'package:jarvis_application/viewmodels/account_view_model.dart';
import 'package:provider/provider.dart';

class UpgradeAccountScreen extends StatefulWidget {
  const UpgradeAccountScreen({Key? key}) : super(key: key);

  @override
  State<UpgradeAccountScreen> createState() => _UpgradeAccountScreenState();
}

class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Account'),
      ),
      body: Consumer<AccountViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.availablePlans.isEmpty) {
            return const Center(child: Text('No plans available'));
          }
          return PageView.builder(
            controller: _pageController,
            itemCount: viewModel.availablePlans.length,
            itemBuilder: (context, index) {
              return _buildPlanPage(viewModel.availablePlans[index], viewModel);
            },
          );
        },
      ),
    );
  }

  Widget _buildPlanPage(AccountPlanModel plan, AccountViewModel viewModel) {
    bool isCurrentPlan = plan.name == viewModel.currentPlan?.name;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Plan header
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getPlanIcon(plan.name),
                    const SizedBox(width: 8),
                    Text(
                      plan.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    if (plan.name == 'Pro Annually') _buildHotPickBadge(),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPriceSection(plan),
                if (plan.name != 'Basic') _buildSubscribeButton(plan),
                if (plan.name == 'Pro Annually') _buildSavingsBadge(),
              ],
            ),
          ),
          // Rest of the plan details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureSection('Basic features', plan.basicFeatures),
                const SizedBox(height: 20),
                _buildFeatureSection('Advanced Features', plan.advancedFeatures),
                const SizedBox(height: 20),
                _buildFeatureSection('Other Benefits', plan.otherBenefits),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPlanIcon(String planName) {
    switch (planName) {
      case 'Basic':
        return const Icon(Icons.brightness_5, color: Colors.blue, size: 24);
      case 'Starter':
        return const Icon(Icons.all_inclusive, color: Colors.blue, size: 24);
      case 'Pro Annually':
        return const FaIcon(FontAwesomeIcons.crown, color: Colors.orange, size: 24);
      default:
        return const Icon(Icons.category, color: Colors.grey, size: 24);
    }
  }

  Widget _buildHotPickBadge() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.thumb_up, color: Colors.yellow, size: 16),
          SizedBox(width: 4),
          Text(
            'HOT PICK',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(AccountPlanModel plan) {
    if (plan.name == 'Basic') {
      return const Text(
        'Free',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
      );
    } else {
      return Column(
        children: [
          const Text(
            '1-month Free Trial',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          const Text(
            'Then',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            plan.name == 'Starter' ? '\$9.99/month' : '\$79.99/year',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }

  Widget _buildSubscribeButton(AccountPlanModel plan) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: () {
          // Implement subscription logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: plan.name == 'Pro Annually' ? Colors.orange : Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Text('Subscribe now', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildSavingsBadge() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'SAVE 33% ON ANNUAL PLAN!',
        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFeatureSection(String title, List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...features.map((feature) => _buildFeatureItem(feature)),
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
