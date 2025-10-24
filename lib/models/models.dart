// Data Models for Calda Pizza Ordering App
// These models match the Supabase database schema

import 'dart:convert';

/// User Profile Model
/// Corresponds to public.profiles table in Supabase
class UserProfile {
  final String id; // UUID from auth.users
  final String? username;
  final String? email;

  UserProfile({
    required this.id,
    this.username,
    this.email,
  });

  /// Create UserProfile from JSON (from Supabase)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
    );
  }

  /// Convert UserProfile to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  /// Create a copy with modified fields
  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'UserProfile(id: $id, username: $username, email: $email)';
}

/// Pizza Model
/// Corresponds to public.pizzas table in Supabase
class Pizza {
  final int id;
  final String? name;
  final int price; // Price in cents
  final String? imageUrl;
  final String? description;

  Pizza({
    required this.id,
    this.name,
    required this.price,
    this.imageUrl,
    this.description,
  });

  /// Get formatted price (e.g., "12.00 €") - Figma format
  String get formattedPrice {
    return '${(price / 100).toStringAsFixed(2)} €';
  }

  /// Get price as double in euros
  double get priceInEuros {
    return price / 100.0;
  }

  /// Check if pizza has image
  bool get hasImage {
    return imageUrl != null && imageUrl!.isNotEmpty;
  }

  /// Create Pizza from JSON (from Supabase)
  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as int,
      name: json['name'] as String?,
      price: json['price'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Convert Pizza to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'description': description,
    };
  }

  /// Create a copy with modified fields
  Pizza copyWith({
    int? id,
    String? name,
    int? price,
    String? imageUrl,
    String? description,
  }) {
    return Pizza(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Pizza(id: $id, name: $name, price: $formattedPrice)';
}

/// Add-On Model
/// Corresponds to public.add_ons table in Supabase
class AddOn {
  final int id;
  final String name;
  final int price; // Price in cents
  final String imgUrl;

  AddOn({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
  });

  /// Get formatted price (e.g., "2.50 €") - Figma format
  String get formattedPrice {
    return '${(price / 100).toStringAsFixed(2)} €';
  }

  /// Get price as double in euros
  double get priceInEuros {
    return price / 100.0;
  }

  /// Create AddOn from JSON (from Supabase)
  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      imgUrl: json['img_url'] as String,
    );
  }

  /// Convert AddOn to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'img_url': imgUrl,
    };
  }

  /// Create a copy with modified fields
  AddOn copyWith({
    int? id,
    String? name,
    int? price,
    String? imgUrl,
  }) {
    return AddOn(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  @override
  String toString() => 'AddOn(id: $id, name: $name, price: $formattedPrice)';
}

/// Pizza Size Enum
enum PizzaSize {
  small,
  medium,
  big; // Changed from "large" to match Figma design

  String get displayName {
    switch (this) {
      case PizzaSize.small:
        return 'Small';
      case PizzaSize.medium:
        return 'Medium';
      case PizzaSize.big:
        return 'Big'; // Changed from "Large" to match Figma
    }
  }

  /// Convert to string for database
  String toDbString() {
    return displayName;
  }

  /// Create from string
  static PizzaSize? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'small':
        return PizzaSize.small;
      case 'medium':
        return PizzaSize.medium;
      case 'big':
        return PizzaSize.big;
      case 'large': // Backward compatibility
        return PizzaSize.big;
      default:
        return null;
    }
  }
}

/// Order Model
/// Corresponds to public.orders table in Supabase
class Order {
  final int? id; // Nullable for creating new orders
  final DateTime createdAt;
  final String userId;
  final String pizzaName;
  final int pizzaPrice; // Price in cents
  final int orderTotal; // Total price in cents including add-ons
  final String? pizzaSize;
  List<OrderAddOn>? addOns; // Related add-ons (not in database, loaded separately)

  Order({
    this.id,
    required this.createdAt,
    required this.userId,
    required this.pizzaName,
    required this.pizzaPrice,
    required this.orderTotal,
    this.pizzaSize,
    this.addOns,
  });

  /// Get formatted order total (e.g., "15.50 €") - Figma format
  String get formattedTotal {
    return '${(orderTotal / 100).toStringAsFixed(2)} €';
  }

  /// Get total as double in euros
  double get totalInEuros {
    return orderTotal / 100.0;
  }

  /// Get formatted pizza price (e.g., "12.00 €") - Figma format
  String get formattedPizzaPrice {
    return '${(pizzaPrice / 100).toStringAsFixed(2)} €';
  }

