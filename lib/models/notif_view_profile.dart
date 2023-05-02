
import 'package:rent_house/models/notification.dart';

class ViewProfileNotif extends Notification
{
  final String? dateViewed;
  ViewProfileNotif (super.key, super.note, super.uid, this.dateViewed);
  
}