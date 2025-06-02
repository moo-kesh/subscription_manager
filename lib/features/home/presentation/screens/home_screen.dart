import 'package:flutter/material.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';
import 'package:subscription_manager/core/animations/scale_animation.dart';
import 'package:subscription_manager/features/dashboard/presentation/screens/general_screen.dart';
import 'package:subscription_manager/features/subscriptions/presentation/screens/my_subs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Center(
          child: ScaleAnimationWidget(
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: kSurfaceColor,
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(Icons.menu, color: kTextColor),
              onPressed: () {},
            ),
          ),
        ),
        centerTitle: true,
        title: ScaleAnimationWidget(
          child: SizedBox(
            height: 38.0,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: kSurfaceColor,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: TabBar(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.center,
                  indicatorWeight: 0.0,
                  isScrollable: false,
                  controller: _tabController,
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kPrimaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _tabController.index == 0
                                ? Icons.dashboard
                                : Icons.dashboard_outlined,
                            size: 18.0,
                          ),
                          AnimatedCrossFade(
                            firstChild: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('General'),
                            ),
                            secondChild: const SizedBox.shrink(),
                            crossFadeState: _tabController.index == 0
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _tabController.index == 1
                                ? Icons.subscriptions
                                : Icons.subscriptions_outlined,

                            size: 18.0,
                          ),
                          AnimatedCrossFade(
                            firstChild: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('My Subs'),
                            ),
                            secondChild: const SizedBox.shrink(),
                            crossFadeState: _tabController.index == 1
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          ScaleAnimationWidget(
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: kSurfaceColor,
                padding: EdgeInsets.zero,
              ),
              icon: Icon(Icons.notifications_none_outlined, color: kTextColor),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [GeneralScreen(), MySubsScreen()],
      ),
    );
  }
}
