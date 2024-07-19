import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justcall/constants/collections.dart';
import 'package:justcall/hover/onhover.dart';
import 'package:justcall/middleware/bloc.dart';
import 'package:justcall/middleware/events.dart';
import 'package:justcall/middleware/state.dart';
import 'package:justcall/modals/products.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<JcProductListData> collectionListData =
      CollectionConstants.productConstants;

  void _incrementQuantitys(int index) {
    // print("object ${collectionListData[index].qty++}" );
    setState(() {
      collectionListData[index].qty++;
    });
  }

  void _decrementQuantitys(int index) {
    setState(() {
      if (collectionListData[index].qty! > 0) {
        collectionListData[index].qty--;
        print("object ${collectionListData[index].qty--}");
      }
    });
  }

  Future<void> sendJsonData(Map<String, dynamic> jsonData) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://justcalltest.onrender.com/api/users/createItemPurchase"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        // Successfully sent data
        // print('Data sent successfully');
      } else {
        // Error occurred while sending data
        // print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred
      // print('Exception occurred: $e');
    }
  }

  void _sendMessage(List<Product> products) async {


    String phoneNumber = '+971506279715'; // Replace with your phone number
    String message = 'Hello from Flutter!'; // Your message
    // Filter products where quantity is not equal to 0
    // final data = products.where((product) => product.qty != 0).toList();
    List<JcProductListData> filteredProducts =
        collectionListData.where((product) => product.qty != 0).toList();
    print("filteredProducts ${filteredProducts.length}");
    // Convert the filtered list to a text variable
    String filteredText = filteredProducts
        .map((product) =>
            '${product.name} - Quantity: ${product.qty} - Price: ${product.price},')
        .join('\n');

    String orderData = products.map((product) =>
    '${product.name} - Quantity: ${product.quantity} - Price: ${product.price},')
        .join('\n');

    final details = {"items": Uri.encodeFull(filteredText)};

    // await sendJsonData(details);
    // Encode the message to handle special characters
    String url =
        'https://wa.me/$phoneNumber/?text= Order List : ${Uri.encodeFull(orderData)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var count = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double widthSize = screenSize.width;
    double heightSize = screenSize.height;
    bool isMobile = MediaQuery.of(context).size.width < 750;
    final int maxItems = 8;

    return Scaffold(
      body: Container(
        // color: Color(0xFFE0FBE2),
        height: MediaQuery.of(context).size.height ,
        child: Stack(children: [
          Positioned(
            width: widthSize,
            top: 20,
            left: 20,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      context.go('/');
                    },
                    child: FaIcon(
                      FontAwesomeIcons.arrowLeftLong,
                      size: 20,
                      color: Colors.green,
                    )),
                SizedBox(
                  width: 10,
                ),
                Text('Cart',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                      decoration: TextDecoration.none,
                    )),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Container(),
                  //     Text("Our Collections",
                  //       style: GoogleFonts.pacifico(
                  //         fontSize : 35.sp ,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.grey,
                  //         decoration: TextDecoration.none,
                  //       ),
                  //     ),
                  //     OnHover(
                  //     builder: (isHovered) {
                  //       return
                  //       MouseRegion(
                  //         cursor: SystemMouseCursors.click,
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             // Navigator.push(
                  //             //   context,
                  //             //   MaterialPageRoute(builder: (context) =>
                  //             //       Filter()
                  //             //   ),
                  //             // );
                  //           },
                  //           child: Text("Filter",
                  //             style: GoogleFonts.teko(
                  //               fontSize: 25.sp,
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.green,
                  //               decoration: TextDecoration.none,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {


                    return state.grandTotal != 0 ?   Text(
                      'verify your product list',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                      ),
                    ) :   Text(
                      'Please add your favorites on cart',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                      ),
                    );
                  }),
      
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {

                          void _incrementQuantity(int index) {
                            // print("object ${collectionListData[index].qty++}" );
                            setState(() {
                              state.products[index].quantity + 1;
                            });
                          }

                          void _decrementQuantity(int index) {
                            setState(() {
                              if (state.products[index].quantity > 0) {
                                state.products[index].quantity - 1;
                              }
                            });
                          }
                      return ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
      
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: widthSize * 0.7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: GoogleFonts.teko(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            Text(
                                              'Quantity: ${product.quantity}',
                                              style: GoogleFonts.teko(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black54,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${product.quantity * product.price} AED",
                                        style: GoogleFonts.teko(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.deepOrange,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.red,
                                        onPressed:  () => {
                                          _decrementQuantity(index),
                                          context.read<ProductBloc>().add(RemoveProduct(product!.name as String))
                                        },
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                                        // color: Colors.blueGrey,
                                        child: Text(
                                            '${product!.quantity}',
                                            // "0",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,

                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                            )
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.green,
                                        onPressed: () =>
                                        {
                                          _incrementQuantity(index),
                                          context.read<ProductBloc>().add(AddProduct(product.name,product.price))
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Container(
                  //   child:
                  //   BlocBuilder<ProductBloc, ProductState>(
                  //       builder: (context, state) {
                  //
                  //         return GestureDetector(
                  //           onTap: (){
                  //             print("order data : ${state.products}");
                  //           },
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //            children: [
                  //              Text(
                  //                'Order c',
                  //                style: GoogleFonts.roboto(
                  //                  fontSize: 14,
                  //                  fontWeight: FontWeight.normal,
                  //                  color: Colors.white,
                  //                  decoration: TextDecoration.none,
                  //                ),
                  //              ),
                  //              SizedBox(width: 5,),
                  //              Text(
                  //                '${state.grandTotal} AED',
                  //                style: GoogleFonts.roboto(
                  //                  fontSize: 16,
                  //                  fontWeight: FontWeight.bold,
                  //                  color: Colors.white,
                  //                  decoration: TextDecoration.none,
                  //                ),
                  //              ),
                  //            ],
                  //           ),
                  //         );
                  //       }),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: BlocBuilder<ProductBloc, ProductState>(
                  //     builder: (context, state) {
                  //       return Text(
                  //         'Grand Total: ${state.grandTotal}',
                  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // Container(height: 100,)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: widthSize < 450
                ? 0
                : widthSize > 450
                    ? 12
                    : widthSize > 551 && widthSize < 800
                        ? 12
                        : 12,
            width: widthSize,
            child:
                BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    _sendMessage(state.products);
                    final pro = state.products[0];
                    print("object1 ${pro.name}");
                    print("object2 ${state.products}");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          0), // Set the border radius to 0 for a rectangular shape
                    ),
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child:
                      // Text(
                      //   "Place Order",
                      //   style: GoogleFonts.teko(
                      //     fontSize: 22.sp,
                      //     fontWeight: FontWeight.w500,
                      //     color: Colors.white,
                      //     decoration: TextDecoration.none,
                      //   ),
                      // )
                      // BlocBuilder<ProductBloc, ProductState>(
                      //     builder: (context, state) {
      
                      // return
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Order Grand Total',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${state.grandTotal} AED',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  )
                  // }),
                  );
            }),
            // :
            // ElevatedButton(
            //         onPressed: () {
            //           _sendMessage();
            //         },
            //         style: ElevatedButton.styleFrom(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(
            //                 0), // Set the border radius to 0 for a rectangular shape
            //           ),
            //           backgroundColor: Colors.green,
            //           minimumSize: Size(double.infinity, 50),
            //         ),
            //         child: Text(
            //           "Order",
            //           style: GoogleFonts.teko(
            //             fontSize: 22.sp,
            //             fontWeight: FontWeight.w500,
            //             color: Colors.white,
            //             decoration: TextDecoration.none,
            //           ),
            //         ))
          )
        ]),
      ),
    );
  }
}
