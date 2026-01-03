import 'package:flutter/material.dart';
import 'package:v_verify/screen/Payment%20Successful/payment_successful.dart';

class BankList {
  String image;
  String name;
  BankList({required this.image, required this.name});
}

List<BankList> bankList = [
  BankList(image: "assets/images/axis.png", name: "Axis"),
  BankList(image: "assets/images/citi.png", name: "citi"),
  BankList(image: "assets/images/icici.png", name: "ICICI"),
  BankList(image: "assets/images/hdfc.png", name: "HDFC"),
];


class UpiList {
  String image;
  String name;

  UpiList({required this.image, required this.name});
}

List<UpiList> upiList = [
  UpiList(image: "assets/images/phone_pay.png", name: "PhonePay"),
  UpiList(image: "assets/images/g_pay.png", name: "GPay"),
  UpiList(image: "assets/images/paytem.png", name: "Paytem"),
];

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Options",
              style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
            ),
            RichText(
              text: TextSpan(
                text: 'Payment of ',
                style: Theme.of(context).textTheme.bodySmall,
                children: <TextSpan>[
                  TextSpan(
                      text: '₹3100/-',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: 16,),
            Text("Net banking",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),),
            const SizedBox(height: 4,),
            Card(
              elevation: 5,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: bankList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        bankList[index].image,
                                        width: 35,
                                        height: 35,
                                      ),
                                      const SizedBox(height: 4,),
                                      Text(bankList[index].name)
                                    ],
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                    const Divider(),
                    ListTile(
                      leading: Image.asset(
                        "assets/images/payment_home.png",
                        width: 30,
                      ),
                      title: Text(
                        "Choose another bank",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16,),
            Text("Card",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),),
            const SizedBox(height: 4,),
            ListTile(
              tileColor:Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              leading: Image.asset('assets/images/payment_card.png',width: 30,),
              title:   Text("Credit/Debit Card",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),),
              trailing: const Icon(Icons.arrow_forward_ios,size: 16,),

            ),
            const SizedBox(height: 16,),
            Text("Pay by UPI",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),),
            const SizedBox(height: 4,),
            Card(
              elevation: 5,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: upiList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const PaymentSuccessful()));
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          upiList[index].image,
                                          width: 35,
                                          height: 35,
                                        ),
                                        const SizedBox(height: 4,),
                                        Text(upiList[index].name)
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                    const Divider(),
                    ListTile(
                      leading: Image.asset(
                        "assets/images/upi_add.png",
                        width: 30,
                      ),
                      title: Text(
                        "Add new UPI ID",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
