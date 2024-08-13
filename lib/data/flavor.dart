class Flavor {
  final String name;
  final List<String>? toppings;
  final List<String> ingredients;

  Flavor(this.name, this.toppings, this.ingredients);

  Flavor.fromJson(Map<String, dynamic> json)
    : name = json['flavor'] as String,
      toppings = List.from(json['toppings']),
      ingredients = List.from(json['ingredients']);
}