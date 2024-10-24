import 'package:flutter/material.dart';
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
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
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
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Consumer<AccountViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.availablePlans.isEmpty) {
            return const Center(child: Text('No upgrade plans available', style: TextStyle(color: Colors.white)));
          }
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: viewModel.availablePlans.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPlanPage(viewModel.availablePlans[index], viewModel);
                },
              ),
              Positioned(
                left: 10,
                top: MediaQuery.of(context).size.height / 2,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
              Positioned(
                right: 10,
                top: MediaQuery.of(context).size.height / 2,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: _currentPage < viewModel.availablePlans.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlanPage(AccountPlanModel plan, AccountViewModel viewModel) {
    bool isCurrentPlan = plan.name == viewModel.currentPlan?.name;
    bool isFreePlan = plan.name == 'Basic';

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              plan.description,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              'Queries: ${plan.queriesDescription}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildFeatureSection('Basic Features', plan.basicFeatures),
            const SizedBox(height: 20),
            _buildFeatureSection('Advanced Features', plan.advancedFeatures),
            const SizedBox(height: 20),
            _buildFeatureSection('Other Benefits', plan.otherBenefits),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isCurrentPlan ? null : () {
                  viewModel.upgradePlan(plan);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Upgraded to ${plan.name} plan')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  isCurrentPlan ? 'Current Plan' : 'Upgrade to ${plan.name}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection(String title, List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...features.map(
          (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ignore: prefer_const_constructors
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(feature)),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  List<Color> _getPlanGradientColors(String planName) {
    switch (planName) {
      case 'Basic':
        return [Colors.lightBlue[100]!, Colors.lightBlue[300]!];
      case 'Starter':
        return [Colors.purple[100]!, Colors.purple[300]!];
      case 'Pro Annually':
        return [Colors.amber[100]!, Colors.amber[300]!];
      default:
        return [Colors.grey[100]!, Colors.grey[300]!];
    }
  }
}
