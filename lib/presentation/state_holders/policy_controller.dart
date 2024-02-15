import 'package:crafty_bay/data/models/policy_model.dart';
import 'package:crafty_bay/data/services/network_caller.dart';
import 'package:crafty_bay/data/utility/urls.dart';
import 'package:get/get.dart';

class PolicyController extends GetxController {
  bool _inProgress = false;

  String _errorMessage = '';

  PolicyModel _policyModel = PolicyModel();

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage;

  PolicyModel get policyModel => _policyModel;

  Future<bool> getPolicy() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final response = await NetworkCaller().getRequest(Urls.policy);
    _inProgress = false;
    if (response.isSuccess) {
      _policyModel = PolicyModel.fromJson(response.responseData);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    update();
    return isSuccess;
  }
}
