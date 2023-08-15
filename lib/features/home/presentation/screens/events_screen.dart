import 'package:batnf/constants.dart/app_colors.dart';
import 'package:batnf/core/state/view_state.dart';
import 'package:batnf/features/home/data/projects/controller/controller.dart';
import 'package:batnf/features/home/presentation/widgets/customer_animation_bar/dimensions.dart';
import 'package:batnf/features/home/presentation/widgets/customer_animation_bar/search_bar.dart';
import 'package:batnf/features/home/presentation/widgets/error_widget.dart';
import 'package:batnf/features/home/presentation/widgets/project_shimmer_loader.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _controller = Get.find<HomeController>();

  @override
  void initState() {
    _controller.getAllEvents();
    query = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }
  late final TextEditingController query;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
        builder: (controller){
      return Builder(builder: (context){
        if(controller.eventDateStateView.state == ResponseState.loading){
          return const ProjectShimmerLoader();
        }else if(controller.eventDateStateView.state == ResponseState.complete){
          if(controller.eventDateStateView.data!.isEmpty){
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: query.text.isNotEmpty ? AppBar(
                elevation: 0.0, backgroundColor: Colors.white,
                actions: [
                  IconButton(onPressed: () async {
                    query.text = "";
                    await _controller.repopulateAllEventsList();
                  }, icon: Column(
                    children: [
                      const Icon(Icons.clear, color: AppColors.primary, size: 25,),
                      Text("Close", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black,
                          fontSize: 14, fontWeight: FontWeight.w300),),
                    ],
                  ))
                ],) : AppBar(elevation: 0.0, backgroundColor: Colors.white,),
              body: Center(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60,),
                    Image.asset("assets/images/no-data.png", height: 80, width: 80,),
                    const SizedBox(height: 15,),
                    Text("No event found", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black,
                        fontSize: 15, fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            );
          }else{
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0, automaticallyImplyLeading: false,
                backgroundColor: Colors.white, centerTitle: true,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 50,
                  ),
                ),
                title: const TextWidget(
                  text: "Events",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 5,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SearchBarAnimation(
                            durationInMilliSeconds: Dimensions.t500,
                            enableBoxShadow: false, enableBoxBorder: true,
                            hintText: "Search here", enableButtonShadow: false,
                            buttonShadowColour: Colors.transparent,
                            isOriginalAnimation: false,
                            enableKeyboardFocus: true,
                            buttonBorderColour: Colors.black45,
                            onCollapseComplete: () async {
                              query.text = "";
                              _controller.repopulateAllEventsList();
                            },
                            onChanged: (String value) {
                              final list = controller.eventDateStateView.data!.where((element) {
                                if (element.eventName!.toLowerCase().contains(query.text.toLowerCase())){
                                  return true;
                                } else if (element.eventDesc!.toLowerCase().contains(query.text.toLowerCase())) {
                                  return true;
                                } else {
                                  return false;
                                }
                              }).toList();
                              // final list =  controller.eventDateStateView.data!.where((element){
                              //   final title = element.eventName?.toUpperCase();
                              //   final queryTitle = query.text.toUpperCase();
                              //   return title!.contains(queryTitle);
                              // }).toList();
                              setState(() {
                                controller.eventDateStateView.data = list;
                              });
                            }, textEditingController: query, trailingWidget:const SizedBox() ,
                            secondaryButtonWidget: const Icon(Icons.clear, size: 20, color: AppColors.primary,), buttonWidget: const Icon(CupertinoIcons.search, color: AppColors.primary,),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...List.generate(controller.eventDateStateView.data!.length, (index){
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
            );
          }
        } else if(controller.eventDateStateView.state == ResponseState.error){
          return const ErrorScreen();
        }
        return const SizedBox.shrink();
      });
    });
  }
}
