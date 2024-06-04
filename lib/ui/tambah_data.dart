import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:uas_pm/model/bonus_model.dart';
import 'package:uas_pm/service/web_service.dart';

class TambahData extends StatefulWidget {
  final String action;
  final BonusModel? bonus;

  TambahData(this.action, [this.bonus]);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final WebService _webService = WebService();
  final TextEditingController _namaPegawaiController = TextEditingController();
  final TextEditingController _jumlahAbsenController = TextEditingController();
  final TextEditingController _jumlahTerlambatController =
  TextEditingController();
  final TextEditingController _jumlahLemburController = TextEditingController();
  final TextEditingController _jumlahGajiController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.action == "EDIT") {
      final bonus = widget.bonus!;
      _namaPegawaiController.text = bonus.namaPegawai;
      _jumlahAbsenController.text = "${bonus.jumlahAbsen}";
      _jumlahTerlambatController.text = "${bonus.jumlahTerlambat}";
      _jumlahLemburController.text = "${bonus.jumlahLembur}";
      _jumlahGajiController.text = "${bonus.jumlahGaji}";
    }
  }

  Future<void> _validateAndSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState?.save();
    final namaPegawai = _namaPegawaiController.text;
    final jumlahAbsen = int.tryParse(_jumlahAbsenController.text) ?? 0;
    final jumlahTerlambat = int.tryParse(_jumlahTerlambatController.text) ?? 0;
    final jumlahLembur = int.tryParse(_jumlahLemburController.text) ?? 0;
    final jumlahGaji = int.tryParse(_jumlahGajiController.text) ?? 0;

    if (namaPegawai.isNotEmpty &&
        jumlahAbsen >= 0 &&
        jumlahTerlambat >= 0 &&
        jumlahLembur >= 0 &&
        jumlahGaji >= 0) {
      final bonusAwal = 0.2 * jumlahGaji;
      final bonusAkhir = bonusAwal -
          (jumlahAbsen * 0.05 * jumlahGaji) -
          (jumlahTerlambat * 0.02 * jumlahGaji) +
          (jumlahLembur * 0.03 * jumlahGaji);

      final newBonus = BonusModel(
        idPegawai: 0,
        namaPegawai: namaPegawai,
        jumlahAbsen: jumlahAbsen,
        jumlahTerlambat: jumlahTerlambat,
        jumlahLembur: jumlahLembur,
        jumlahGaji: jumlahGaji,
        bonusTotal: bonusAkhir.toInt(),
      );

      if (widget.action == "EDIT") {
        await _webService
            .updateData(widget.bonus!.idPegawai, newBonus)
            .then((_) {
          _onSuccessAction();
        });
      } else {
        await _webService.createData(newBonus).then((_) {
          _onSuccessAction();
        });
      }
    }
  }

  void _onSuccessAction() {
    _clearControllers();
    Navigator.of(context).pop(true);
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      backgroundColor: Colors.white,
      onConfirmBtnTap: () {},
      text: widget.action == "EDIT"
          ? "Data Bonus Pegawai berhasil diperbarui"
          : "Data Bonus Pegawai berhasil ditambahkan",
    );
  }

  void _clearControllers() {
    _namaPegawaiController.clear();
    _jumlahAbsenController.clear();
    _jumlahTerlambatController.clear();
    _jumlahLemburController.clear();
    _jumlahGajiController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xffF5F7F8),
          child: Form(
            key: _formKey,
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
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 35,
                              child: ElevatedButton(
                                child: Text(
                                  "<  Kembali",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Hi Admin,",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.action == "EDIT"
                                  ? "Anda dapat memperbarui\ndata bonus pegawai\ndisini"
                                  : "Silakan isi form untuk\nmenambah data bonus\npegawai",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
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
                  child: Text(
                    widget.action == "VIEW" ? "Data Pegawai" : "Tambah Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Column(
                      children: [
                        _buildTextFormField(
                          labelText: "Nama Pegawai",
                          controller: _namaPegawaiController,
                          prefixIcon: Icons.person,
                          keyboardType: TextInputType.text,
                          validator: (v) => v!.isEmpty
                              ? "Nama Pegawai tidak boleh kosong"
                              : null,
                        ),
                        SizedBox(height: 10),
                        _buildTextFormField(
                          labelText: "Jumlah Absen",
                          controller: _jumlahAbsenController,
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty
                              ? "Jumlah Absen tidak boleh kosong"
                              : null,
                        ),
                        SizedBox(height: 10),
                        _buildTextFormField(
                          labelText: "Jumlah Terlambat",
                          controller: _jumlahTerlambatController,
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty
                              ? "Jumlah Terlambat tidak boleh kosong"
                              : null,
                        ),
                        SizedBox(height: 10),
                        _buildTextFormField(
                          labelText: "Jumlah Lembur",
                          controller: _jumlahLemburController,
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty
                              ? "Jumlah Lembur tidak boleh kosong"
                              : null,
                        ),
                        SizedBox(height: 10),
                        _buildTextFormField(
                          labelText: "Jumlah Gaji",
                          controller: _jumlahGajiController,
                          prefixIcon: Icons.wallet,
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty
                              ? "Jumlah Gaji tidak boleh kosong"
                              : null,
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            child: Text(
                              widget.action == "EDIT"
                                  ? "Perbarui Data"
                                  : "Simpan Data",
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.indigo),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(color: Colors.indigo),
                                ),
                              ),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _validateAndSubmit();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required TextEditingController controller,
    required IconData prefixIcon,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        textAlign: TextAlign.start,
        autocorrect: false,
        controller: controller,
        style: TextStyle(fontSize: 16, color: Colors.black),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
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
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.indigo,
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
        validator: validator,
      ),
    );
  }
}
