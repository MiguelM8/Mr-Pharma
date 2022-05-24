class Product{

  int id;
  int? catId;
  String name;
  String? url, category;
  double price;

  Product(
          this.id, this.name, this.url, this.price, this.catId,
          this.category
    );
}