import 'package:flutter/material.dart';
import 'package:v_verify/screen/ServicesAndPrice/coupon_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../commonComponent/custom_button.dart';

class ApplyCouponScreen extends StatefulWidget {

  ApplyCouponScreen({super.key,});

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {

  final TextEditingController couponController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              height: MediaQuery.of(context).size.height * 0.4, // 30% of screen height
              width: MediaQuery.of(context).size.width * 0.8,  // optional width
              decoration: BoxDecoration(
                color: Colors.white, // white background
                borderRadius: BorderRadius.circular(12), // rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // shadow color
                    offset: const Offset(4, 4),           // horizontal & vertical offset
                    blurRadius: 10,                       // softness of shadow
                    spreadRadius: 2,                      // how far shadow spreads
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8), // highlight for 3D effect
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
                          color: Theme.of(context).primaryColorDark, fontSize: 16,),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: CouponTextField(
                          controller: couponController,
                          titleText: "Coupon Code",
                          hintText: "Enter Coupon Code Here..",
                          textInputType: TextInputType.text
                      ),
                    ),
                    const SizedBox(height: 5,),
                    CustomButton(
                      // isLoading: checkoutis CheckOutLoadingState,
                      onTap: () {

                      },
                      text:
                      "Redeem Coupon",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context)
                            .primaryColorLight
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
