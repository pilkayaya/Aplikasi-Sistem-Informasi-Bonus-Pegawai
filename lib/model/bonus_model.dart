class BonusModel {
  late int idPegawai;
  late String namaPegawai;
  late int jumlahAbsen;
  late int jumlahTerlambat;
  late int jumlahLembur;
  late int jumlahGaji;
  late int bonusTotal;

  BonusModel({
    required this.idPegawai,
    required this.namaPegawai,
    required this.jumlahAbsen,
    required this.jumlahTerlambat,
    required this.jumlahLembur,
    required this.jumlahGaji,
    required this.bonusTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_pegawai': idPegawai,
      'nama_pegawai': namaPegawai,
      'jumlah_absen': jumlahAbsen,
      'jumlah_terlambat': jumlahTerlambat,
      'jumlah_lembur': jumlahLembur,
      'jumlah_gaji': jumlahGaji,
      'bonus_total': bonusTotal,
    };
  }

  factory BonusModel.fromJson(Map<String, dynamic> json) {
    return BonusModel(
      idPegawai: int.parse(json['id_pegawai']),
      namaPegawai: json['nama_pegawai'],
      jumlahAbsen: int.parse(json['jumlah_absen']),
      jumlahTerlambat: int.parse(json['jumlah_terlambat']),
      jumlahLembur: int.parse(json['jumlah_lembur']),
      jumlahGaji: int.parse(json['jumlah_gaji']),
      bonusTotal: int.parse(json['bonus_total']),
    );
  }
}
