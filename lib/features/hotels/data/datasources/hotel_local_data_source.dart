import 'package:hotel_list_app/features/hotels/data/models/hotels_data_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

abstract class HotelLocalDataSource {
  Future<void> cacheHotelsData(HotelsDataModel hotelsData);

  Future<HotelsDataModel?> getCachedHotelsData();

  Future<void> clearCache();
}

class HotelLocalDataSourceImpl implements HotelLocalDataSource {
  static const _cacheFileName = 'hotels_data_cache.json';

  Future<File> _getCacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_cacheFileName');
  }

  @override
  Future<void> cacheHotelsData(HotelsDataModel hotelsData) async {
    final file = await _getCacheFile();
    final jsonData = hotelsData.toJson();
    await file.writeAsString(json.encode(jsonData));
  }

  @override
  Future<HotelsDataModel?> getCachedHotelsData() async {
    try {
      final file = await _getCacheFile();
      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(contents);
      return HotelsDataModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    final file = await _getCacheFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
