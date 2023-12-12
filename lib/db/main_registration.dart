import 'package:remake_simple_app/db/registration_data.dart';
import 'package:remake_simple_app/db/registration_file.dart';

void main() async {
  final registrationData =
      RegistrationData(name: 'John Doe', email: 'john@example.com');

  await RegistrationFile.writeRegistrationData(registrationData);

  final savedRegistrationData = await RegistrationFile.readRegistrationData();
  if (savedRegistrationData != null) {}
}
