

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
  
  Item(this.title, this.category, this.location, this.price, this.thumb_url, this.description, this.tenantID, this.dateTime);
  
  //* Dummy date so we can display it
  //* you can replace this date by another from an API or your database


  //* recommendation list  
  static List<Item> recommendation = [
    // Item("Modern House for Renting", "House", "Cebu City, Philippines", 2500, "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tempus egestas sed sed risus pretium quam vulputate. Ut aliquam purus sit amet luctus. Potenti nullam ac tortor vitae purus faucibus ornare suspendisse sed. Penatibus et magnis dis parturient montes nascetur ridiculus. Turpis in eu mi bibendum neque egestas congue. Volutpat est velit egestas dui id ornare. In nisl nisi scelerisque eu ultrices. Nunc consequat interdum varius sit amet mattis. Amet purus gravida quis blandit. Tempor id eu nisl nunc mi ipsum faucibus. Facilisi nullam vehicula ipsum a arcu cursus vitae congue. In est ante in nibh mauris cursus mattis molestie a. Cras adipiscing enim eu turpis egestas pretium aenean. In metus vulputate eu scelerisque felis imperdiet. Semper auctor neque vitae tempus quam pellentesque.", "Nicolen Evanz T, Aricayos"),
    // Item("Small House", "Villa", "Cebu, Philippines", 2500, "https://images.pexels.com/photos/280229/pexels-photo-280229.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tempus egestas sed sed risus pretium quam vulputate. Ut aliquam purus sit amet luctus. Potenti nullam ac tortor vitae purus faucibus ornare suspendisse sed. Penatibus et magnis dis parturient montes nascetur ridiculus. Turpis in eu mi bibendum neque egestas congue. Volutpat est velit egestas dui id ornare. In nisl nisi scelerisque eu ultrices. Nunc consequat interdum varius sit amet mattis. Amet purus gravida quis blandit. Tempor id eu nisl nunc mi ipsum faucibus. Facilisi nullam vehicula ipsum a arcu cursus vitae congue. In est ante in nibh mauris cursus mattis molestie a. Cras adipiscing enim eu turpis egestas pretium aenean. In metus vulputate eu scelerisque felis imperdiet. Semper auctor neque vitae tempus quam pellentesque.", "Nicolen Evanz T, Aricayos"),
  ];
  
  //* nearby location list
  static List<Item> nearby = [
    // Item("Apartment for Renting", "Apartment", "Cebu City, Philippines", 2500, "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tempus egestas sed sed risus pretium quam vulputate. Ut aliquam purus sit amet luctus. Potenti nullam ac tortor vitae purus faucibus ornare suspendisse sed. Penatibus et magnis dis parturient montes nascetur ridiculus. Turpis in eu mi bibendum neque egestas congue. Volutpat est velit egestas dui id ornare. In nisl nisi scelerisque eu ultrices. Nunc consequat interdum varius sit amet mattis. Amet purus gravida quis blandit. Tempor id eu nisl nunc mi ipsum faucibus. Facilisi nullam vehicula ipsum a arcu cursus vitae congue. In est ante in nibh mauris cursus mattis molestie a. Cras adipiscing enim eu turpis egestas pretium aenean. In metus vulputate eu scelerisque felis imperdiet. Semper auctor neque vitae tempus quam pellentesque.", "Nicolen Evanz T, Aricayos"),
    // Item("Luxury Apartment", "Apartment", "Cebu City, Philippines", 2500, "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tempus egestas sed sed risus pretium quam vulputate. Ut aliquam purus sit amet luctus. Potenti nullam ac tortor vitae purus faucibus ornare suspendisse sed. Penatibus et magnis dis parturient montes nascetur ridiculus. Turpis in eu mi bibendum neque egestas congue. Volutpat est velit egestas dui id ornare. In nisl nisi scelerisque eu ultrices. Nunc consequat interdum varius sit amet mattis. Amet purus gravida quis blandit. Tempor id eu nisl nunc mi ipsum faucibus. Facilisi nullam vehicula ipsum a arcu cursus vitae congue. In est ante in nibh mauris cursus mattis molestie a. Cras adipiscing enim eu turpis egestas pretium aenean. In metus vulputate eu scelerisque felis imperdiet. Semper auctor neque vitae tempus quam pellentesque.", "Nicolen Evanz T, Aricayos"),
  ];
}