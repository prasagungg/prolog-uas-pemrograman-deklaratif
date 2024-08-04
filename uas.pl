:- use_module(library(odbc)).

% Database connection setup
connect_to_db :-
    odbc_connect('myodbc', _, [user(root), password(''), alias(mahasiswa_db), open(once)]).

disconnect_from_db :-
    odbc_disconnect(mahasiswa_db).

tambah_nilai(NIM, Kode_MK, Nilai) :-
    format(atom(Query), 'INSERT INTO nilai (nim, kode_mk, nilai) VALUES (\'~w\', \'~w\', \'~w\')', [NIM, Kode_MK, Nilai]),
    odbc_query(mahasiswa_db, Query),
    writeln('Data nilai berhasil ditambahkan.').

tampilkan_nilai_mahasiswa(NIM) :-
    format(atom(SQL), 'SELECT m.Nama, mk.nama_pelajaran, n.nilai FROM mahasiswa m, mata_kuliah mk, nilai n WHERE m.nim = n.nim AND mk.kode_mk = n.kode_mk AND m.nim = \'~w\'', [NIM]),
    odbc_query(mahasiswa_db, SQL, Row),
    tampilkan_hasil(Row).

tampilkan_hasil(row(Nama_Mahasiswa, Nama_MK, Nilai)) :-
    format('Nama Mahasiswa: ~w~n', [Nama_Mahasiswa]),
    format('Mata Kuliah: ~w, Nilai: ~w~n', [Nama_MK, Nilai]),
    fail.
tampilkan_hasil(_).

main :-
    connect_to_db,
    % Contoh menambah data nilai
    tambah_nilai('12345', 'MK001', 85),
    tambah_nilai('12345', 'MK002', 90),
    tambah_nilai('12346', 'MK001', 85),
    tambah_nilai('12347', 'MK002', 90),
    
    % Contoh menampilkan nilai per mahasiswa
    writeln('Nilai Mahasiswa dengan NIM 12345:'),
    tampilkan_nilai_mahasiswa('12345'),
    
    disconnect_from_db.
