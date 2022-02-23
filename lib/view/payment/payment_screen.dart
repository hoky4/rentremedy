import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentremedy_mobile/Model/Payments/payment.dart';
import 'package:rentremedy_mobile/Providers/api_service_provider.dart';
import 'package:rentremedy_mobile/View/Payment/payment_success_screen.dart';

class PaymentScreen extends StatelessWidget {
  Payment payment;
  PaymentScreen({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pay Balance"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    balanceInfo(),
                    const Divider(
                        thickness: 1, indent: 32, endIndent: 32, height: 48),
                  ],
                ),
              ),
            ),
            acceptButton(context, payment.id),
            const SizedBox(height: 8.0)
          ],
        ),
      ),
    );
  }

  Widget balanceInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 200.0, 0, 0),
      child: Align(
        // alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Balance", style: categoryStyle),
            // SizedBox(height: 8.0),
            Text("\$${convertToDollar(payment.chargeAmount)}",
                style: amountStyle),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Due: ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                Text(DateFormat.yMMMMd('en_US').format(payment.dueDate),
                    style: bodyStyle),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget acceptButton(BuildContext context, String leaseAgreemenId) {
    ApiServiceProvider apiService =
        Provider.of<ApiServiceProvider>(context, listen: false);

    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.green,
            fixedSize: const Size(200, 72),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),

        // ButtonStyle(
        //   backgroundColor: MaterialStateProperty.all(Colors.green),
        //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(24.0),
        //     ),
        //   ),
        // ),
        onPressed: () async {
          try {
            await apiService.makePaymentIntent(payment.id);
            // Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PaymentSuccessScreen()));
          } on Exception catch (e) {
            print("Exception while making payment intent.");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        child: const Text('Pay Balance',
            style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w400)),
      ),
    );
  }

  String convertToDollar(amount) {
    final value = amount / 100;
    final money = NumberFormat("###,###,###", "en_us");
    return money.format(value);
  }
}

TextStyle categoryStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.w400, fontSize: 24, color: Colors.black);

TextStyle bodyStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black);

TextStyle amountStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.normal, fontSize: 48, color: Colors.black);
