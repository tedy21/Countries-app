import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository repository;
  
  ToggleFavorite(this.repository);
  
  Future<Either<Failure, bool>> call(String countryId) async {
    return await repository.toggleFavorite(countryId);
  }
}
