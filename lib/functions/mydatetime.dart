DateTime mydatetime(String completedate, String completetime) {
  String date = completedate.split('-')[0];
  String month = completedate.split('-')[1];
  String year = completedate.split('-')[2];
  date = int.parse(date) < 10 ? "0$date" : date;
  month = int.parse(month) < 10 ? "0$month" : month;
  String period = completetime.split(" ")[1];
  int hrs = int.parse((completetime.split(" ")[0]).split(":")[0]);
  String min = (completetime.split(" ")[0]).split(":")[1];
  if (hrs == 12 && period == "am") {
    hrs = 0;
  }
  if (period == "pm") {
    hrs = hrs + 12;
  }
  String withzerohr = "";
  withzerohr = hrs < 10 ? "0$hrs" : hrs.toString();

  return DateTime.parse("$year-$month-$date $withzerohr:$min:00");
}