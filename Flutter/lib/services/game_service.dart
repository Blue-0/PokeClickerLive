import 'package:supabase_flutter/supabase_flutter.dart';

class GameService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Buys an asset (Pokemon or Infrastructure) using the secure RPC.
  ///
  /// [assetType] should be 'pokemon' or 'infrastructure'.
  /// [assetId] is the ID of the item to buy.
  ///
  /// Returns a Map containing the transaction result (new balance, etc).
  Future<Map<String, dynamic>> buyAsset(String assetType, int assetId) async {
    try {
      final response = await _supabase.rpc(
        'buy_asset',
        params: {
          'p_asset_type': assetType,
          'p_asset_id': assetId,
        },
      );

      // RPC returns a JSON object, which Dart sees as a Map
      return response as Map<String, dynamic>;
    } on PostgrestException catch (error) {
      // Handle specific database errors (e.g. insufficient funds)
      throw Exception('Failed to buy asset: ${error.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Example usage
  Future<void> testPurchase() async {
    try {
      final result = await buyAsset('pokemon', 1); // Buy Pokemon with ID 1
      print('Purchase successful!');
      print('New Balance: ${result['new_balance']}');
      print('Item bought: ${result['asset_bought']}');
    } catch (e) {
      print(e);
    }
  }
}
