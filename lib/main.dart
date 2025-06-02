import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subscription_manager/features/subscriptions/data/datasources/static_subscription_datasource.dart';
import 'package:subscription_manager/features/subscriptions/data/repositories/subscription_repository_impl.dart';
import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:subscription_manager/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'package:subscription_manager/features/welcome/presentation/screens/welcome_screen.dart';
import 'core/theme/app_theme.dart';
import 'package:subscription_manager/features/home/presentation/screens/home_screen.dart';

const String kSubscriptionsBoxName = 'subscriptions_box';
const String kCategoriesBoxName = 'categories_box';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(BillingCycleAdapter());
  Hive.registerAdapter(SubscriptionAdapter());

  final subscriptionBox = await Hive.openBox<Subscription>(
    kSubscriptionsBoxName,
  );
  final categoryBox = await Hive.openBox<String>(kCategoriesBoxName);

  // Initialize the static subscription datasource
  final staticSubscriptionDatasource = StaticSubscriptionDatasource();

  final SubscriptionRepository subscriptionRepository =
      SubscriptionRepositoryImpl(
        subscriptionBox: subscriptionBox,
        categoryBox: categoryBox,
        staticSubscriptionDatasource: staticSubscriptionDatasource,
      );

  runApp(MyApp(subscriptionRepository: subscriptionRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.subscriptionRepository});

  final SubscriptionRepository subscriptionRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubscriptionBloc(subscriptionRepository: subscriptionRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Subscription Manager',
        theme: appTheme,
        home: const WelcomeScreen(),
        routes: {HomeScreen.routeName: (context) => const HomeScreen()},
      ),
    );
  }
}
