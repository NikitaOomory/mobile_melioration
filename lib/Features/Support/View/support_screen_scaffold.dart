import 'package:flutter/material.dart';
import 'package:mobile_melioration/Repositories/Crypto_coin/crypto_coins_repo.dart';
import 'package:mobile_melioration/Repositories/Crypto_coin/model/crypto_coin_model.dart';

class SupportScreenScaffold extends StatefulWidget{
  const SupportScreenScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _SupportScreenScaffold();
}

class _SupportScreenScaffold extends State<SupportScreenScaffold>{

  List<CryptoCoinModel>? _cryptoList;

  @override
  void initState() {
    _loadCrypto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Крипта'),),
      body: (_cryptoList == null)
          ? const Center(child: CircularProgressIndicator(),)
          : ListView.builder(
        itemCount: _cryptoList!.length,
        itemBuilder: (context, i ) => ListTile(
            title: Text(_cryptoList![i].name),
          subtitle: Text(_cryptoList![i].priceInUSD.toString()),
        ),
      ),
    );
  }

  Future<void> _loadCrypto() async{
    _cryptoList = await CryptoCoinsRepo().getCoinsList();
    setState(() {});
  }

}

