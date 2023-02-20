//return today date as yyyymmdd
String todaysDateYYYYMMDD() {
  //today
  var dateTimeObject = DateTime.now();

  //year in the format YYYY
  String year = dateTimeObject.year.toString();

  //month in format mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day in format dd
  String date = dateTimeObject.day.toString();
  if (date.length == 1) {
    date = '0$date';
  }

  //final format
  String yyyymmdd = year + month + date;
  return yyyymmdd;
}

//convert string yyyymmdd to DateTime object

//convert DateTime object to yyyymmdd string