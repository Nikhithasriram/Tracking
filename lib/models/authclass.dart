sealed class AuthResult {}

class Success extends AuthResult {}
class Failure extends AuthResult {
  String errorMessage;
  Failure({required this.errorMessage});
}
// class AuthResult {
//   bool success;
//   String? errorMessage;

//   AuthResult({required this.success, this.errorMessage});

// }