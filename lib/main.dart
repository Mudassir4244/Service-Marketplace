// ignore_for_file: unused_import

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:servable/Inbox/chatscreen.dart';
import 'package:servable/Inbox/inbox.dart';
import 'package:servable/Screens/category_selection.dart';
import 'package:servable/Screens/constructions_services.dart';
import 'package:servable/Screens/fashion_category_service.dart';
import 'package:servable/Screens/vehical_service_category.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/Screens/worker_homescreen.dart';
import 'package:servable/controller/langauage_chnage_controller.dart';
import 'package:servable/customer_view/allworker.dart';
import 'package:servable/customer_view/registration.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/customer_view/settings.dart';
import 'package:servable/customer_view/vechical_subcat_setect.dart';
import 'package:servable/service_providers/architectures.dart';
import 'package:servable/service_providers/bikerepair.dart';
import 'package:servable/service_providers/carpenters.dart';
import 'package:servable/service_providers/cartowing.dart';
import 'package:servable/service_providers/carwash.dart';
import 'package:servable/service_providers/cctv_installation.dart';
import 'package:servable/service_providers/chefs.dart';
import 'package:servable/service_providers/civil_engineers.dart';
import 'package:servable/service_providers/electrician_profile.dart';
import 'package:servable/service_providers/eventdecoration.dart';
import 'package:servable/service_providers/gerdeners.dart';
import 'package:servable/service_providers/homecleaners.dart';
import 'package:servable/service_providers/labour.dart';
import 'package:servable/service_providers/mechanic.dart';
import 'package:servable/service_providers/movers.dart';
import 'package:servable/service_providers/pestcontrol.dart';
import 'package:servable/service_providers/plumbers_profiles.dart';
import 'package:servable/service_providers/tailor.dart';
import 'package:servable/service_providers/worker_account.dart';
import 'package:servable/splashsreens/splashscreen.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
// import 'package:servable/l10n/app';

 

void main ()
async{   

    WidgetsFlutterBinding.ensureInitialized();
    
     await Supabase.initialize(
    url: 'https://chleafzniqdbnmkvhlpy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNobGVhZnpuaXFkYm5ta3ZobHB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NjM5MjcsImV4cCI6MjA2MzEzOTkyN30.fG74XNEFiQkBAT-t6UpZEcyZFszkur32j1OtFuk38qs',
  );
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    
);
    
    runApp(
      
     MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>TabBarProvider()),
      ChangeNotifierProvider(create: (_)=>Themeprovider()),
      ChangeNotifierProvider(create: (_)=>CheckboxProvider()),
      ChangeNotifierProvider(create: (_)=>WorkerImagePickerProvider ()),
      ChangeNotifierProvider(create: (_)=>CustomerImageProvider()),
      ChangeNotifierProvider(create: (_)=>CustomerProvider()),
      ChangeNotifierProvider(create: (_)=>WorkerAccount()),
      ChangeNotifierProvider(create: (_)=>Workertabbar()),
      ChangeNotifierProvider(create: (_)=>CarpentersProvider()),
      ChangeNotifierProvider(create: (_)=>PlumberProvider()),
      ChangeNotifierProvider(create: (_)=>TailorProvider()),
      ChangeNotifierProvider(create: (_)=>ChefProvider()),
      ChangeNotifierProvider(create: (_)=>MechanicProvider()),
      ChangeNotifierProvider(create: (_)=>ElectricianProvider()),
      ChangeNotifierProvider(create: (_)=>LabourProvider()),
      ChangeNotifierProvider(create: (_)=>GardenerProvider()),
      ChangeNotifierProvider(create: (_)=>WorkerDataProvider()),
      ChangeNotifierProvider(create: (_)=>ChatProvider()),
      ChangeNotifierProvider(create: (_)=>ChatSelectionProvider()),
      ChangeNotifierProvider(create: (_)=>CleanerProvider()),
      ChangeNotifierProvider(create: (_)=>PestControllersProvider()),
      ChangeNotifierProvider(create: (_)=>moversproviders()),
      ChangeNotifierProvider(create: (_)=>eventproviders()),
      ChangeNotifierProvider(create: (_)=>cctv_providers()),
      ChangeNotifierProvider(create: (_)=>CarWashProvider()),
      ChangeNotifierProvider(create: (_)=>VehicalProvider()),
      ChangeNotifierProvider(create: (_)=>ConstructionsServices()),
      ChangeNotifierProvider(create: (_)=>fashionservice()),
      ChangeNotifierProvider(create: (_)=>VehicleSubcatServices()),
      ChangeNotifierProvider(create: (_)=>towingprovider()),
      ChangeNotifierProvider(create: (_)=>bikerepairing()),
      ChangeNotifierProvider(create: (_)=>civilprovider()),
      ChangeNotifierProvider(create: (_)=>architectproviders()),
      ChangeNotifierProvider(create: (_)=>LangauageChnageController()),
      ChangeNotifierProvider(create: (_)=>LanguageProvider())
     ],
     child: MyApp(),)
     
    );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  @override
  Widget build(BuildContext context) {
     final themeprovider = Provider.of<Themeprovider>(context);
    //  final provider = Provider.of<Language>(context);
    return Consumer<LangauageChnageController>(builder:(context , Provider ,child){
      return  MaterialApp(
    title: 'Flutter Demo',
    locale: Provider.locale,
    localizationsDelegates: [
      // AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate

    ],
    supportedLocales: const [
      Locale('en'),
      Locale('ur')
    ],
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
      themeMode:  themeprovider.themeMode,
      home: Splashscreen(
          
      ),
    );
    } 
    );
  }
}
