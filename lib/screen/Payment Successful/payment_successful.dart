import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/all_entities_bloc/all_entities_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_entities_cubit.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_count_bloc.dart';

import '../Bottom/bottomNavbar.dart';

class PaymentSuccessful extends StatefulWidget {
  const PaymentSuccessful({super.key});

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tokenCubit = context.read<TokenCubit>();
      final idCubit = context.read<IdCubit>();

      await tokenCubit.getToken();
      await idCubit.getId();

      if (!mounted) return;

      final token = tokenCubit.state;
      final customerId = idCubit.state;

      if (token.isNotEmpty && customerId.isNotEmpty) {
        context
            .read<AllEntitiesCubit>()
            .getAllEntities(token: token, customer_id: customerId);
        context
            .read<DashboardEntitiesCubit>()
            .getDashboardEntities(token: token, customerId: customerId);
        context
            .read<DashboardCountBloc>()
            .getDashboardCount(token: token, customerId: customerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animation/payment_successful.json',
                width: 250, repeat: false),
            const SizedBox(
              height: 28,
            ),
            Text(
              'Payment Successful',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 28),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              textAlign: TextAlign.center,
              "You will receive your payment receipt on your registered number.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 24,
            ),
            CustomButton(
              onTap: () {
                selectedIndex = 1;
                context.pushReplacementNamed("bottomNav");
              },
              text: "Continue to verification",
              width: ScreenSize.screenWidth * 0.6,
              gradientColors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight
              ],
            )
          ],
        ),
      ),
    );
  }
}
