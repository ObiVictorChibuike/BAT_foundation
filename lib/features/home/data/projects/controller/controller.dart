import 'package:batnf/core/state/view_state.dart';
import 'package:batnf/features/home/data/projects/model/events/events_response_model.dart';
import 'package:batnf/features/home/data/projects/model/home/home_file_model_response.dart';
import 'package:batnf/features/home/data/projects/model/news/news_response_model.dart';
import 'package:batnf/features/home/data/projects/model/projects/projects_response_model.dart';
import 'package:batnf/features/home/data/projects/respository/events/events.dart';
import 'package:batnf/features/home/data/projects/respository/media_centre/news.dart';
import 'package:batnf/features/home/data/projects/respository/projects/projects.dart';
import 'package:batnf/utilities/injector.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  final ProjectRepository _projectRepository = sl<ProjectRepository>();
  final EventRepository _eventRepository = sl<EventRepository>();
  final NewsRepository _newsRepository = sl<NewsRepository>();
  // late final TextEditingController query;

  ViewState<List<ProjectsResponseModel>> projectDateStateView = ViewState(state: ResponseState.empty);
  void _setProjectState(ViewState<List<ProjectsResponseModel>> projectDateStateView) {
    this.projectDateStateView = projectDateStateView;
  }
  Future <void> getAllProjects() async {
    try{
      _setProjectState(ViewState.loading());
      update();
      Either<String, List<ProjectsResponseModel>> either = await _projectRepository.getProjects();
      either.fold((l){
        _setProjectState(ViewState.error(l));
        update();
        return _setProjectState(ViewState.error(l));
      }, (r){
        _setProjectState(ViewState.complete(r));
        update();
        return _setProjectState(ViewState.complete(r));
      });
      update();
    }catch(e){
      _setProjectState(ViewState.error(e.toString()));
      update();
      _setProjectState(ViewState.error(e.toString()));
    }
  }

  Future <void> repopulateAllProjectsList() async {
    try{
      // _setProjectState(ViewState.loading());
      // update();
      Either<String, List<ProjectsResponseModel>> either = await _projectRepository.getProjects();
      either.fold((l){
        _setProjectState(ViewState.error(l));
        update();
        return _setProjectState(ViewState.error(l));
      }, (r){
        _setProjectState(ViewState.complete(r));
        update();
        return _setProjectState(ViewState.complete(r));
      });
      update();
    }catch(e){
      _setProjectState(ViewState.error(e.toString()));
      update();
      _setProjectState(ViewState.error(e.toString()));
    }
  }

  ViewState<List<EventsResponseModel>> eventDateStateView = ViewState(state: ResponseState.empty);
  void _setEventState(ViewState<List<EventsResponseModel>> eventDateStateView) {
    this.eventDateStateView = eventDateStateView;
  }
  Future <void> getAllEvents() async {
    try{
      _setEventState(ViewState.loading());
      update();
      Either<String, List<EventsResponseModel>> either = await _eventRepository.getEvents();
      either.fold((l){
        _setEventState(ViewState.error(l));
        update();
        return _setEventState(ViewState.error(l));
      }, (r){
        _setEventState(ViewState.complete(r));
        update();
        return _setEventState(ViewState.complete(r));
      });
      update();
    }catch(e){
      _setEventState(ViewState.error(e.toString()));
      update();
      _setEventState(ViewState.error(e.toString()));
    }
  }

  Future <void> repopulateAllEventsList() async {
    try{
      // _setEventState(ViewState.loading());
      // update();
      Either<String, List<EventsResponseModel>> either = await _eventRepository.getEvents();
      either.fold((l){
        _setEventState(ViewState.error(l));
        update();
        return _setEventState(ViewState.error(l));
      }, (r){
        _setEventState(ViewState.complete(r));
        update();
        return _setEventState(ViewState.complete(r));
      });
      update();
    }catch(e){
      _setEventState(ViewState.error(e.toString()));
      update();
      _setEventState(ViewState.error(e.toString()));
    }
  }

  ViewState<List<NewsResponseModel>> newsDateStateView = ViewState(state: ResponseState.empty);
  void _setNewsState(ViewState<List<NewsResponseModel>> newsDateStateView) {
    this.newsDateStateView = newsDateStateView;
  }
  Future <void> getAllNews() async {
    try{
      _setNewsState(ViewState.loading());
      update();
      Either<String, List<NewsResponseModel>> either = await _newsRepository.getNews();
      // await getAllHomeFile();
      either.fold((l){
        _setNewsState(ViewState.error(l));
        update();
        return _setNewsState(ViewState.error(l));
      }, (r){
        _setNewsState(ViewState.complete(r));
        update();
        return _setNewsState(ViewState.complete(r));
      });
      update();
    }catch(e){
      _setNewsState(ViewState.error(e.toString()));
      update();
      _setNewsState(ViewState.error(e.toString()));
    }
  }

  ViewState<List<GetAllHomeFileResponseModel>> homeFileDataStateView = ViewState(state: ResponseState.empty);
  void _setHomeFileState(ViewState<List<GetAllHomeFileResponseModel>> homeFileDataStateView) {
    this.homeFileDataStateView = homeFileDataStateView;
  }

  Future <void> getAllHomeFile() async {
    try{
      _setHomeFileState(ViewState.loading());
      update();
      Either<String, List<GetAllHomeFileResponseModel>> either = await _newsRepository.allHomeFile();
      either.fold((l){
        _setHomeFileState(ViewState.error(l));
        update();
        return _setHomeFileState(ViewState.error(l));
      }, (r){
        _setHomeFileState(ViewState.complete(r));
        update();
        return _setHomeFileState(ViewState.complete(r));
      });
      update();
    }catch(e){
      _setHomeFileState(ViewState.error(e.toString()));
      update();
      _setHomeFileState(ViewState.error(e.toString()));
    }
  }

  Future <void> repopulateAllNewsList() async {
    try{
      // _setNewsState(ViewState.loading());
      // update();
      Either<String, List<NewsResponseModel>> either = await _newsRepository.getNews();
      either.fold((l){
        _setNewsState(ViewState.error(l));
        update();
        return _setNewsState(ViewState.error(l));
      }, (r){
        _setNewsState(ViewState.complete(r));
        update();
        return _setNewsState(ViewState.complete(r));
      });
      update();
    }catch(e){
      _setNewsState(ViewState.error(e.toString()));
      update();
      _setNewsState(ViewState.error(e.toString()));
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callFunction();
    });
    super.onInit();
  }
  void callFunction(){
  Future.wait([
  getAllHomeFile(),
  getAllNews(),
  getAllEvents(),
  getAllProjects(),
  ]);
  }
}