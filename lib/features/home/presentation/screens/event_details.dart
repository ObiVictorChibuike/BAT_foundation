import 'dart:developer';
import 'package:batnf/constants.dart/app_colors.dart';
import 'package:batnf/core/state/view_state.dart';
import 'package:batnf/features/home/data/projects/controller/event_details_controller.dart';
import 'package:batnf/features/home/presentation/widgets/error_widget.dart';
import 'package:batnf/features/home/presentation/widgets/loading_widget.dart';
import 'package:batnf/features/home/presentation/widgets/video_thumbnail.dart';
import 'package:batnf/universal.dart/main_btn.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:batnf/utilities/local_session_manager/local_session_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_dialog/clean_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  final String id;
  const EventDetails({super.key, required this.id});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  LocalSessionManager localSessionManager = LocalSessionManager();
  showAlertDialog(){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Register Event',
        content: "Kindly confirm to register event",
        backgroundColor: AppColors.primary,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Confirm',
              textColor: AppColors.primary,
              onPressed: (){
                Navigator.pop(context);
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                dateTimeString = inputFormat.parse(DateTime.now().toString()).toString();
                _controller.registerEvent(userId: int.parse(localSessionManager.userId),
                    eventId: int.parse(_controller.eventDetailsDateStateView.data!.eventId!), date: dateTimeString!, context: context);
              }
          ),
          CleanDialogActionButtons(
              actionTitle: 'Cancel',
              textColor: Colors.red,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }
  String? dateTimeString;
  // void registerEvent()async{
  //   progressIndicator(context);
  //
  //   await _controller.registerEvent(userId: int.parse(localSessionManager.userId),
  //       eventId: int.parse(_controller.eventDetailsDateStateView.data!.eventId!), date: dateTimeString!);
  //   if(_controller.eventDetailsDateStateView.state == ResponseState.complete){
  //     WidgetsBinding.instance.addPostFrameCallback((_){
  //       Navigator.pop(context);
  //       InfoSnackBar.showErrorSnackBar(
  //           context, "Request Error: Request Successful");
  //     });
  //   }else if(_controller.eventDetailsDateStateView.state == ResponseState.error){
  //     WidgetsBinding.instance.addPostFrameCallback((_){
  //       Navigator.pop(context);
  //       InfoSnackBar.showErrorSnackBar(
  //           context, "Request Error: ${_controller.errorMessage ?? "Please check your credentials and resend"}");
  //     });
  //   }
  // }

  final carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0,
        title: Image.asset(
          "assets/images/logo.png",
          width: 50,
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back, color: Colors.black,)),),
      body: GetBuilder<EventDetailsController>(
        init: EventDetailsController(),
          builder: (controller){
        return Builder(builder: (context){
          if(controller.eventDetailsDateStateView.state == ResponseState.loading){
            return const LoadingWidget();
          }else if(controller.eventDetailsDateStateView.state == ResponseState.complete){
            final data = controller.eventDetailsDateStateView.data!;
            return Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      opacity: 0.2,
                                      image: AssetImage(
                                        'assets/images/Bc.png',
                                      ),
                                      fit: BoxFit.cover),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(18)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CarouselSlider(
                                    carouselController: carouselController,
                                    options: CarouselOptions(
                                      padEnds: false,
                                      autoPlayInterval: Duration(seconds: 10),
                                      height: 180,
                                      viewportFraction: 2,
                                      enableInfiniteScroll: false,
                                      // autoPlay: true
                                    ),
                                    items: data?.files!.map((inprogressFile) {
                                      if (data.files!.isEmpty ||
                                          inprogressFile.fileExt!.isEmpty ||
                                          inprogressFile.fileUrl!.isEmpty ||
                                          inprogressFile.thumbnail!.isEmpty) {
                                        return Container(
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(18)),
                                            child: const CupertinoActivityIndicator());
                                        // CachedNetworkImage(
                                        //     placeholder: (context, url) => Center(
                                        //         child: CircularProgressIndicator()),
                                        //     imageUrl:
                                        //         'https://i1.wp.com/nnn.ng/wp-content/uploads/2021/03/news-today.jpg',
                                        //     fit: BoxFit.cover);
                                        // Image.asset('assets/logo.png', fit: BoxFit.cover);
                                      } else if (inprogressFile.fileExt == '') {
                                        return CachedNetworkImage(
                                          errorWidget: (context, url, error) =>
                                              const Center(child: Text(
                                                  'No Image/Video Available')),
                                          placeholder: (context, url) => Center(
                                              child: CupertinoActivityIndicator()),
                                          imageUrl:
                                          'https://www.batnf.net/${inprogressFile.thumbnail}',
                                          fit: BoxFit.cover,  width: 350,);
                                      } else if (inprogressFile.fileExt == 'image' &&
                                          inprogressFile.thumbnail!.isNotEmpty) {
                                        return CachedNetworkImage(
                                            errorWidget: (context, url, error) =>
                                                const Center(
                                                    child: Text(
                                                        'No Image/Video Available')),
                                            placeholder: (context, url) => Center(
                                                child: CupertinoActivityIndicator()),
                                            imageUrl:
                                            'https://www.batnf.net/${inprogressFile.fileUrl}', width: 350,
                                            fit: BoxFit.cover);
                                      }
                                      return Videos(
                                        thumbnailUrl: inprogressFile.thumbnail!,
                                        videoUrl: inprogressFile.fileUrl!,
                                      );
                                    }).toList()),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('previous'),
                                MaterialButton(
                                  onPressed: () => carouselController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear),
                                  child: Icon(FontAwesomeIcons.arrowLeft, size: 15,),
                                ),
                                MaterialButton(
                                  onPressed: () => carouselController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear),
                                  child: Icon(FontAwesomeIcons.arrowRight, size: 15,),
                                ),
                                Text('Next')
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * .40, width: double.maxFinite,
                    //   child: controller.eventDetailsDateStateView.data!.files![0].fileExt ==
                    //       'image/png' && controller.eventDetailsDateStateView.data!.files![0].fileUrl!.isNotEmpty
                    //       ? ClipRRect(
                    //     borderRadius:
                    //     BorderRadius.circular(10),
                    //     child: CachedNetworkImage(
                    //         errorWidget: (context, url,
                    //             error) =>
                    //         const Center(
                    //           child: Icon(
                    //             Icons.error,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //         placeholder:
                    //             (context, url) =>
                    //         const Center(
                    //           child:
                    //           CupertinoActivityIndicator(),
                    //         ),
                    //         imageUrl: 'https://www.batnf.net/${controller.eventDetailsDateStateView.data!.files![0].fileUrl}',
                    //         fit: BoxFit.cover),
                    //   )
                    //       : ClipRRect(
                    //     borderRadius:
                    //     BorderRadius.circular(10),
                    //     child: CachedNetworkImage(
                    //         errorWidget: (context, url, error) =>
                    //         const Center(
                    //           child: Icon(Icons.error, color: Colors.black,),),
                    //         placeholder: (context, url) =>
                    //         const Center(child: CupertinoActivityIndicator(),),
                    //         imageUrl: 'https://www.batnf.net/${controller.eventDetailsDateStateView.data!.files![0].thumbnail}',
                    //         fit: BoxFit.cover),
                    //   ),
                    // ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .60,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: ListView(
                        children: [
                          const SizedBox(height: 20,),
                           TextWidget(
                            text: controller.eventDetailsDateStateView.data?.eventName ?? "",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           TextWidget(
                            text: controller.eventDetailsDateStateView.data?.eventDesc ?? "",
                            fontSize: 15,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          controller.eventDetailsDateStateView.data?.eventStartDate == "" || controller.eventDetailsDateStateView.data?.eventStartDate == null ?
                          const SizedBox() :
                          const Row(
                            children: [
                              Icon(Icons.calendar_month),
                              TextWidget(text: "Date")
                            ],
                          ),
                          controller.eventDetailsDateStateView.data?.eventStartDate == "" || controller.eventDetailsDateStateView.data?.eventStartDate == null ?
                          const SizedBox() :
                          const SizedBox(
                            height: 10,
                          ),
                          controller.eventDetailsDateStateView.data?.eventStartDate == "" || controller.eventDetailsDateStateView.data?.eventStartDate == null ?
                          const SizedBox() :
                          TextWidget(text: controller.eventDetailsDateStateView.data?.eventStartDate ?? ""),
                          const SizedBox(
                            height: 15,
                          ),
                          controller.eventDetailsDateStateView.data?.eventStartTime == "" || controller.eventDetailsDateStateView.data?.eventStartTime == null ?
                          const SizedBox() :
                          const Row(
                            children: [
                              Icon(Icons.access_time_filled_rounded),
                              TextWidget(text: "Time")
                            ],
                          ),
                          controller.eventDetailsDateStateView.data?.eventStartTime == "" || controller.eventDetailsDateStateView.data?.eventStartTime == null ?
                          const SizedBox() :
                          const SizedBox(
                            height: 10,
                          ),
                          controller.eventDetailsDateStateView.data?.eventStartTime == "" || controller.eventDetailsDateStateView.data?.eventStartTime == null ?
                              const SizedBox() :
                          TextWidget(text: controller.eventDetailsDateStateView.data?.eventStartTime ?? ""),
                          const SizedBox(
                            height: 15,
                          ),
                          controller.eventDetailsDateStateView.data?.eventLocation == "" || controller.eventDetailsDateStateView.data?.eventLocation == null ?
                          const SizedBox() :
                          const Row(
                            children: [
                              Icon(Icons.location_on),
                              TextWidget(text: "Venue")
                            ],
                          ),
                          controller.eventDetailsDateStateView.data?.eventLocation == "" || controller.eventDetailsDateStateView.data?.eventLocation == null ?
                          const SizedBox() :
                          const SizedBox(
                            height: 10,
                          ),
                          controller.eventDetailsDateStateView.data?.eventLocation == "" || controller.eventDetailsDateStateView.data?.eventLocation == null ?
                          const SizedBox() :
                          TextWidget(text: controller.eventDetailsDateStateView.data?.eventLocation ?? ""),
                          const SizedBox(
                            height: 50,
                          ),
                          MainButton(onTap: () {
                            showAlertDialog();
                          }, label: "Register")
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   left: 30,
                //   top: 10,
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: const CircleAvatar(
                //       backgroundColor: Color.fromARGB(255, 255, 255, 255),
                //       child: Icon(
                //         Icons.arrow_back,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // )
              ],
            );
          }else if(controller.eventDetailsDateStateView.state == ResponseState.error){
            return const ErrorScreen();
          }
          return const SizedBox.shrink();
        });
      }),
    );
  }
  final _controller = Get.put(EventDetailsController());

  @override
  void initState() {
    log(widget.id);
    _controller.getEventById(id: widget.id);
    super.initState();
  }
}
