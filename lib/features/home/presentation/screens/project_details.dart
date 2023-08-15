import 'package:batnf/constants.dart/app_colors.dart';
import 'package:batnf/core/state/view_state.dart';
import 'package:batnf/features/home/data/projects/controller/project_details_controller.dart';
import 'package:batnf/features/home/presentation/widgets/carousel_cards.dart';
import 'package:batnf/features/home/presentation/widgets/error_widget.dart';
import 'package:batnf/features/home/presentation/widgets/home_video.dart';
import 'package:batnf/features/home/presentation/widgets/loading_widget.dart';
import 'package:batnf/features/home/presentation/widgets/video_thumbnail.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProjectDetails extends StatefulWidget {
  final String id;
  const ProjectDetails({super.key, required this.id});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {

  final carouselController = CarouselController();
  final pageController = PageController(viewportFraction: 0.7);
  int current = 0;
  final images = [
    "assets/images/image1.jpg",
    "assets/images/image2.jpg",
    "assets/images/image3.jpg",
    "assets/images/image4.jpg",
  ];
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
      body: GetBuilder<ProjectDetailsController>(
          init: ProjectDetailsController(),
          builder: (controller){
            return Builder(builder: (context){
              if(controller.projectDetailsDateStateView.state == ResponseState.loading){
                return const LoadingWidget();
              }else if(controller.projectDetailsDateStateView.state == ResponseState.complete){
                final data = controller.projectDetailsDateStateView.data!;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height / 3.2, floating: false,
                      automaticallyImplyLeading: false, backgroundColor: Colors.white, pinned: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background:  Builder(builder: (context) {
                          final data = controller.projectDetailsDateStateView.data!;
                          return Container(
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
                                          viewportFraction: 1.0,
                                          enableInfiniteScroll: false,
                                          // autoPlay: true
                                        ),
                                        items: data.files!
                                            .map((inprogressFile) {
                                          if (data.files!.isEmpty ||
                                              inprogressFile.fileExt!.isEmpty ||
                                              inprogressFile.fileUrl!.isEmpty ||
                                              inprogressFile.thumbnail!.isEmpty) {
                                            return Container(
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
                                                    const Center(
                                                        child: Text(
                                                            'No Image/Video Available')),
                                                placeholder: (context, url) => const Center(
                                                    child: CupertinoActivityIndicator()),
                                                imageUrl:
                                                'https://www.batnf.net/${inprogressFile.thumbnail}',
                                                fit: BoxFit.cover);
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
                                                'https://www.batnf.net/${inprogressFile.fileUrl}',
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
                                    data.files!.length <= 1 ? const SizedBox(): const Text('previous'),
                                    data.files!.length <= 1 ? const SizedBox():
                                    MaterialButton(
                                      onPressed: () => carouselController.previousPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.linear),
                                      child: const Icon(FontAwesomeIcons.arrowLeft, size: 15,),
                                    ),
                                    MaterialButton(
                                      onPressed: () => carouselController.nextPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.linear),
                                      child: const Icon(FontAwesomeIcons.arrowRight, size: 15,),
                                    ),
                                    const Text('Next')
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: data.projectTitle ?? "",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                             TextWidget(
                              text: data.projectDescription ?? "",
                              fontSize: 15,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     SizedBox(
                            //       child: Row(
                            //         children: [
                            //           Image.asset("assets/images/start_icon.png"),
                            //           const SizedBox(
                            //             width: 5,
                            //           ),
                            //           const TextWidget(
                            //             text: "Start date",
                            //             fontSize: 12,
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       child: Row(
                            //         children: [
                            //           const TextWidget(
                            //             text: "End Date",
                            //             fontSize: 12,
                            //           ),
                            //           const SizedBox(
                            //             width: 5,
                            //           ),
                            //           Image.asset("assets/images/end_icon.png"),
                            //         ],
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //      TextWidget(
                            //       text: CustomDate.slash(data.projectStartDate.toString()),
                            //       fontSize: 12,
                            //     ),
                            //     Image.asset("assets/images/arrow.png"),
                            //     TextWidget(
                            //       text: CustomDate.slash(data.projectEndDate.toString()),
                            //       fontSize: 12,
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            //  Row(
                            //   children: [
                            //     const Icon(
                            //       Icons.location_on,
                            //       size: 20,
                            //     ),
                            //     TextWidget(
                            //       text: data.projectLocation ?? "",
                            //       fontSize: 14,
                            //     )
                            //   ],
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: "Related Projects",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            data.files!.isNotEmpty ?
                            CarouselSlider(
                                carouselController: carouselController,
                                options: CarouselOptions(
                                    aspectRatio: 16/9,
                                    viewportFraction: 0.6,
                                    // enableInfiniteScroll: false,
                                    height: 120, autoPlayAnimationDuration: const Duration(seconds: 20),
                                    autoPlayInterval: const Duration(seconds: 4),
                                    enlargeCenterPage: false,
                                    autoPlay: false,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        current = index;
                                      });
                                    }
                                ), items: data.files?.map((e) => CarouselCard(
                              imageWidget: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error, color: Colors.black,),),
                                    placeholder: (context, url) =>
                                    const Center(child: CupertinoActivityIndicator(),),
                                    imageUrl: 'https://www.batnf.net/${e.thumbnail}',
                                    fit: BoxFit.cover),
                              ),)).toList()
                            ) : const SizedBox(),
                            data.files!.isNotEmpty ? const SizedBox(
                              height: 10,
                            ) : const SizedBox(),
                            data.files!.isNotEmpty ? AnimatedSmoothIndicator(
                              activeIndex: current,
                              count: data.files!.length,
                              effect: const SwapEffect(
                                  spacing: 8.0,
                                  radius: 100.0,
                                  dotWidth: 7.0,
                                  dotHeight: 7.0,
                                  paintStyle: PaintingStyle.stroke,
                                  strokeWidth: 1.5,
                                  dotColor: Colors.grey,
                                  activeDotColor: AppColors.primary),
                            ) : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }else if(controller.projectDetailsDateStateView.state == ResponseState.error){
                return const ErrorScreen();
              }
              return const SizedBox.shrink();
            });
          })
    );
  }

  @override
  void initState() {
    _controller.getProjectById(id: widget.id);
    super.initState();
  }
  final _controller = Get.put(ProjectDetailsController());
}
