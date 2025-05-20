class MatkulModel {
  int? id;
  String? nama_matkul;
  int? sks;
  

  MatkulModel({
    this.id,
    this.nama_matkul,
    this.sks,
    
  });

  MatkulModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama_matkul = json['nama_matkul'];
    sks = json['sks'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_matkul'] = nama_matkul;
    data['sks'] = sks;
    return data;
  }
}
