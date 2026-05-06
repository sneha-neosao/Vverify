import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/apply_coupon_bloc/apply_coupon_cubit.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/apply_coupon_bloc/apply_coupon_state.dart';
import 'package:v_verify/screen/ServicesAndPrice/coupon_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../commonComponent/custom_button.dart';

class ApplyCouponScreen extends StatefulWidget {
  final String subTotal;
  final String entity_id;

  ApplyCouponScreen(
      {super.key, required this.subTotal, required this.entity_id});

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController couponController = TextEditingController();
  @override
  void initState() {
    print("entity is at apply coupon: ${widget.entity_id}");
    // TODO: implement initState
    super.initState();
  }

  void applyCoupon(String subtotal, String couponCode) {
    final String customerId = context.read<IdCubit>().state;
    String token = context.read<TokenCubit>().state;

    // 👇 Print the data being sent
    print("Applying coupon with data:");
    print("Token: $token");
    print("Customer ID: $customerId");
    print("Subtotal: $subtotal");
    print("Coupon Code: $couponCode");

    //context.read<ApplyCouponCubit>().applyCoupon(token: token, customer_id: customerId, subtotal: subtotal, coupon_code: couponCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/couponbg.png",
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.4, // 30% of screen height
              width: MediaQuery.of(context).size.width * 0.8, // optional width
              decoration: BoxDecoration(
                color: Colors.white, // white background
                borderRadius: BorderRadius.circular(12), // rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // shadow color
                    offset: const Offset(4, 4), // horizontal & vertical offset
                    blurRadius: 10, // softness of shadow
                    spreadRadius: 2, // how far shadow spreads
                  ),
                  BoxShadow(
                    color: Colors.white
                        .withOpacity(0.8), // highlight for 3D effect
                    offset: const Offset(-4, -4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/gift.png",
                      height: 68,
                      width: 68,
                    ),
                    Text(
                      "Have a coupon ? Apply it here to save more on your order.",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 16,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: CouponTextField(
                          controller: couponController,
                          titleText: "Coupon Code",
                          hintText: "Enter Coupon Code Here..",
                          textInputType: TextInputType.text),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocConsumer<ApplyCouponCubit, ApplyCouponState>(
                        listener: (context, coupon) {
                      if (coupon is ApplyCouponSuccessState) {
                        if (coupon.applyCouponModel.status == 200) {
                          context.pushNamed("servicesAndPrice",
                              pathParameters: {'id': widget.entity_id});
                        }

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(coupon.applyCouponModel.message!)));
                      } else if (coupon is ApplyCouponErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(coupon.message)));
                      }
                    }, builder: (context, coupon) {
                      return CustomButton(
                        isLoading: coupon is ApplyCouponLoadingState,
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState?.validate() ?? false) {
                            applyCoupon(widget.subTotal, couponController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please fill all fields")));
                          }
                        },
                        text: "Redeem Coupon",
                        gradientColors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorLight
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
