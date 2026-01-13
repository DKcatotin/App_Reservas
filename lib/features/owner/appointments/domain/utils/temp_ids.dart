//crea y conoce si un id es temporal o no
String makeTempId(String prefix) =>
    'tmp_${prefix}_${DateTime.now().millisecondsSinceEpoch}';

bool isTempId(String id) => id.startsWith('tmp_');
