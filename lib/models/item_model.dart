

class Item{
  String? title;
  String? category;
  String? thumb_url;
  String? location;
  double? price;
  
  Item(this.title, this.category, this.location, this.price, this.thumb_url);
  
  //* Dummy date so we can display it
  //* you can replace this date by another from an API or your database


  //* recommendation list  
  static List<Item> recommendation = [
    Item("Modern House for Renting", "House", "Cebu City, Philippines", 2500, "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    Item("Small House", "Villa", "Cebu, Philippines", 2500, "https://images.pexels.com/photos/280229/pexels-photo-280229.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  ];
  
  //* nearby location list
  static List<Item> nearby = [
    Item("Apartment for Renting", "Apartment", "Cebu City, Philippines", 2500, "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    Item("Luxury Apartment", "Apartment", "Cebu City, Philippines", 2500, "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  ];
}