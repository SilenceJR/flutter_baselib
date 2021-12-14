///like java SimpleDateFormat
///support
// G	纪元标记	AD
// y	四位年份	2001
// M	月份	July or 07
// d	一个月的日期	10
// h	 A.M./P.M. (1~12)格式小时	12
// H	一天中的小时 (0~23)	22
// m	分钟数	30
// s	秒数	55
// S	毫秒数	234
// E	星期几	Tuesday
// D	一年中的日子	360
// F	一个月中第几周的周几	2 (second Wed. in July)
// w	一年中第几周	40
// W	一个月中第几周	1
// a	A.M./P.M. 标记	PM
// k	一天中的小时(1~24)	24
// K	 A.M./P.M. (0~11)格式小时	10
// z	时区	Eastern Standard Time
// '	文字定界符	Delimiter
// "	单引号	`
class SimpleDateFormat {
  static final weekName = {
    DateTime.monday: "Monday",
    DateTime.tuesday: "Tuesday",
    DateTime.wednesday: "Wednesday",
    DateTime.thursday: "Thursday",
    DateTime.friday: "Friday",
    DateTime.saturday: "Saturday",
    DateTime.sunday: "Sunday",
  };
  static final monthName = {
    DateTime.january: "January",
    DateTime.february: "February",
    DateTime.march: "March",
    DateTime.april: "April",
    DateTime.may: "May",
    DateTime.june: "June",
    DateTime.july: "July",
    DateTime.august: "August",
    DateTime.september: "September",
    DateTime.october: "October",
    DateTime.november: "November",
    DateTime.december: "December",
  };

  static final monthDays = {
    DateTime.january: 31,
    DateTime.february: 28,
    DateTime.march: 31,
    DateTime.april: 30,
    DateTime.may: 31,
    DateTime.june: 30,
    DateTime.july: 31,
    DateTime.august: 31,
    DateTime.september: 30,
    DateTime.october: 31,
    DateTime.november: 30,
    DateTime.december: 31,
  };

  format(DateTime date, String pattern) {

  }


  _formatChar(DateTime date,String char){

  }
}
