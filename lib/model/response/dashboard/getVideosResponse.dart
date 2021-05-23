class VideoResponse {
  String userId;
  String cb;
  String timeAdded;
  String timeBalance;
  String videoId;
  String videoName;
  String videoImage;
  String videoLink;
  String productURL;
  List<NextVideos> nextVideos;
  String toWatchtime, watchedtime;
  String wtachedPercentage;
  String daysLeftThisMonth;
  String balanceTime;
  String balanceReward;
  String reaction;
  Survey survey;

  VideoResponse(
      this.userId,
      this.cb,
      this.timeAdded,
      this.timeBalance,
      this.videoId,
      this.videoName,
      this.videoImage,
      this.videoLink,
      this.productURL,
      this.nextVideos,
      this.toWatchtime,
      this.watchedtime,
      this.wtachedPercentage,
      this.daysLeftThisMonth,
      this.balanceTime,
      this.balanceReward,
      this.reaction,
      this.survey);

  VideoResponse.fromJson(Map<String, dynamic> data) {
    userId = data['user_id'];
    cb = data['cb'];
    timeAdded = data['time_added'];
    timeBalance = data['time_balance'];
    videoId = data['video_id'];
    videoName = data['video_name'];
    videoImage = data['video_image'];
    videoLink = data['video_link'];
    productURL = data['product_url'];
    if (data['next_video'] != null) {
      nextVideos = new List<NextVideos>();
      nextVideos.add(NextVideos.fromJson(data['next_video']));
    }
    if (data['to_watch_time'] != null) {
      TimeFormatter timeFormatter =
          TimeFormatter.fromJson(data['to_watch_time']);
      toWatchtime = (timeFormatter.hrs).toString() +
          ":" +
          (timeFormatter.mins).toString() +
          ":" +
          (timeFormatter.sec).toString();
    }
    if (data['watched_time'] != null) {
      TimeFormatter timeFormatter =
          TimeFormatter.fromJson(data['watched_time']);
      watchedtime = (timeFormatter.hrs).toString() +
          ":" +
          (timeFormatter.mins).toString() +
          ":" +
          (timeFormatter.sec).toString();
    }
    //  toWatchtime=data['to_watch_time'];
    //  watchedtime=data['watched_time'];

    wtachedPercentage = data['wtached_percentage'];
    print(wtachedPercentage);
    daysLeftThisMonth = data['days_left_this_month'];
    print(daysLeftThisMonth);
    balanceTime = data['balance_time'];
    print(balanceTime);
    balanceReward = data['balance_reward'];
    print(balanceReward);
    reaction = data['reaction'];
    // survey=data['survey'];
    print(reaction);
    if (data['survey'] != null) {
      survey = Survey.fromJson(data['survey']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['cb'] = this.cb;
    data['time_added'] = this.timeAdded;
    data['time_balance'] = this.timeBalance;
    data['video_id'] = this.videoId;
    data['video_name'] = this.videoName;
    data['video_image'] = this.videoImage;
    data['video_link'] = this.videoLink;
    data['product_url'] = this.productURL;
    data['next_video'] = this.nextVideos;
    data['to_watch_time'] = this.toWatchtime;
    data['watched_time'] = this.watchedtime;
    data['wtached_percentage'] = this.wtachedPercentage;
    data['days_left_this_month'] = this.daysLeftThisMonth;
    data['balance_time'] = this.balanceTime;
    data['balance_reward'] = this.balanceReward;
    data['reaction'] = this.reaction;
    data['survey'] = this.survey;
    return data;
  }
}

class TimeFormatter {
  int hrs, mins, sec;
  TimeFormatter(this.hrs, this.mins, this.sec);
  TimeFormatter.fromJson(Map<String, dynamic> data) {
    hrs = data['hrs'];
    mins = data['mins'];
    sec = data['sec'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hrs'] = this.hrs;
    data['mins'] = this.mins;
    data['sec'] = this.sec;
    return data;
  }
}

class NextVideos {
  String videoId;
  String videoName;
  String videoImage;
  String videoLink;

  NextVideos({this.videoId, this.videoName, this.videoImage, this.videoLink});

  NextVideos.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    videoName = json['video_name'];
    videoImage = json['video_image'];
    videoLink = json['video_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['video_name'] = this.videoName;
    data['video_image'] = this.videoImage;
    data['video_link'] = this.videoLink;
    return data;
  }
}

class Survey {
  String one, two, comment;
  Survey(this.one, this.two, this.comment);

  Survey.fromJson(Map<String, dynamic> json) {
    one = json["1"];
    two = json["2"];
    comment = json["comment"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.one;
    data['2'] = this.two;
    data['comment'] = this.comment;
    return data;
  }
}
