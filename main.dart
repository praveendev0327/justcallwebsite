
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:justcall/init/Initial.dart';
import 'package:justcall/middleware/bloc.dart';
import 'package:justcall/screens/addproduct.dart';
import 'package:justcall/screens/admin.dart';
import 'package:justcall/screens/cart.dart';
import 'package:justcall/screens/category.dart';
import 'package:justcall/screens/form.dart';
import 'package:justcall/screens/landing.dart';
import 'package:justcall/screens/login.dart';
import 'package:justcall/screens/offer.dart';
import 'package:justcall/screens/product.dart';
import 'package:justcall/screens/productdashboard.dart';
import 'package:justcall/screens/profile.dart';
import 'package:justcall/screens/test.dart';
import 'package:justcall/submain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Initial(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => Landing(),
      ),
      GoRoute(
        path: '/category',
        builder: (context, state) => Category(),
      ),
      GoRoute(
        path: '/offers',
        builder: (context, state) => Offers(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => Profile(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => Cart(),
      ),
      GoRoute(
        path: '/addproduct',
        builder: (context, state) => AddProductDashboard(),
      ),
      GoRoute(
        path: '/productdashboard',
        builder: (context, state) => ProductDashboard(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => Login(),
      ),
      // Add other routes as needed...
    ],
  );
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double widthSize = screenSize.width;
    double heightSize = screenSize.height;
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: MaterialApp.router(
        title: 'JustCall',
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        // home: SubMain(),
        // home: const Login(),
        // home: Scaffold(body: Initial()),
        // home: MaterialApp.router(
        //   routerConfig: _router,
        //   debugShowCheckedModeBanner: false,
        //
        // ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String loginStatus = '0';
  //
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _loadUsername();
  // }
  //
  // Future<void> _loadUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     loginStatus = prefs.getString('login') ?? '0';
  //   });
  //   print("object${loginStatus}");
  // }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double widthSize = screenSize.width;
    double heightSize = screenSize.height;


    final GoRouter _router = GoRouter(
      // initialLocation: loginStatus == "0" ? '/' : loginStatus == "1" ? '/productdashboard' : '/' ,
      initialLocation:'/' ,

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              Initial(),
             // ProductDashboard(),
          // Login(),
          // MyCustomForm(),
          // Test(),
          routes: [
            GoRoute(
              path: 'productlist',
              builder: (context, state) {
                // final type = state.pathParameters['type']!;
                return Products();
              },
            ),
            GoRoute(
              path: 'profile',
              builder: (context, state) => Profile(),
            ),
            // GoRoute(
            //   path: 'product/:id',
            //   builder: (context, state) {
            //     final id = state.pathParameters['id']!;
            //     return ViewProduct(id: id,);
            //   },
            // ),

          ],
        ),
        // GoRoute(
        //   path: '/home',
        //   builder: (context, state) => Landing(),
        // ),
        // GoRoute(
        //   path: '/offers',
        //   builder: (context, state) => Offers(),
        // ),
        // GoRoute(
        //   path: '/products',
        //   builder: (context, state) => Products(),
        // ),
        // GoRoute(
        //   path: '/cart',
        //   builder: (context, state) => Cart(),
        // ),
        // GoRoute(
        //   path: '/profile',
        //   builder: (context, state) => Profile(),
        // ),
        // GoRoute(
        //   path: '/login',
        //   builder: (context, state) => Login(),
        // ),
        // GoRoute(
        //   path: '/admin',
        //   builder: (context, state) => Admin(),
        // ),
        // GoRoute(
        //   path: '/productdashboard',
        //   builder: (context, state) => ProductDashboard(),
        // ),
      ],
      observers: [MyRouteObserver()],
    );

    return
      // Scaffold(
      // body: ScreenUtilInit(
      //     designSize: Size(widthSize, heightSize),
      //     child: Initial()
      // ),);
      Scaffold(
        // resizeToAvoidBottomInset: false,
        body: BlocProvider(
          create: (context) => ProductBloc(),
          child: ScreenUtilInit(
              designSize: Size(widthSize, heightSize),
              child:
              // MaterialApp(
              //     title: 'Jodilier',
              //     debugShowCheckedModeBanner: false,
              //     home: Login()
              MaterialApp.router(
                title: 'JustCall',
                debugShowCheckedModeBanner: false,
                routerDelegate: _router.routerDelegate,
                routeInformationParser: _router.routeInformationParser,
                routeInformationProvider: _router.routeInformationProvider,
              // )

            ),
          ),
        ),
      );
  }
}

class MyRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // Handle route change events here
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // Handle route pop events here
    super.didPop(route, previousRoute);
  }
}
