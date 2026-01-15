import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokeclickerlive/src/core/error/failure.dart';
import '../domain/pokemon.dart';

class PokemonRepository {
  final Dio _dio;

  // Sinnoh Region Pokemon IDs
  static const int sinnohStart = 387;
  static const int sinnohEnd = 493;

  PokemonRepository({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch a specific Pokemon by ID
  Future<Either<Failure, Pokemon>> getPokemon(int id) async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon/$id');

      if (response.statusCode == 200) {
        final data = response.data;

        // Extract stats
        int hp = 50;
        int attack = 50;
        for (final stat in data['stats'] ?? []) {
          final statName = stat['stat']['name'];
          if (statName == 'hp') hp = stat['base_stat'] ?? 50;
          if (statName == 'attack') attack = stat['base_stat'] ?? 50;
        }

        final pokemon = Pokemon(
          id: data['id'],
          name: _capitalize(data['name']),
          spriteUrl: data['sprites']['front_default'] ?? '',
          hp: hp,
          attack: attack,
        );

        return right(pokemon);
      } else {
        return left(const Failure.server('Failed to fetch Pokemon'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return left(const Failure.notFound('Pokemon not found'));
      }
      return left(Failure.network(e.message));
    } catch (e) {
      return left(Failure.unknown(e.toString()));
    }
  }

  /// Get a random Sinnoh Pokemon for encounters
  Future<Either<Failure, Pokemon>> getRandomSinnohPokemon() async {
    final random = Random();
    final id = sinnohStart + random.nextInt(sinnohEnd - sinnohStart + 1);
    return getPokemon(id);
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
