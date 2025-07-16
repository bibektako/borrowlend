import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/home/data/data_source/home_data_source.dart';

class HomeRemoteDataSource implements IHomeDataSource {
  final ApiService _apiService;

  HomeRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  
}
