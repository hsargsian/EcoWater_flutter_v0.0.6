import 'package:echowater/core/domain/domain_models/walk_through_progress_domain.dart';
import 'package:echowater/core/domain/entities/walk_through_progress_entity/walk_through_progress_entity.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_screen_item.dart';
import 'package:flutter/material.dart';

import '../../../screens/dashboard/sub_views/tab_contents.dart';
import 'walk_through_item.dart';

class WalkThroughManager {
  factory WalkThroughManager() {
    return _instance;
  }
  WalkThroughManager._privateConstructor();

  static final WalkThroughManager _instance =
      WalkThroughManager._privateConstructor();
  bool _hasFetchedWalkthroughData = false;
  bool _isInitialized = false;
  List<WalkThroughItem> walkThroughItems = [];
  WalkThroughScreenItem currentWalkThroughScreenItem =
      WalkThroughScreenItem.none;
  DashboardTabs currentTab = DashboardTabs.home;
  WalkThroughItem currentWalkthroughItem = WalkThroughItem.none;
  bool get isShowingWalkThrough =>
      currentWalkthroughItem != WalkThroughItem.none;
  WalkThroughProgressDomain _walkThroughProgressDomain =
      WalkThroughProgressDomain.dummy();
  Function()? reloadScreen;
  Function()? onNotifyHeader;
  Function()? onNotifyFooter;
  Function(DashboardTabs tab)? switchTabScreen;
  late UserRepository _userRepository;

  bool get hasSeenHomeScreenWalkthrough =>
      _walkThroughProgressDomain.hasSeenHomeScreenWalkThrough;
  bool get hasSeenProfileScreenWalkthrough =>
      _walkThroughProgressDomain.hasSeenProfileScreenWalkThrough;
  bool get hasSeenLearningScreenWalkthrough =>
      _walkThroughProgressDomain.hasSeenLearningScreenWalkThrough;
  bool get hasSeenGoalsScreenWalkthrough =>
      _walkThroughProgressDomain.hasSeenGoalScreenWalkThrough;

