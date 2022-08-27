import 'package:massageapp/get_localization.dart';

String getTimeStatus(DateTime? dateTime){
  String message='';
  if(dateTime==null)return message;
  final timDiff=DateTime.now().difference(dateTime);
  if(timDiff.inMinutes <60){
    if(timDiff.inMinutes==0){
        message=translator.justNow;
    }else{
     message= '${timDiff.inMinutes} ${translator.minutes} ${translator.ago}';
    }
  }else if(timDiff.inHours<24){
     message= '${timDiff.inHours} ${translator.hours} ${translator.ago}';
  }
  else if(timDiff.inDays<7) {
     message= '${timDiff.inDays} ${translator.days} ${translator.ago}';
  }else{
    message=' ${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
  return message;
}