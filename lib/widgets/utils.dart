String netflix =
    "https://cdn.vox-cdn.com/thumbor/AwKSiDyDnwy_qoVdLPyoRPUPo00=/39x0:3111x2048/1400x1400/filters:focal(39x0:3111x2048):format(png)/cdn.vox-cdn.com/uploads/chorus_image/image/49901753/netflixlogo.0.0.png";

String getMonth(num month) {
  if (month == 1) {
    return "Jan";
  } else if (month == 2) {
    return "Feb";
  } else if (month == 3) {
    return "Mar";
  } else if (month == 4) {
    return "Apr";
  } else if (month == 5) {
    return "May";
  } else if (month == 6) {
    return "Jun";
  } else if (month == 7) {
    return "Jul";
  } else if (month == 8) {
    return "Aug";
  } else if (month == 9) {
    return "Sep";
  } else if (month == 10) {
    return "Oct";
  } else if (month == 11) {
    return "Nov";
  } else if (month == 12) {
    return "Dec";
  } else {
    return "Unknown";
  }
}

String toDate(DateTime date) {
  return (getMonth(date.month) +
      ' ' +
      date.day.toString() +
      ', ' +
      date.year.toString());
}

int calcDueDate(DateTime date) {
  var date2 = DateTime.now();
  var difference = date.difference(date2);
  if (date2.isAfter(date)) {
    return (difference.inDays);
  } else {
    return (difference.inDays + 1);
  }
}

String reportDueDate(int days) {
  if (days == 14) {
    return 'Due in two weeks';
  } else if (days == 7) {
    return 'Due in a week';
/*  } else if (days < 7 && days > 1) {
    return '$days days';*/
  } else if (days == 1) {
    return 'Due in a day';
  } else if (days == 0) {
    return 'Due today';
  } else {
    return 'Due in $days days';
  }
}

int subEndDate(String cycle) {
  if (cycle == 'daily') {
    return 1;
  } else if (cycle == 'weekly') {
    return 7;
  } else if (cycle == 'monthly') {
    return 30;
  } else if (cycle == 'yearly') {
    return 365;
  } else if (cycle == 'bi-yearly') {
    return 730;
  } else {
    return 0;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';

  String toTitleCase() => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}
