import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_application/models/account_plan_model.dart';
import 'package:jarvis_application/viewmodels/account_view_model.dart';
import 'package:provider/provider.dart';

class UpgradeAccountScreen extends StatefulWidget {
  const UpgradeAccountScreen({super.key});

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
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade300, Colors.purple.shade300],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _getPlanIcon(plan.name),
                  const SizedBox(width: 8),
                  Text(
                    plan.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement upgrade logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Upgrade'),
              ),
            ],
          ),
        ),
        // Queries section
        _buildQueriesSection(plan, viewModel),

        // Features section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureSection('Basic Features', plan.basicFeatures),
              const Divider(height: 32, thickness: 1),
              _buildFeatureSection('Advanced Features', plan.advancedFeatures),
              const Divider(height: 32, thickness: 1),
              _buildFeatureSection('Other Benefits', plan.otherBenefits),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQueriesSection(AccountPlanModel plan, AccountViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  plan.name == 'Basic' ? 'Free' : '1-month Free Trial',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              if (plan.name == 'Pro Annually') _buildHotPickBadge(),
            ],
          ),
          if (plan.name != 'Basic') ...[
            const SizedBox(height: 8),
            const Text(
              'Then',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              plan.name == 'Starter' ? '\$9.99/month' : '\$79.99/year',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.bolt, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  viewModel.getQueriesInfo(plan),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Available Models: ${viewModel.getAvailableModels(plan)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _getPlanIcon(String planName) {
    switch (planName) {
      case 'Basic':
        return const Icon(Icons.brightness_low, color: Color(0xFF3498DB), size: 24);
      case 'Starter':
        return const Icon(Icons.all_inclusive, color: Color(0xFF00008B), size: 24);
      case 'Pro Annually':
        return const FaIcon(FontAwesomeIcons.crown, color: Colors.amber, size: 24);
      default:
        return const Icon(Icons.star, color: Colors.white, size: 24);
    }
  }

  Widget _buildHotPickBadge() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A), // Dark blue background
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'HOT PICK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: -12,
              left: -12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.amber, // Amber color
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.thumb_up,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(AccountPlanModel plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plan.name == 'Basic' ? 'Free' : '1-month Free Trial',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (plan.name != 'Basic') ...[
          const SizedBox(height: 8),
          const Text(
            'Then',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            plan.name == 'Starter' ? '\$9.99/month' : '\$79.99/year',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (plan.name == 'Pro Annually')
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'SAVE 33% ON ANNUAL PLAN!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildSubscribeButton(AccountPlanModel plan) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Implement subscription logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _getPlanColor(plan.name),
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text('Subscribe now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSavingsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'SAVE 33% ON ANNUAL PLAN!',
        style: TextStyle(color: _getPlanColor('Pro Annually'), fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getPlanColor(String planName) {
    switch (planName) {
      case 'Basic':
        return Colors.blue;
      case 'Starter':
        return Colors.purple;
      case 'Pro Annually':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFeatureCard(String title, List<String> features) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFeatureSection(String title, List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A), // Dark blue color
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 14, // Smaller font size
                    color: Colors.black87,
                    fontWeight: FontWeight.w400, // Regular weight
                    height: 1.4, // Adjusted line height
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;

  WavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path = Path();

    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.85,
        size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.65,
        size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
