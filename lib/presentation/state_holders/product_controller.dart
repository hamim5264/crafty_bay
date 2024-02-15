import 'package:crafty_bay/data/models/product_list_model.dart';
import 'package:crafty_bay/data/services/network_caller.dart';
import 'package:crafty_bay/data/utility/urls.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  bool _inProgress = false;

  String _errorMessage = '';

  ProductListModel _productListModel = ProductListModel();

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage;

  ProductListModel get productListModel => _productListModel;

  Future<bool> getProductList({required int categoryId}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final response =
        await NetworkCaller().getRequest(Urls.productsByCategory(categoryId));
    _inProgress = false;
    if (response.isSuccess) {
      _productListModel = ProductListModel.fromJson(response.responseData);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    update();
    return isSuccess;
  }
}
