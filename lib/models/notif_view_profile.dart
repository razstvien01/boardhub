
import 'package:rent_house/models/notification.dart';

class ViewProfileNotif extends TheNotification
{
  final String? dateViewed;
  ViewProfileNotif ({super.key, super.note, super.uid, super.type, super.dateTime, this.dateViewed});
  
}