import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tradly_app/data/models/product_model.dart';

class PermissionHelper {
  static Future<Position> getCurrentLocation() async {
    return Geolocator.getCurrentPosition();
  }

  static Future<ProductModel> getAddressFromPosition(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final placemark = placemarks.first;
    return ProductModel(
      title: '',
      imageUrl: '',
      price: '',
      street: placemark.street,
      city: placemark.locality,
      state: placemark.administrativeArea,
      zipCode: placemark.postalCode,
    );
  }
}
