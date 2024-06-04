import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:uas_pm/model/bonus_model.dart';
import 'package:uas_pm/service/web_service.dart';
import 'package:uas_pm/ui/tambah_data.dart';

class BonusListPage extends StatefulWidget {
  @override
  _BonusListPageState createState() => _BonusListPageState();
}

class _BonusListPageState extends State<BonusListPage> {
  final WebService _webService = WebService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<BonusModel>> bonusListFuture;
  var _isSearch = false;

  @override
  void initState() {
    super.initState();
    bonusListFuture = _webService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xffF5F7F8),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3FE5E5E5),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                  color: Colors.white,
                ),
                height: 170,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Hi Admin,",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Anda dapat menambahkan\ndata bonus pegawai disini",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 35,
                            child: ElevatedButton(
                              child: Text("Tambah Data", style: TextStyle(fontSize: 14)),
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: BorderSide(color: Colors.indigo),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                var data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => TambahData("ADD", null),
                                  ),
                                );
                                if (data != null && data == true) {
                                  setState(() {
                                    bonusListFuture = _webService.fetchData();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Image.asset('assets/team.png'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerLeft,
                child: _isSearch
                    ? _buildSearchBar()
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Data Pegawai",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearch = true;
                        });
                      },
                      icon: Icon(Icons.search, size: 32),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: FutureBuilder<List<BonusModel>>(
                  future: bonusListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<BonusModel> bonusList = snapshot.data!;
                      return bonusList.isEmpty
                          ? _buildEmptyList()
                          : _buildBonusGrid(bonusList);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextFormField(
      textAlign: TextAlign.start,
      autocorrect: false,
      keyboardType: TextInputType.text,
      controller: _searchController,
      style: TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: "Cari Data Pegawai",
        hintStyle: TextStyle(fontSize: 14),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xff3F5189)),
        ),
        contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        prefixIcon: Icon(Icons.person, color: Colors.grey),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isSearch = false;
              bonusListFuture = _webService.fetchData();
              _searchController.clear();
            });
          },
          icon: Icon(Icons.close, color: Colors.indigo),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      onChanged: (v) async {
        setState(() {
          _isSearch = true;
          bonusListFuture = _webService.search(v);
        });
      },
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 100, color: Colors.grey),
          SizedBox(height: 15),
          Text("Data Pegawai tidak ditemukan."),
        ],
      ),
    );
  }

  Widget _buildBonusGrid(List<BonusModel> bonusList) {
    bonusList.sort((a, b) => b.idPegawai.compareTo(a.idPegawai));

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.75,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: bonusList.length,
      itemBuilder: (context, index) {
        BonusModel bonus = bonusList[index];
        return InkWell(
          onTap: () async {
            var data = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => TambahData("EDIT", bonus),
              ),
            );

            if (data != null && data == true) {
              setState(() {
                bonusListFuture = _webService.fetchData();
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3FE5E5E5),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "${bonus.namaPegawai.split(' ')[0][0]}".toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${bonus.namaPegawai}",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Dialogs.materialDialog(
                            msg: "Hapus data bonus '${bonus.namaPegawai}'?",
                            title: "Hapus Data",
                            context: context,
                            actions: [
                              IconsButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: 'Tidak',
                                iconData: Icons.close,
                                color: Colors.indigo,
                                textStyle: TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                              SizedBox(width: 5),
                              IconsButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _webService.deleteData(bonus.idPegawai).then((_) {
                                    setState(() {
                                      bonusListFuture = _webService.fetchData();
                                    });
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      backgroundColor: Colors.white,
                                      onConfirmBtnTap: () {},
                                      text: "Data Bonus Pegawai berhasil dihapus.",
                                    );
                                  });
                                },
                                text: 'Ya',
                                iconData: Icons.delete,
                                color: Colors.red,
                                textStyle: TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ],
                          );
                        },
                        child: Icon(Icons.remove_circle, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(height: 10, width: 3, color: Colors.green),
                          SizedBox(width: 5),
                          Text("Jumlah Absen", style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              alignment: Alignment.centerRight,
                              child: Text("${bonus.jumlahAbsen}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(height: 10, width: 3, color: Colors.amber),
                          SizedBox(width: 5),
                          Text("Jumlah Lembur", style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              alignment: Alignment.centerRight,
                              child: Text("${bonus.jumlahLembur}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(height: 10, width: 3, color: Colors.red),
                          SizedBox(width: 5),
                          Text("Jumlah Terlambat", style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              alignment: Alignment.centerRight,
                              child: Text("${bonus.jumlahTerlambat}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.wallet, color: Colors.green),
                                SizedBox(width: 3),
                                Text("Total Bonus", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text("+Rp. ${bonus.bonusTotal}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
