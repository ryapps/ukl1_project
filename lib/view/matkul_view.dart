import 'package:flutter/material.dart';
import 'package:ukl1_project/models/matkul_model.dart';
import 'package:ukl1_project/services/matkul.dart';

class MatkulView extends StatefulWidget {
  const MatkulView({super.key});

  @override
  State<MatkulView> createState() => _MatkulViewState();
}

class _MatkulViewState extends State<MatkulView> {
  Future<List<MatkulModel>>? futureMatkul;
  Map<int, bool> selectedMap = {};

  @override
  void initState() {
    super.initState();
    futureMatkul = MatkulService().getMatkul();
  }

  Future<void> simpanTerpilih() async {
    final snapshot = await futureMatkul;
    if (snapshot == null) return;

    final selectedMatkulList =
        snapshot
            .where((matkul) => selectedMap[matkul.id] == true)
            .map(
              (matkul) => {
                'id': matkul.id.toString(),
                'nama_matkul': matkul.nama_matkul,
                'sks': matkul.sks,
              },
            )
            .toList();

    if (selectedMatkulList.isEmpty) {
      showDialog(
        context: context,
        builder:
            (_) => const AlertDialog(
              title: Text('Peringatan'),
              content: Text('Pilih minimal satu mata kuliah terlebih dahulu.'),
            ),
      );
      return;
    }

    try {
      final response = await MatkulService().selectMatkul({
        'list_matkul': selectedMatkulList,
      });

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(response.status ? 'Berhasil' : 'Gagal'),
              content: Text(response.message ?? ''),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Terjadi kesalahan'),
              content: Text('Gagal menyimpan mata kuliah: $e'),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Mata Kuliah',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<MatkulModel>>(
        future: futureMatkul,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data mata kuliah kosong'));
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 220, 220, 220),
                      ),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Mat Kul')),
                        DataColumn(label: Text('SKS')),
                        DataColumn(label: Text('Pilih')),
                      ],
                      rows:
                          data.map((matkul) {
                            final isSelected = selectedMap[matkul.id] ?? false;
                            return DataRow(
                              cells: [
                                DataCell(Text(matkul.id.toString())),
                                DataCell(Text(matkul.nama_matkul ?? '-')),
                                DataCell(Text(matkul.sks?.toString() ?? '-')),
                                DataCell(
                                  Checkbox(
                                    focusColor:  Colors.red,
                                    activeColor: Colors.red,
                                    
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMap[matkul.id!] =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: simpanTerpilih,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Simpan yang terpilih'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
