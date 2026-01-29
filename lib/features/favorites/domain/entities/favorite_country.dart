import 'package:equatable/equatable.dart';

class FavoriteCountry extends Equatable {
  final String countryId;
  final DateTime favoritedAt;
  
  const FavoriteCountry({
    required this.countryId,
    required this.favoritedAt,
  });
  
  @override
  List<Object> get props => [countryId, favoritedAt];
}
