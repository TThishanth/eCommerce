import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/screens/home_screen.dart';
import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final String ownerId;
  final double amount;
  final String addressId;
  final String shippingStatus;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.ownerId,
    @required this.amount,
    this.addressId,
    this.shippingStatus,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  // For Users
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  // For users
  Future<void> fetchAndSetOrders(userId) async {
    try {
      final docsCollection =
          await userProductOrders.doc(userId).collection('userOrders').get();

      final List<OrderItem> loadedOrders = [];

      docsCollection.docs.forEach((orderItem) {
        loadedOrders.add(
          OrderItem(
            id: orderItem['id'],
            ownerId: orderItem['ownerId'],
            amount: orderItem['amount'],
            dateTime: DateTime.parse(orderItem['dateTime']),
            shippingStatus: orderItem['shippingStatus'],
            products: (orderItem['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // For Admin
  List<OrderItem> _adminOrders = [];

  List<OrderItem> get adminOrders {
    return [..._adminOrders];
  }

  // For Admin
  Future<void> adminFetchAndSetOrders() async {
    try {
      final docsCollection = await adminMyOrders.get();

      final List<OrderItem> loadedAdminOrders = [];

      docsCollection.docs.forEach((orderItem) async {
        loadedAdminOrders.add(
          OrderItem(
            id: orderItem['id'],
            ownerId: orderItem['ownerId'],
            amount: orderItem['amount'],
            addressId: orderItem['addressId'],
            dateTime: DateTime.parse(orderItem['dateTime']),
            products: (orderItem['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });

      _adminOrders = loadedAdminOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
    String userId,
    String orderId,
    String addressId,
  ) async {
    await adminMyOrders.doc(orderId).set({
      'id': orderId,
      'ownerId': userId,
      'addressId': addressId,
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'products': cartProducts
          .map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList(),
    });

    await userProductOrders
        .doc(userId)
        .collection('userOrders')
        .doc(orderId)
        .set({
      'id': orderId,
      'ownerId': userId,
      'amount': total,
      'shippingStatus': 'Pending',
      'dateTime': DateTime.now().toIso8601String(),
      'products': cartProducts
          .map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList(),
    }).then((_) {
      _orders.insert(
        0,
        OrderItem(
          id: orderId,
          ownerId: userId,
          addressId: addressId,
          shippingStatus: 'Pending',
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
    });
  }

  // Admin Side
  Future<void> conformShipment(ownerId, orderId) async {
    await userProductOrders
        .doc(ownerId)
        .collection('userOrders')
        .doc(orderId)
        .update({
      'shippingStatus': 'Shipment Conformed',
    });

    await adminMyOrders.doc(orderId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  // User Side
  Future<void> conformReceived(ownerId, orderId) async {
    await userProductOrders
        .doc(ownerId)
        .collection('userOrders')
        .doc(orderId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }
}
