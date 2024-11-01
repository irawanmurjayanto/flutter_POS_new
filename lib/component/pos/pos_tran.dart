

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_pos_new/component/format/number.dart';
import 'package:flutter_pos_new/component/provider/datamulti.dart';
import 'package:flutter_pos_new/component/report/rpt_transpos.dart';
import 'dart:convert';

import 'package:flutter_pos_new/component/warning.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_pos_new/currecy_format.dart';

class Pos_Tran extends StatefulWidget {
  const Pos_Tran({super.key});

  @override
  State<Pos_Tran> createState() => _Pos_TranState();
}

class _Pos_TranState extends State<Pos_Tran> {
  final box=GetStorage();

  final _Text_Cust = TextEditingController();
  final _Text_Cust_Dialog = TextEditingController();
  final _Text_Qty = TextEditingController();
  final _Text_Disc = TextEditingController();
   String? _temp_qty_pos ;
   String? _temp_disc_pos ;


  getDeletePOS(String idno,String ttl) async {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Delete warning',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
              Text('Delete data '+ttl+'?'),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
              ElevatedButton(onPressed: () async{
                await Provider.of<MultiDatas>(context,listen: false).Delete_Tranpos(idno);
                getTotal();
                Navigator.pop(context);
              }, child: Text('Yes')),
              SizedBox(width: 5,),
                   ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('No')),
                ],
              )
            

          ],
        ),
      );
    },);
  }

  getEditPos(String qty,String disc_val,String idno,String item_desc) async{
   
    setState(() {
      _Text_Qty.text=qty;
      _Text_Disc.text=disc_val;
    });

    showDialog(context: context, builder: (context) {
      
      return AlertDialog(
        title: Text('Edit : ('+idno+')'+item_desc,style: TextStyle(fontSize: 12),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              //edit qty
              TextFormField(
                
                controller: _Text_Qty,
                decoration: InputDecoration(
                  
                      suffixIcon: IconButton(onPressed: () {
                      setState(() {
                      _Text_Qty.text='';
                    });
                  }, icon: Icon(Icons.edit_document)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    
                    borderSide: BorderSide(style: BorderStyle.solid,color: Colors.black)
                  )
                ),
                onChanged: (value) {
                  setState(() {
                    _Text_Qty.text=value;
                  });
               //  await Provider.of<MultiDatas>(context,listen: false).ListBa//
                },
                onTap: () => _Text_Qty.selection = TextSelection(baseOffset: 0, extentOffset: _Text_Qty.value.text.length),
              ),

                SizedBox(height: 5,),
                  //edit discval
              TextFormField(
                controller: _Text_Disc,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      _Text_Disc.text='';
                    });
                  }, icon: Icon(Icons.edit_document)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    
                    borderSide: BorderSide(style: BorderStyle.solid,color: Colors.black)
                  )
                ),
                onChanged: (value)  {
                  setState(() {
                    _Text_Disc.text=value;
                  });
                   // await Provider.of<MultiDatas>(context,listen: false).ListBarcodePos('POS000000024', 'HO');
                },
                         onTap: () => _Text_Disc.selection = TextSelection(baseOffset: 0, extentOffset: _Text_Disc.value.text.length),
              )
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: () async {
             
                await Provider.of<MultiDatas>(context,listen: false).Update_Tranpos(idno, _Text_Qty.text, _Text_Disc.text);
                //Provider.of<MultiDatas>(context,listen: false).ListBarcodePos(no_pos!, kodecab);
                getTotal();
                Navigator.pop(context);
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Pos_Tran(),));
              }, icon: Icon(Icons.save)),
                SizedBox(width: 5,),
               IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Icon(Icons.close))
            ],
          )
        ],
      );
    },);
  }
   
   static String _temp_custname='';
   static String _temp_custid='';

  getCustomer() async {
    await Provider.of<MultiDatas>(context,listen: false).get_ListCustName(_Text_Cust_Dialog.text);
  
  
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(child: 
        AlertDialog(
          title: Text('Customer Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                
                controller: _Text_Cust_Dialog,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    
                  }, icon: Icon(Icons.add,size: 30,)),
                    hintText: 'Customer Name Search',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(style: BorderStyle.solid))),
               onChanged: (value) async {
                 _Text_Cust_Dialog.text=value;
                  await Provider.of<MultiDatas>(context,listen: false).get_ListCustName(_Text_Cust_Dialog.text); 
               },                        
              ),
              SizedBox(height: 5,),
              SingleChildScrollView(
              child: 
              Container(
                height: MediaQuery.of(context).size.height/2,
                child: 
              Consumer<MultiDatas>(builder: (context, provx, child) {
                return ListView.builder(
                  itemCount: provx.global_list_custname.length,
                  itemBuilder: (context, i) {
                     return Container(
                      height: 50,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(style: BorderStyle.solid,color: Colors.white)
                      ),
                        child: 

                        GestureDetector(child: 
                        Row(
                          children: [
                           
                              
                              Expanded(child: 
                              Text(provx.global_list_custname[i].custname!,style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
                              ),
                              SizedBox(width: 5,),
                              SizedBox(width: 30,child: 
                              Icon(Icons.arrow_right,color: Colors.white,size: 30,)),
                             
                                
                            
                            

                          ]
                         
                        ),
                        onTap: () {
                            setState(() {
                                _temp_custid=provx.global_list_custname[i].custid!;
                                _temp_custname=provx.global_list_custname[i].custname!;
                                _Text_Cust.text=provx.global_list_custname[i].custname!;
                            });
                        Navigator.pop(context);
                          setMessage2(provx.global_list_custname[i].custname!);
                        },
                        )
                     );
                },);
                
              },)
              )
              )
            ],
          ),
        ),
        );
      },
    );
 
  }

  final _barcodecode = TextEditingController();
  int? _jumlah;
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff0000", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _barcodecode.text = barcodeScanRes;
      _jumlah = 1;
    });
    setMessage2(barcodeScanRes);
  }

  final NoRef = DateTime.now();

  String? no_pos;
  final String kodecab='HO';

  getNoref() async {
    setState(() {
      int n2 = NoRef.millisecondsSinceEpoch;
      no_pos = 'POS-$n2';
    });

    return no_pos!;
  }
  static String _temp_subtot='0';
  static String _temp_hitpos='0';

  getTotal()async{
   // Future.delayed(Duration(seconds: 5));
    await Provider.of<MultiDatas>(context,listen: false).getSumTranPOS('POS000000024', 'HO');
    final provx=Provider.of<MultiDatas>(context,listen: false);
    setState(() {
          _temp_subtot=provx.global_total_transpo[0].total!;
    _temp_hitpos=provx.global_total_transpo[0].hitpos!;
    });

   // setMessage2(_temp_subtot+'-'+_temp_hitpos);

  }

 
  @override
  void didChangeDependencies() {
   // getTotal();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _temp_custname='';
    _temp_custid='';
    getTotal();
    getNoref();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: ()async => false,
      
      child: 
    Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 100,
        color: Colors.blue,
        elevation: 0,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: 
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Text('Grand Total (Rp.)',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
                ),

                SizedBox(width: 5,),
                  Expanded(
                
                  child: 
                Container(
                   padding: EdgeInsets.all(5),
                   decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                child: Text(CurrencyFormat.convertToIdr(int.parse(_temp_subtot), 0),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                )
                  )
               ],
            ),
            SizedBox(height: 3,),
            //total Transaction
             Row(
              children: [
                SizedBox(
                  width: 150,
                  child: 
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                child: Text('Transaction Total',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
                ),

                SizedBox(width: 5,),
                  Expanded(
 
                  child: 
                Container(
                   padding: EdgeInsets.all(5),
                   decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                 child: Text(CurrencyFormat.convertToIdr(int.parse(_temp_hitpos), 0).toString()+ (int.parse(_temp_hitpos)==1?' (item)':' (items)').toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                )
                  )
               ],
            )
          ],
        )
      ),
      appBar: AppBar(
        title: const Text(
          'Pos Transaction',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            
              onPressed: () {
              Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
          IconButton(
            
              onPressed: () {
                setMessage2(_temp_custid.length.toString());
                  if (_temp_custid.length==0)
                  {
                    setMessage2('Customer harus diisi fahulu');
                     
                  }else{
                  scanBarcodeNormal();
                  }
              },
              icon: Icon(Icons.barcode_reader)),
          IconButton(
              onPressed: () async{
              //  getTotal();
                 Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewExampleScreen(nopos: 'POS000000024'),));
                //InAppWebViewExampleScreen
              //  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Pos_Tran(),));
                //getCustomer();
               //  await Provider.of<MultiDatas>(context,listen: false).ListBarcodePos(no_pos!, kodecab);
              },
              icon: Icon(Icons.print))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(style: BorderStyle.solid)),
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                  child: WCust_Name(),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  no_pos!,
                  style: const TextStyle(color: Colors.white),
                ),
                Header(),
                const SizedBox(
                  height: 5,
                ),
                WDetail()
              ],
            )),
      ),
    ),
    );
  }

  Widget WDetail() {
    return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height / 1.8,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  style: BorderStyle.solid,
                )),
            child: FutureBuilder(
              future: Provider.of<MultiDatas>(context, listen: false)
                  .ListBarcodePos('POS000000024', 'HO'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<MultiDatas>(
                    builder: (context, provx, child) {
                      return ListView.builder(
                        itemCount: provx.global_getitem_pos.length,
                        itemBuilder: (context, i) {
                          return Container(
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 50,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                        Colors.blue,
                                        Colors.green,
                                      ])),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(child: 
                                          Container(
                                              child: Text(
                                            provx.global_getitem_pos[i]
                                                    .item_desc! +
                                                '(' +
                                                provx.global_getitem_pos[i]
                                                    .item_code! +
                                                ')',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ))
                                          ),
                                          SizedBox
                                          
                                          (width: 50,
                                            
                                            child: 
                                          IconButton(onPressed: () {
                                            getEditPos(provx.global_getitem_pos[i].qty!, provx.global_getitem_pos[i].disc_val!, provx.global_getitem_pos[i].idno!, provx.global_getitem_pos[i].item_desc!);
                                          }, icon: Icon(Icons.edit_calendar),iconSize: 30, )
                                          
                                          ),

                                              SizedBox
                                          
                                          (width: 50,
                                            
                                            child: 
                                          IconButton(onPressed: () {
                                            getDeletePOS(provx.global_getitem_pos[i].idno!, provx.global_getitem_pos[i].item_desc!);
                                           // Navigator.pop(context);
                                          }, icon: Icon(Icons.delete),iconSize: 30, )
                                          
                                          ),
                                        ],
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Text('Sub Detail : '),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            CurrencyFormat.convertToIdr(
                                                int.parse(provx
                                                    .global_getitem_pos[i]
                                                    .harga_jual!),
                                                0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            CurrencyFormat.convertToIdr(
                                                int.parse(provx
                                                    .global_getitem_pos[i]
                                                    .qty!),
                                                0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            CurrencyFormat.convertToIdr(
                                                int.parse(provx
                                                    .global_getitem_pos[i]
                                                    .disc_val!),
                                                0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration:
                                            BoxDecoration(color: Colors.grey),
                                        child: Text('Sub Total : Rp. ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration:
                                            BoxDecoration(color: Colors.grey),
                                        child: Text(
                                          CurrencyFormat.convertToIdr(
                                              int.parse(provx
                                                  .global_getitem_pos[i]
                                                  .subtot!),
                                              0),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration:
                                            BoxDecoration(color: Colors.grey),
                                        child: Text('     ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ])
                                ],
                              ));
                        },
                      );
                    },
                  );
                }
              },
            )));
  }

  Widget Header() {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.black),
              child: const Text(
                'Product',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.black),
              child: const Text('Harga',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.black),
              child: const Text('Qty',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.black),
              child: const Text('Discount',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
            onTap: () {
              getCustomer();
            },
          )),
        ],
      ),
    );
  }

  Widget WCust_Name() {
    return Container(
        // decoration: BoxDecoration(
        //   color: Colors.white
        // ),
        padding: const EdgeInsets.all(7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _Text_Cust,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          getCustomer();
                        },
                        icon: Icon(Icons.card_giftcard)),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    hintText: 'Customer Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(style: BorderStyle.solid))),
              ),
            ),
          ],
        ));
  }
}