  Future<void> initManager({Function()? onSuccess}) async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    _userRepository = Injector.instance<UserRepository>();
    final response = await _userRepository.fetchWalkthroughProgress();
    response.when(success: (walkThroughResponse) {
      _hasFetchedWalkthroughData = true;
      _walkThroughProgressDomain =
          WalkThroughProgressDomain(walkThroughResponse);
      onSuccess?.call();
    }, error: (error) {
      debugPrint(error.toMessage());
    });
  }

  void deinit() {
    _hasFetchedWalkthroughData = false;
    _isInitialized = false;
    _walkThroughProgressDomain = WalkThroughProgressDomain.dummy();
    walkThroughItems = [];
    currentWalkthroughItem = WalkThroughItem.none;
    currentTab = DashboardTabs.home;
  }

  void setAllSeen() {
    _walkThroughProgressDomain = WalkThroughProgressDomain(
        WalkThroughProgressEntity(true, true, true, true));
  }

  void setHomeScreenWalkthrough() {
    if (!_hasFetchedWalkthroughData) {
      return;
    }
    if (_walkThroughProgressDomain.hasSeenHomeScreenWalkThrough) {
      return;
    }
    walkThroughItems = [
      WalkThroughItem.homeBase,
      WalkThroughItem.homeBottleAndPpm,
      WalkThroughItem.homeProgress,
      WalkThroughItem.homeConsumptionProgress,
      WalkThroughItem.homeNotification,
    ];
    currentWalkthroughItem = WalkThroughItem.homeBase;
    _notifyListener();
  }

  void setGoalsScreenWalkthrough() {
    if (!_hasFetchedWalkthroughData) {
      return;
    }
    if (_walkThroughProgressDomain.hasSeenGoalScreenWalkThrough) {
      return;
    }
    walkThroughItems = [
      WalkThroughItem.goalsWeekTraining,
      WalkThroughItem.goalsPersonalGoals,
      WalkThroughItem.goalsTeamGoals
    ];
    currentWalkthroughItem = WalkThroughItem.goalsWeekTraining;
    _notifyListener();
  }

  void setProfileScreenWalkThrough() {
    if (!_hasFetchedWalkthroughData) {
      return;
    }
    if (_walkThroughProgressDomain.hasSeenProfileScreenWalkThrough) {
      return;
    }
    walkThroughItems = [
      WalkThroughItem.profileEditProfile,
      WalkThroughItem.profileSettingsOptions,
    ];
    currentWalkthroughItem = WalkThroughItem.profileEditProfile;
    currentWalkThroughScreenItem = WalkThroughScreenItem.profile;
    _notifyListener();
  }

  void setLearningScreenWalkThrough() {
    if (!_hasFetchedWalkthroughData) {
      return;
    }
    if (_walkThroughProgressDomain.hasSeenLearningScreenWalkThrough) {
      return;
    }
    walkThroughItems = [
      WalkThroughItem.learningCategory,
      WalkThroughItem.learningSupport,
    ];
    currentWalkthroughItem = WalkThroughItem.learningCategory;
    currentWalkThroughScreenItem = WalkThroughScreenItem.learnings;
    _notifyListener();
  }

  void _notifyListener() {
    reloadScreen?.call();
    onNotifyHeader?.call();
    onNotifyFooter?.call();
  }

  void nextWalkThrough(WalkThroughScreenItem walkThroughScreen) {
    final index =
        walkThroughItems.indexWhere((item) => item == currentWalkthroughItem);
    if (index == -1) {
      currentWalkthroughItem = WalkThroughItem.none;
    } else {
      if (index < walkThroughItems.length - 1) {
        currentWalkthroughItem = walkThroughItems[index + 1];
      } else {
        currentWalkthroughItem = WalkThroughItem.none;
        _setWalkThroughSeen(walkThroughScreen);
      }
    }
    _notifyListener();
  }

  void previousWalkThrough(WalkThroughScreenItem walkThroughScreen) {
    final index =
        walkThroughItems.indexWhere((item) => item == currentWalkthroughItem);
    if (index == 0) {
      currentWalkthroughItem = WalkThroughItem.none;
    } else {
      if (index >= 0) {
        currentWalkthroughItem = walkThroughItems[index - 1];
      } else {
        currentWalkthroughItem = WalkThroughItem.none;
        _setWalkThroughSeen(walkThroughScreen);
      }
    }
    _notifyListener();
  }

  void endWalkThrough(WalkThroughScreenItem walkThroughScreen) {
    currentWalkthroughItem = WalkThroughItem.none;
    _setWalkThroughSeen(walkThroughScreen);
    _notifyListener();
  }

  void _setWalkThroughSeen(WalkThroughScreenItem walkThroughScreen) {
    currentWalkThroughScreenItem = WalkThroughScreenItem.none;
    var data = <String, bool>{};
    switch (walkThroughScreen) {
      case WalkThroughScreenItem.none:
        break;
      case WalkThroughScreenItem.home:
        data = {'has_seen_homescreen_walkthrough': true};
        _walkThroughProgressDomain.updateSeenHomeWalkThrough();
      case WalkThroughScreenItem.profile:
        data = {'has_seen_dashboard_walkthrough': true};
        _walkThroughProgressDomain.updateSeenProfileWalkThrough();
      case WalkThroughScreenItem.learnings:
        data = {'has_seen_learning_walkthrough': true};
        _walkThroughProgressDomain.updateSeenLearningWalkThrough();
      case WalkThroughScreenItem.goals:
        data = {'has_seen_goal_walkthrough': true};
        _walkThroughProgressDomain.updateSeenGoalWalkThrough();
    }

    _userRepository.updateWalkthroughProgress(data);
  }
}
