import 'package:flutter/foundation.dart';
import 'package:jarvis_application/models/account_plan_model.dart';

class AccountViewModel extends ChangeNotifier {
  List<AccountPlanModel> availablePlans = [];
  AccountPlanModel? currentPlan;

  AccountViewModel() {
    // Simulating fetching data from a service
    availablePlans = [
      AccountPlanModel(
        name: 'Basic',
        price: 0,
        description: 'Free',
        basicFeatures: [
          'AI Chat Model (GPT-3.5)',
          'AI Action Injection',
          'Select Text for AI Action'
        ],
        queriesDescription: '50 free queries per day',
        advancedFeatures: [
          'AI Reading Assistant',
          'Real-time Web Access',
          'AI Writing Assistant',
          'AI Pro Search'
        ],
        otherBenefits: ['Lower response speed during high-traffic'],
      ),
      AccountPlanModel(
        name: 'Starter',
        price: 9.99,
        description: '1-month Free Trial, Then \$9.99/month',
        basicFeatures: [
          'AI Chat Models (GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra)',
          'AI Action Injection',
          'Select Text for AI Action'
        ],
        queriesDescription: 'Unlimited queries per month',
        advancedFeatures: [
          'AI Reading Assistant',
          'Real-time Web Access',
          'AI Writing Assistant',
          'AI Pro Search',
          'Jira Copilot Assistant',
          'Github Copilot Assistant'
        ],
        otherBenefits: [
          'No request limits during high-traffic',
          '2X faster response speed',
          'Priority email support'
        ],
      ),
      AccountPlanModel(
        name: 'Pro Annually',
        price: 79.99,
        description: '1-month Free Trial, Then \$79.99/year\nSave 33% on annual plan!',
        basicFeatures: [
          'AI Chat Models (GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra)',
          'AI Action Injection',
          'Select Text for AI Action'
        ],
        queriesDescription: 'Unlimited queries per year',
        advancedFeatures: [
          'AI Reading Assistant',
          'Real-time Web Access',
          'AI Writing Assistant',
          'AI Pro Search',
          'Jira Copilot Assistant',
          'Github Copilot Assistant'
        ],
        otherBenefits: [
          'No request limits during high-traffic',
          '2X faster response speed',
          'Priority email support'
        ],
      ),
    ];
    currentPlan = availablePlans[0]; // Assume the user starts with Basic plan
  }

  void upgradePlan(AccountPlanModel newPlan) {
    currentPlan = newPlan;
    notifyListeners();
  }

  String getQueriesInfo(AccountPlanModel plan) {
    return plan.queriesDescription;
  }

  String getAvailableModels(AccountPlanModel plan) {
    switch (plan.name) {
      case 'Basic':
        return 'GPT-3.5';
      case 'Starter':
      case 'Pro Annually':
        return 'GPT-3.5, GPT-4.0/Turbo, Gemini Pro, Gemini Ultra';
      default:
        return 'N/A';
    }
  }
}
