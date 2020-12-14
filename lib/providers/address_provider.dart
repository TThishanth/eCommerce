import 'package:eCommerce/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Address {
  final String id;
  final String userId;
  final String userName;
  final int mobileNo;
  final String countryName;
  final String provinceName;
  final String cityName;
  final String streetName;
  final int postalCode;

  Address({
    @required this.id,
    @required this.userId,
    @required this.userName,
    @required this.mobileNo,
    @required this.countryName,
    @required this.provinceName,
    @required this.cityName,
    @required this.streetName,
    @required this.postalCode,
  });
}

class Addresses with ChangeNotifier {
  List<Address> _items = [];

  List<Address> get items {
    return [..._items];
  }

  Future<void> fetchAndSetAddresses(userId) async {
    try {
      final docsCollection =
          await usersAddress.doc(userId).collection('userAddress').get();

      final List<Address> loadedAddresses = [];

      docsCollection.docs.forEach((address) {
        print(address['mobileNo']);
        loadedAddresses.add(
          Address(
            id: address['id'],
            userId: address['userId'],
            userName: address['userName'],
            mobileNo: address['mobileNo'],
            countryName: address['countryName'],
            provinceName: address['provinceName'],
            cityName: address['cityName'],
            streetName: address['streetName'],
            postalCode: address['postalCode'],
          ),
        );
      });

      _items = loadedAddresses;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addAddress({
    String id,
    String userId,
    String userName,
    int mobileNo,
    String countryName,
    String provinceName,
    String cityName,
    String streetName,
    int postalCode,
  }) {
    return usersAddress.doc(userId).collection('userAddress').doc(id).set({
      'id': id,
      'userId': userId,
      'userName': userName,
      'mobileNo': mobileNo,
      'countryName': countryName,
      'provinceName': provinceName,
      'cityName': cityName,
      'streetName': streetName,
      'postalCode': postalCode,
    }).then((_) {
      final newAddress = Address(
        id: id,
        userId: userId,
        userName: userName,
        mobileNo: mobileNo,
        countryName: countryName,
        provinceName: provinceName,
        cityName: cityName,
        streetName: streetName,
        postalCode: postalCode,
      );

      _items.add(newAddress);
      notifyListeners();
    });
  }

  // Find Address for specific order
  Address _addressData;

  Address get addressData {
    return _addressData;
  }

  Future<void> getOrderAddress(ownerId, addressId) async {
    final addressData = await usersAddress
        .doc(ownerId)
        .collection('userAddress')
        .doc(addressId)
        .get();

    final Address loadedAddresses = Address(
      id: addressData.data()['id'],
      userId: addressData.data()['userId'],
      userName: addressData.data()['userName'],
      mobileNo: addressData.data()['mobileNo'],
      countryName: addressData.data()['countryName'],
      provinceName: addressData.data()['provinceName'],
      cityName: addressData.data()['cityName'],
      streetName: addressData.data()['streetName'],
      postalCode: addressData.data()['postalCode'],
    );

    _addressData = loadedAddresses;
    notifyListeners();
  }
}
