class Urls {
  static const String _baseUrl = "http://ecom-api.teamrabbil.com/api";

  static String sentEmailOtp(String email) => "$_baseUrl/UserLogin/$email";

  static String verifyOtp(String email, String otp) =>
      "$_baseUrl/VerifyLogin/$email/$otp";
  static String readProfile = "$_baseUrl/ReadProfile";
  static String createProfile = "$_baseUrl/CreateProfile";
  static String homeBanner = "$_baseUrl/ListProductSlider";
  static String categoryList = "$_baseUrl/CategoryList";
  static String popularProduct = "$_baseUrl/ListProductByRemark/Popular";
  static String specialProduct = "$_baseUrl/ListProductByRemark/Special";
  static String newProduct = "$_baseUrl/ListProductByRemark/New";
  static String brandList = "$_baseUrl/BrandList";

  static String listProductByBrand(int brandId) =>
      "$_baseUrl/ListProductByBrand/$brandId";

  static String productsByCategory(int categoryId) =>
      "$_baseUrl/ListProductByCategory/$categoryId";

  static String productDetails(int productId) =>
      "$_baseUrl/ProductDetailsById/$productId";

  static String addToCart = "$_baseUrl/CreateCartList";

  static String cartList = "$_baseUrl/CartList";

  static String deleteCartList(int id) => "$_baseUrl/DeleteCartList/$id";

  static String createInvoice = "$_baseUrl/InvoiceCreate";

  static String invoiceSuccess =
      "$_baseUrl/PaymentSuccess?trn_id=64d1f9d602914";

  static String createWishList(int wishProductId) =>
      "$_baseUrl/CreateWishList/$wishProductId";

  static String productWishList = "$_baseUrl/ProductWishList";

  static String removeWishList(int wishId) =>
      "$_baseUrl/RemoveWishList/$wishId";

  static String policy = "$_baseUrl/PolicyByType/about";

  static String listReviewByProduct(int reviewProductId) =>
      "$_baseUrl/ListReviewByProduct/$reviewProductId";

  static String createProductReview = "$_baseUrl/CreateProductReview";
}
