import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shwelamin/Consts/constData.dart';
import 'package:shwelamin/Consts/constName.dart';
import 'package:shwelamin/MyHelper/methodHelper.dart';
import 'package:shwelamin/modal/ImportDataRepository.dart';
import 'package:shwelamin/modal/importproductModal.dart';
import 'package:shwelamin/myComponents.dart';
import 'package:shwelamin/pages/addnewimportdata.dart';
import 'package:shwelamin/pages/_webCardProduct.dart';
import 'package:shwelamin/pages/outOfStock.dart';

import '_mobileCartPorductPage.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final ImportDataRepository inputDataRepository = ImportDataRepository();

  final List<ImportModal> _filteredData = [];
  final _searchController = TextEditingController();
  String _searchText = '';

  final _totalProdcts ='';



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ConstsName.appname,
          style: TextStyle(fontSize: 13),
        ),

        actions: [

          Stack(

            children: [

              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 10),
                child: IconButton(onPressed: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>

                    Platform.isAndroid?
                    MobileCardProdctPage()
                    :MyCartProductsPage()
                  )).then((value){

                    setState(() {


                    });
                  });


                }, icon: Icon(CupertinoIcons.cart_fill,color: Colors.white,size: 40,)),
              ),

              Positioned(
                right: 0,
                top: -5,
                child: Container(

                  decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Platform.isAndroid?
                    ConstsData.mobilecartProducts.length.toString()
                    :

                    ConstsData.cartProducts.length.toString()),
                  ),
                ),
              )
            ]
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: getShopNameText()),
                ),
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.cyan,
                        ),
                        label: Text(
                          ConstsName.search,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<ImportModal>>(
                stream: inputDataRepository.getAllInputData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final dataList = snapshot.data!;
                    final filteredData = dataList
                        .where((item) => item.product
                            .toLowerCase()
                            .trim()
                            .contains(_searchText.toLowerCase().trim()))
                        .toList();

                    return isAndroid
                        // ? _webContainer(filteredData)
                        ? _androidContainer(filteredData)
                        : Platform.isIOS
                        ?_androidContainer(filteredData)
                        :_webContainer(filteredData);
                    // : _webContainer(filteredData);
                  } else if (snapshot.hasError) {
                    return  Center(
                      child: Column(
                        children: [
                          IconButton(onPressed: (){

                            setState(() {

                            });

                          }, icon: const Icon(Icons.refresh)),
                          const Text(ConstsName.error),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),


    );
  }

  Widget getShopNameText() {
    return Platform.isAndroid
        ?  Text(
      ConstsName.Products+'${_totalProdcts}',
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    )
        :Platform.isIOS
        ? const Text(
      ConstsName.Products,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    )
        : const Text(
            ConstsName.Products,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          );
  }

  Widget _androidContainer(List<ImportModal> snapshot) {
    final List<ImportModal> filteredList = _filteredData.isNotEmpty ? _filteredData : snapshot;


    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final importModal = filteredList[index];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _buildExpansionTile(importModal)
        );
      },
    );
  }


  Widget _webContainer(List<ImportModal> snapshot) {


    return Column(
      children: [
        _tableColumn(),
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.length,
            itemBuilder: (context, index) {



              String productname = snapshot[index].product.toString();
              String timeStamp = snapshot[index].timeStamp.toString();
              String realprice = snapshot[index].realprice.toString();

              String saleprice =snapshot[index].saleprice.toString();
              String quantity = snapshot[index].quantity.toString();
              String note = snapshot[index].note.toString();







              return Container(


                margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(

                      // color: isSelected? Colors.red : Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Table(
                    border: TableBorder.all(borderRadius: BorderRadius.circular(10)),


                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                    children: [
                      TableRow(

                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(

                              margin:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                (index + 1).toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                MethodHelper.ConvertTimeStampToDate(timeStamp),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                productname,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Row(
                                  children: [
                                    Text(

                                      MethodHelper.formatCurrency(int.parse(realprice)),
                                      textAlign: TextAlign.end,
                                    ),



                                  ]
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Column(
                                children: [


                                  Text(
                                    MethodHelper.formatCurrency(int.parse(saleprice))
                                   ,
                                    textAlign: TextAlign.end,
                                  )

                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                MethodHelper.formatCurrency(int.parse(quantity)),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                note,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _editButtonOnpress(context, snapshot[index]);
                                    });
                                  },
                                  tooltip: 'Edit',
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  )),

                              IconButton(
                                  onPressed: () {
                                    _showLoadingDialog(context, snapshot[index]);
                                  },
                                  tooltip: 'Delete',
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {

                                     ConstsData.addToCart(snapshot[index]);


                                    });

                                  },
                                  tooltip: 'Add To Cart',
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.red,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );



              // return ImportDataComponent(importModal: snapshot[index], Index: index);
            },
          ),
        ),


        Container(
          decoration: const BoxDecoration(

              shape: BoxShape.rectangle,
              color: Colors.blue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [

              InkWell(

                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const AddNewImportProduct(updateModal: null))).then((value) => {



                  });
                },
                child: Container(

                  height: 70,

                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(30),color: Colors.red
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Center(child: Text(ConstsName.addnew,style: TextStyle(color: Colors.white),))
                  ),
                ),
              ),
              InkWell(

                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const OutOfStockPage())).then((value) => {



                  });
                },
                child: Container(

                  height: 70,

                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(30),color: Colors.red
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Center(child: Text(ConstsName.outofStock,style: TextStyle(color: Colors.white),))
                  ),
                ),
              ),



            ],
          ),
        )
      ],
    );
  }


  Widget _tableColumn() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Table(

        defaultVerticalAlignment: TableCellVerticalAlignment.middle,

        children: [
          TableRow(
            children: [
              TableCell(

                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(

                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    ConstsName.nos,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    ConstsName.lastmodifiedDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    ConstsName.proudctname,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    ConstsName.real_price,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    ConstsName.sale_price,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    ConstsName.quantity,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    ConstsName.note,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
               TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,

                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey,),
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Center(
                      child: Text(ConstsName.Functions),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void _editButtonOnpress(context, ImportModal inputModal) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddNewImportProduct(updateModal: inputModal)));
  }

  Future _deleteItem(item) async {
    try {
      await inputDataRepository.deleteImportProduct(item);

      Fluttertoast.showToast(
          msg: ConstsName.successfullydelete,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      // await Future.delayed(const Duration(seconds: 2));

      // _back();
    } catch (e) {
      Fluttertoast.showToast(
          msg: ConstsName.deletefail,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _showLoadingDialog(BuildContext context, item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Deleting...'),
            ],
          ),
        );
      },
    );

    await _deleteItem(item).then((value) => {Navigator.of(context).pop()});
  }

  Widget _buildExpansionTile(ImportModal importModal) {
    String productname = importModal.product.toString();
    // String timeStamp = snapshot[index].timeStamp.toString();
    String realprice = importModal.realprice.toString();
    String saleprice = importModal.saleprice.toString();
    String quantity = importModal.quantity.toString();
    String note = importModal.note.toString();
    return Expanded(
      child: ExpansionTile(
        // title: Text(importModal.product),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ConstsName.proudctname,
                  style: TextStyle(fontSize: 10),
                ),
                Text(productname, style: const TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(ConstsName.sale_price,
                    style: TextStyle(fontSize: 10)),
                Text(MethodHelper.formatCurrency(int.parse(saleprice)), style: const TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(ConstsName.quantity, style: TextStyle(fontSize: 10)),
                Text(MethodHelper.formatCurrency(int.parse(quantity)), style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(ConstsName.proudctname,style: TextStyle(fontSize: 10)),
                Text(productname,style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(ConstsName.real_price,style: TextStyle(fontSize: 10)),
                Text(MethodHelper.formatCurrency(int.parse(realprice)),style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(ConstsName.sale_price,style: TextStyle(fontSize: 10)),
                Text(MethodHelper.formatCurrency(int.parse(saleprice)),style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(ConstsName.quantity,style: TextStyle(fontSize: 10)),
                Text(MethodHelper.formatCurrency(int.parse(quantity)),style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(ConstsName.note,style: TextStyle(fontSize: 10)),
                Text(
                  note,style: const TextStyle(fontSize: 10),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _editButtonOnpress(context, importModal);
                    });
                  },
                  tooltip: ConstsName.edit,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  )),
              Container(
                width: 1,
                color: Colors.black,
              ),
              IconButton(
                  onPressed: () {
                    _showLoadingDialog(context, importModal);
                  },
                  tooltip: ConstsName.delete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              Container(
                width: 1,
                color: Colors.black,
              ),
              IconButton(
                  onPressed: () {
                    //   Add to card

                    setState(() {

                      ConstsData.mobileaddToCart(importModal);
                    });
                  },
                  tooltip: ConstsName.addtocard,
                  icon: const Icon(
                    Icons.add_card_rounded,
                    color: Colors.red,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
