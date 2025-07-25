class ApiEndpoints {
  // Base URL for the API
  static const String baseUrl = 'http://192.168.1.3:3000';

  // Authentication endpoints
  static const String createUser = '$baseUrl/users/create';
  static const String getUserProfile = '$baseUrl/users/profile';

  // // User endpoints
  // static const String userProfile = '$baseUrl/user/profile';
  // static const String updateUserProfile = '$baseUrl/user/update';

  // // Expense endpoints
  // static const String expenses = '$baseUrl/expenses';
  // static const String addExpense = '$baseUrl/expenses/add';
  // static const String updateExpense = '$baseUrl/expenses/update';
  // static const String deleteExpense = '$baseUrl/expenses/delete';

  // // Category endpoints
  // static const String categories = '$baseUrl/categories';
  // static const String addCategory = '$baseUrl/categories/add';
}
