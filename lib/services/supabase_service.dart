// Supabase Service for Calda Pizza Ordering App
// Handles authentication, database queries, and order creation
//
// IMPORTANT: Make sure to install the supabase_flutter package:
// flutter pub add supabase_flutter
//
// Initialize Supabase in your main.dart before runApp():
// await Supabase.initialize(
//   url: 'YOUR_SUPABASE_URL',
//   anonKey: 'YOUR_SUPABASE_ANON_KEY',
// );

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart'; // Import the models file

/// Supabase Service Class
/// Singleton pattern for managing all Supabase interactions
class SupabaseService {
  // Singleton instance
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  /// Get Supabase client instance
  SupabaseClient get client => Supabase.instance.client;

  /// Get current user
  User? get currentUser => client.auth.currentUser;

  /// Get current user ID
  String? get currentUserId => currentUser?.id;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // ============================================================================
  // AUTHENTICATION METHODS
  // ============================================================================

  /// Sign up a new user with email, password, and username
  /// The username is stored in metadata and automatically copied to profiles table
  /// via the handle_new_user_creation() trigger
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username, // Stored in raw_user_meta_data
        },
      );

      if (response.user == null) {
        throw Exception('Failed to create user account');
      }

      return response;
    } on AuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in an existing user with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to sign in');
      }

      return response;
    } on AuthException catch (e) {
      throw Exception('Sign in failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on AuthException catch (e) {
      throw Exception('Sign out failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Get current user's profile
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      if (currentUserId == null) return null;

      final response = await client
          .from('profiles')
          .select()
          .eq('id', currentUserId!)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update current user's profile
  Future<UserProfile> updateUserProfile({
    String? username,
    String? email,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('No authenticated user');
      }

      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (email != null) updates['email'] = email;

      final response = await client
          .from('profiles')
          .update(updates)
          .eq('id', currentUserId!)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ============================================================================
  // PIZZA QUERIES
  // ============================================================================

  /// Get all pizzas
  Future<List<Pizza>> getAllPizzas() async {
    try {
      final response = await client
          .from('pizzas')
          .select()
          .order('name', ascending: true);

      return (response as List).map((json) => Pizza.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch pizzas: $e');
    }
  }

  /// Get a single pizza by ID
  Future<Pizza> getPizzaById(int id) async {
    try {
      final response = await client
          .from('pizzas')
          .select()
          .eq('id', id)
          .single();

      return Pizza.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch pizza: $e');
    }
  }

  /// Get pizzas by name (search)
  Future<List<Pizza>> searchPizzas(String query) async {
    try {
      final response = await client
          .from('pizzas')
          .select()
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      return (response as List).map((json) => Pizza.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search pizzas: $e');
    }
  }

  /// Get pizzas with images only
  Future<List<Pizza>> getPizzasWithImages() async {
    try {
      final response = await client
          .from('pizzas')
          .select()
          .not('image_url', 'is', null)
          .order('name', ascending: true);

      return (response as List).map((json) => Pizza.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch pizzas with images: $e');
    }
  }

  /// Stream pizzas (real-time updates)
  Stream<List<Pizza>> streamPizzas() {
    return client
        .from('pizzas')
        .stream(primaryKey: ['id'])
        .order('name')
        .map((data) => data.map((json) => Pizza.fromJson(json)).toList());
  }

  // ============================================================================
  // ADD-ON QUERIES
  // ============================================================================

  /// Get all add-ons
  Future<List<AddOn>> getAllAddOns() async {
    try {
      final response = await client
          .from('add_ons')
          .select()
          .order('name', ascending: true);

      return (response as List).map((json) => AddOn.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch add-ons: $e');
    }
  }

  /// Get a single add-on by ID
  Future<AddOn> getAddOnById(int id) async {
    try {
      final response = await client
          .from('add_ons')
          .select()
          .eq('id', id)
          .single();

      return AddOn.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch add-on: $e');
    }
  }

  /// Stream add-ons (real-time updates)
  Stream<List<AddOn>> streamAddOns() {
    return client
        .from('add_ons')
        .stream(primaryKey: ['id'])
        .order('name')
        .map((data) => data.map((json) => AddOn.fromJson(json)).toList());
  }

  // ============================================================================
  // ORDER CREATION AND MANAGEMENT
  // ============================================================================

  /// Create a new order with add-ons
  /// This is a transaction-like operation:
  /// 1. Insert order into orders table
  /// 2. Insert all add-ons into orders_add_ons table
  Future<Order> createOrder({
    required String pizzaName,
    required int pizzaPrice,
    required String pizzaSize,
    required List<AddOn> addOns,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('User must be authenticated to create an order');
      }

      // Calculate total price
      int orderTotal = pizzaPrice;
      for (var addOn in addOns) {
        orderTotal += addOn.price;
      }

      // Create the order
      final orderData = {
        'user_id': currentUserId!,
        'pizza_name': pizzaName,
        'pizza_price': pizzaPrice,
        'order_total': orderTotal,
        'pizza_size': pizzaSize,
      };

      final orderResponse = await client
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      final order = Order.fromJson(orderResponse);

      // Insert add-ons if any
      if (addOns.isNotEmpty && order.id != null) {
        final addOnInserts = addOns.map((addOn) => {
          'order_id': order.id!,
          'add_on_name': addOn.name,
          'add_on_price': addOn.price,
        }).toList();

        await client.from('orders_add_ons').insert(addOnInserts);
      }

      return order;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Alternative: Create order from CartItem model
  Future<Order> createOrderFromCart(CartItem cartItem) async {
    return createOrder(
      pizzaName: cartItem.pizza.name ?? 'Unknown Pizza',
      pizzaPrice: cartItem.pizza.price,
      pizzaSize: cartItem.size.displayName,
      addOns: cartItem.selectedAddOns,
    );
  }

  /// Get all orders for the current user
  Future<List<Order>> getUserOrders() async {
    try {
      if (currentUserId == null) {
        throw Exception('User must be authenticated');
      }

      final response = await client
          .from('orders')
          .select()
          .eq('user_id', currentUserId!)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user orders: $e');
    }
  }

  /// Get a single order by ID with its add-ons
  Future<Order> getOrderById(int orderId) async {
    try {
      // Get the order
      final orderResponse = await client
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();

      final order = Order.fromJson(orderResponse);

      // Get the add-ons for this order
      final addOnsResponse = await client
          .from('orders_add_ons')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: true);

      final orderAddOns = (addOnsResponse as List)
          .map((json) => OrderAddOn.fromJson(json))
          .toList();

      // Attach add-ons to the order
      return order.copyWith(addOns: orderAddOns);
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  /// Get add-ons for a specific order
  Future<List<OrderAddOn>> getOrderAddOns(int orderId) async {
    try {
      final response = await client
          .from('orders_add_ons')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => OrderAddOn.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch order add-ons: $e');
    }
  }

  /// Stream user orders (real-time updates)
  Stream<List<Order>> streamUserOrders() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUserId!)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Order.fromJson(json)).toList());
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Check if email is already registered
  /// Note: This uses sign in attempt to check (not ideal for production)
  Future<bool> isEmailRegistered(String email) async {
    try {
      // Try to sign in with empty password
      // This will fail but tell us if user exists
      await client.auth.signInWithPassword(
        email: email,
        password: '', // Empty password
      );
      return true;
    } on AuthException catch (e) {
      // "Invalid login credentials" means user exists but wrong password
      // "User not found" means user doesn't exist
      if (e.message.contains('Invalid')) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Format price from cents to string
  static String formatPrice(int priceInCents) {
    return '\$${(priceInCents / 100).toStringAsFixed(2)}';
  }

  /// Parse price from string to cents
  static int parsePrice(String priceString) {
    final cleaned = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    final dollars = double.tryParse(cleaned) ?? 0.0;
    return (dollars * 100).round();
  }
}
