

class Item{
  String? title;
  String? category;
  String? thumb_url;
  String? location;
  double? price;
  String? description;
  String? tenantID;
  String dateTime;
  bool? favorite = false;
  String favAddTime = "";
  List<dynamic> images;
  
  Item(this.title, this.category, this.location, this.price, this.thumb_url, this.description, this.tenantID, this.dateTime, this.favorite, this.images);
  
  //* Dummy date so we can display it
  //* you can replace this date by another from an API or your database


  //* recommendation list  
  static List<Item> recommendation = [
  ];
  
  //* nearby location list
  static List<Item> nearby = [
    
  ];
}