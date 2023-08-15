import 'package:batnf/constants.dart/app_colors.dart';
import 'package:batnf/core/state/view_state.dart';
import 'package:batnf/features/home/data/projects/controller/controller.dart';
import 'package:batnf/features/home/data/projects/controller/home_screen_controller.dart';
import 'package:batnf/features/home/presentation/widgets/about_us_tab_page.dart';
import 'package:batnf/features/home/presentation/widgets/category_buttion.dart';
import 'package:batnf/features/home/presentation/widgets/event_tab_page.dart';
import 'package:batnf/features/home/presentation/widgets/media_center_tab_page.dart';
import 'package:batnf/features/home/presentation/widgets/projects_tab_page.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_shimmer_loader.dart';
import 'home_video.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.menu);
                },
                child: Transform.scale(
                  scale: 1.2,
                  child: Image.asset("assets/images/menu.png"),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 250,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("https://picsum.photos/id/237/200/300"),
                fit: BoxFit.cover),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Stack(
          children: [
            TabBar(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              labelPadding: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              indicatorColor: AppColors.primary,
              indicatorPadding: const EdgeInsets.all(0),
              tabs: const [
                Tab(
                  child: TextWidget(
                    text: "About Us",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Tab(
                    child: TextWidget(
                  text: "Projects",
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
                Tab(
                    child: TextWidget(
                  text: "Media Center",
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
                Tab(
                    child: TextWidget(
                  text: "Events",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, 70),
              child: SizedBox(
                height: 620,
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: controller,
                  children: const [
                    AboutUsTabPage(),
                    ProjectsTabPage(),
                    MediaCenterTabPage(),
                    EventTabPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final _controller = Get.put(HomeController());
  final homeScreenController = Get.find<HomeScreenController>();
  @override
  void initState() {
    callFunction();
    super.initState();
  }
  List<CategoryButtonModel> categoryButtonData = [
    CategoryButtonModel("About Us"),
    CategoryButtonModel("Projects"),
    CategoryButtonModel("Media Center"),
    CategoryButtonModel("Events"),
  ];

  void callFunction(){
    Future.wait([
      _controller.getAllNews(),
      _controller.getAllEvents(),
      _controller.getAllProjects(),
    ]);
  }

  int selectedButtonIndex = 0;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
        builder: (controller){
      return Builder(builder: (context){
        if(controller.projectDateStateView.state == ResponseState.loading){
          return const HomeShimmerLoader();
        }else if(controller.projectDateStateView.state == ResponseState.complete){
          if(controller.projectDateStateView.data!.isEmpty){
            return Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60,),
                Image.asset("assets/images/no-data.png", height: 80, width: 80,),
                const SizedBox(height: 15,),
                Text("You do not have any project", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black,
                    fontSize: 15, fontWeight: FontWeight.w500),),
              ],
            );
          }else{
            return Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 50,
                  ),
                ),
                actions:  [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.menu);
                      },
                      child: Transform.scale(
                        scale: 1.2,
                        child: Image.asset("assets/images/menu.png", height: 30, width: 30,),
                      ),
                    ),
                  )
                ],
                backgroundColor: Colors.white, elevation: 0.0,
              ),
              backgroundColor: Colors.white,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 3.6, floating: false,
                    automaticallyImplyLeading: false, backgroundColor: Colors.white, pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background:  Builder(builder: (context) {
                        final data = controller.homeFileDataStateView.data?.first;
                        return Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                    height: 180,
                                    scrollDirection: Axis.horizontal,
                                    padEnds: true,
                                    enableInfiniteScroll: false,
                                    autoPlayCurve: Curves.easeInQuint,
                                    viewportFraction: 1,
                                    autoPlay: false),
                                items:
                                [
                                  data == null ? const Center(child: CupertinoActivityIndicator(),) :
                                  HomeVideo(thumbnailUrl: data.files!.first.thumbnail!, videoUrl: data.files!.first.fileUrl!,),
                                ],
                              ),)
                        );
                      }),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 42.0,
                      child: Center(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,  shrinkWrap: true,
                          itemCount: categoryButtonData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedButtonIndex = index;
                                });
                              },
                              child: CategoryButton(title: categoryButtonData[index].buttonTitle ?? "",
                                color: selectedButtonIndex == index ? AppColors.primary : Colors.transparent, index: index, ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 20);
                        },
                        ),
                      ),
                    ),
                  ),
                  selectedButtonIndex == 0 ?
                  const SliverToBoxAdapter(child: AboutUsTabPage()) :
                  selectedButtonIndex == 1 ?
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 15,bottom: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0, top: 10),
                                child: GestureDetector(
                                  onTap: ()=>Navigator.pushNamed(context, Routes.projectDetails, arguments: controller.projectDateStateView.data![index].projectId),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 4,
                                        child: Container(
                                          height: 100, decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                opacity: 0.2,
                                                image: AssetImage(
                                                  'assets/images/Bc.png',
                                                ),
                                                fit: BoxFit.cover),
                                            color: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(18)),
                                          margin: const EdgeInsets.only(
                                              bottom: 7.0, top: 7.0, left: 9.0),
                                          child: controller.projectDateStateView.data![index].files!.first.fileExt ==
                                              'image' && controller.projectDateStateView.data![index].files!.first.fileUrl!.isNotEmpty
                                              ? ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                                errorWidget: (context, url,
                                                    error) =>
                                                const Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                placeholder:
                                                    (context, url) =>
                                                const Center(
                                                  child:
                                                  CupertinoActivityIndicator(),
                                                ),
                                                imageUrl: 'https://www.batnf.net/${controller.projectDateStateView.data![index].files![index].fileUrl}',
                                                fit: BoxFit.cover),
                                          )
                                              : ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                                errorWidget: (context, url, error) =>
                                                const Center(
                                                  child: Icon(Icons.error, color: Colors.black,),),
                                                placeholder: (context, url) =>
                                                const Center(child: CupertinoActivityIndicator(),),
                                                imageUrl: 'https://www.batnf.net/${controller.projectDateStateView.data![index].files!.first.thumbnail}',
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15,),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Text(
                                              controller.projectDateStateView.data![index].projectTitle ?? "",
                                              style: const TextStyle(
                                                  color: AppColors.titleBlack,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: 'Inter',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              // kNewsSubHeader,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.left,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              controller.projectDateStateView.data![index].projectDescription ?? "",
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              textAlign: TextAlign.start,
                                            ),
                                            // const SizedBox(height: 6),
                                            // Text(
                                            //   controller.projectDateStateView.data![index].projectStartDate ?? "",
                                            //   textAlign: TextAlign.left,
                                            //   style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                                            // )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Divider(),
                            ],
                          );
                        },
                        childCount: controller.projectDateStateView.data!.length > 2 ? 2 : controller.projectDateStateView.data!.length, // 1000 list items
                      ),
                    ),
                  ) :
                  selectedButtonIndex == 2 ?
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 15,bottom: 20, right: 15),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ...List.generate(controller.newsDateStateView.data!.length > 2 ? 2 : controller.newsDateStateView.data!.length, (index){
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: ()=>Navigator.pushNamed(context, Routes.mediaItemsCenterDetails, arguments: controller.newsDateStateView.data![index].newsId),
                                child: Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text(
                                                controller.newsDateStateView.data![index].title ?? "",
                                                style: const TextStyle(
                                                    color: AppColors.titleBlack,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Inter',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                                // kNewsSubHeader,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                controller.newsDateStateView.data![index].information ?? "",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                controller.newsDateStateView.data![index].entryDate ?? "",
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            height: 100,
                                            child: controller.newsDateStateView.data![index].files![0].fileExt ==
                                                'image/png' && controller.newsDateStateView.data![index].files![index].fileUrl!.isNotEmpty
                                                ? ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                  errorWidget: (context, url,
                                                      error) =>
                                                  const Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  placeholder:
                                                      (context, url) =>
                                                  const Center(
                                                    child:
                                                    CupertinoActivityIndicator(),
                                                  ),
                                                  imageUrl: 'https://www.batnf.net/${controller.newsDateStateView.data![index].files![index].fileUrl}',
                                                  fit: BoxFit.cover),
                                            )
                                                : ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                  errorWidget: (context, url, error) =>
                                                  const Center(
                                                    child: Icon(Icons.error, color: Colors.black,),),
                                                  placeholder: (context, url) =>
                                                  const Center(child: CupertinoActivityIndicator(),),
                                                  imageUrl: 'https://www.batnf.net/${controller.newsDateStateView.data![index].files![0].thumbnail}',
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15,),
                                    const Divider()
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ) : SliverPadding(
                    padding: const EdgeInsets.only(left: 15,bottom: 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ...List.generate(controller.eventDateStateView.data!.length > 2 ? 2 : controller.eventDateStateView.data!.length, (index){
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: ()=>Navigator.pushNamed(context, Routes.eventDetails, arguments: controller.eventDateStateView.data![index].eventId),
                                child: Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text(
                                                controller.eventDateStateView.data![index].eventName ?? "",
                                                style: const TextStyle(
                                                    color: AppColors.titleBlack,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Inter',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                                // kNewsSubHeader,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                controller.eventDateStateView.data![index].eventDesc ?? "",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                controller.eventDateStateView.data![index].eventStartDate ?? "",
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            height: 100,
                                            child: controller.eventDateStateView.data![index].files![0].fileExt ==
                                                'image/png' && controller.eventDateStateView.data![index].files![index].fileUrl!.isNotEmpty
                                                ? ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                  errorWidget: (context, url,
                                                      error) =>
                                                  const Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  placeholder:
                                                      (context, url) =>
                                                  const Center(
                                                    child:
                                                    CupertinoActivityIndicator(),
                                                  ),
                                                  imageUrl: 'https://www.batnf.net/${controller.eventDateStateView.data![index].files![index].fileUrl}',
                                                  fit: BoxFit.cover),
                                            )
                                                : ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                  errorWidget: (context, url, error) =>
                                                  const Center(
                                                    child: Icon(Icons.error, color: Colors.black,),),
                                                  placeholder: (context, url) =>
                                                  const Center(child: CupertinoActivityIndicator(),),
                                                  imageUrl: 'https://www.batnf.net/${controller.eventDateStateView.data![index].files![0].thumbnail}',
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15,),
                                    const Divider()
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      selectedButtonIndex == 0 ? const SizedBox() :
                      GestureDetector(
                        onTap: (){
                          if(selectedButtonIndex == 1){
                            homeScreenController.move(1);
                          }else if(selectedButtonIndex == 2){
                            homeScreenController.move(3);
                          }else if(selectedButtonIndex == 3){
                            homeScreenController.move(2);
                          }
                        },
                          child: Text("See All", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary, decoration: TextDecoration.underline, fontSize: 14),))
                    ],
                  ))
                ],
              ),
            );
          }
        } else if(controller.projectDateStateView.state == ResponseState.error){
          return Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/error.png", height: 80, width: 80,),
                const SizedBox(height: 15,),
                Text("Network Error", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black,
                    fontSize: 15, fontWeight: FontWeight.w500),),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      });
    });
  }
}


