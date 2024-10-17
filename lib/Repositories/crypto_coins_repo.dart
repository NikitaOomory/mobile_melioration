import 'package:dio/dio.dart';
import 'package:mobile_melioration/Models/crypto_coin_model.dart';

class CryptoCoinsRepo{
  Future<List<CryptoCoinModel>> getCoinsList() async{
    final response = await Dio().get(
      'https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH&tsyms=USD,EUR&api_key=ebb66ee176e0635075760ee49cbf4024d03b1c0b98c09160f68619ff12dd6b65'
    );

    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries.map((e) => CryptoCoinModel(
        e.key,
        (e.value as Map<String, dynamic>)['USD'],)).toList();

    return dataList;
  }
}