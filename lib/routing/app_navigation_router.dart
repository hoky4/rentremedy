import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentremedy_mobile/models/LeaseAgreement/lease_agreement.dart';
import 'package:rentremedy_mobile/providers/auth_model_provider.dart';
import 'package:rentremedy_mobile/view/onboarding/join_screen.dart';

class AppNavigationRouter extends StatefulWidget {
  const AppNavigationRouter({Key? key}) : super(key: key);

  @override
  _AppNavigationRouterState createState() => _AppNavigationRouterState();
}

class _AppNavigationRouterState extends State<AppNavigationRouter> {
  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      checkForNavigationEvent();
    });
  }

  void checkForNavigationEvent() async {
    var authModel = context.read<AuthModelProvider>();

    if (authModel.status == AuthStatus.loggedIn) {
      LeaseAgreement? leaseAgreement = authModel.leaseAgreement;

      if (leaseAgreement != null) {
        if (isSigned(leaseAgreement)) {
          Navigator.pushReplacementNamed(context, '/chat');
        } else {
          Navigator.pushReplacementNamed(
            context, '/terms', 
            arguments: JoinScreenArguments(leaseAgreement));
        }
      } else {
        Navigator.pushReplacementNamed(context, '/confirmation');
      }

    } else if (authModel.status == AuthStatus.notLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }

  bool isSigned(LeaseAgreement leaseAgreement) {
    if (leaseAgreement.signatures.isEmpty) {
      return false;
    }

    return true;
  }
}