  /// Create Order from JSON (from Supabase)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
      userId: json['user_id'] as String,
      pizzaName: json['pizza_name'] as String,
      pizzaPrice: json['pizza_price'] as int,
      orderTotal: json['order_total'] as int,
      pizzaSize: json['pizza_size'] as String?,
    );
  }

  /// Convert Order to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'pizza_name': pizzaName,
      'pizza_price': pizzaPrice,
      'order_total': orderTotal,
      'pizza_size': pizzaSize,
    };
  }

  /// Create a copy with modified fields
  Order copyWith({
    int? id,
    DateTime? createdAt,
    String? userId,
    String? pizzaName,
    int? pizzaPrice,
    int? orderTotal,
    String? pizzaSize,
    List<OrderAddOn>? addOns,
  }) {
    return Order(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      pizzaName: pizzaName ?? this.pizzaName,
      pizzaPrice: pizzaPrice ?? this.pizzaPrice,
      orderTotal: orderTotal ?? this.orderTotal,
      pizzaSize: pizzaSize ?? this.pizzaSize,
      addOns: addOns ?? this.addOns,
    );
  }

  @override
  String toString() =>
      'Order(id: $id, pizza: $pizzaName, size: $pizzaSize, total: $formattedTotal)';
}

/// Order Add-On Model
/// Corresponds to public.orders_add_ons table in Supabase
class OrderAddOn {
  final int? id; // Nullable for creating new records
  final DateTime createdAt;
  final int orderId;
  final String addOnName;
  final int addOnPrice; // Price in cents

  OrderAddOn({
    this.id,
    required this.createdAt,
    required this.orderId,
    required this.addOnName,
    required this.addOnPrice,
  });

  /// Get formatted price (e.g., "2.50 €") - Figma format
  String get formattedPrice {
    return '${(addOnPrice / 100).toStringAsFixed(2)} €';
  }

  /// Create OrderAddOn from JSON (from Supabase)
  factory OrderAddOn.fromJson(Map<String, dynamic> json) {
    return OrderAddOn(
      id: json['id'] as int?,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
      orderId: json['order_id'] as int,
      addOnName: json['add_on_name'] as String,
      addOnPrice: json['add_on_price'] as int,
    );
  }

  /// Convert OrderAddOn to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'created_at': createdAt.toIso8601String(),
      'order_id': orderId,
      'add_on_name': addOnName,
      'add_on_price': addOnPrice,
    };
  }

  /// Create a copy with modified fields
  OrderAddOn copyWith({
    int? id,
    DateTime? createdAt,
    int? orderId,
    String? addOnName,
    int? addOnPrice,
  }) {
    return OrderAddOn(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      orderId: orderId ?? this.orderId,
      addOnName: addOnName ?? this.addOnName,
      addOnPrice: addOnPrice ?? this.addOnPrice,
    );
  }

  @override
  String toString() => 'OrderAddOn(name: $addOnName, price: $formattedPrice)';
}

/// Cart Item Model (not in database, for UI state management)
/// Represents a pizza + selected add-ons before ordering
class CartItem {
  final Pizza pizza;
  final PizzaSize size;
  final List<AddOn> selectedAddOns;

  CartItem({
    required this.pizza,
    required this.size,
    this.selectedAddOns = const [],
  });

  /// Calculate total price including add-ons
  int get totalPrice {
    int total = pizza.price;
    for (var addOn in selectedAddOns) {
      total += addOn.price;
    }
    return total;
  }

  /// Get formatted total price (e.g., "15.50 €") - Figma format
  String get formattedTotalPrice {
    return '${(totalPrice / 100).toStringAsFixed(2)} €';
  }

  /// Get total price as double in euros
  double get totalInEuros {
    return totalPrice / 100.0;
  }

  /// Create a copy with modified fields
  CartItem copyWith({
    Pizza? pizza,
    PizzaSize? size,
    List<AddOn>? selectedAddOns,
  }) {
    return CartItem(
      pizza: pizza ?? this.pizza,
      size: size ?? this.size,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
    );
  }

  /// Convert to Order object for database insertion
  Order toOrder(String userId) {
    return Order(
      createdAt: DateTime.now(),
      userId: userId,
      pizzaName: pizza.name ?? 'Unknown Pizza',
      pizzaPrice: pizza.price,
      orderTotal: totalPrice,
      pizzaSize: size.displayName,
    );
  }

  @override
  String toString() =>
      'CartItem(pizza: ${pizza.name}, size: ${size.displayName}, addOns: ${selectedAddOns.length}, total: $formattedTotalPrice)';
}
