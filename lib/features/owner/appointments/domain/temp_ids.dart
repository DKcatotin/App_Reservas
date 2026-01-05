String makeTempId(String prefix) =>
    'tmp_${prefix}_${DateTime.now().millisecondsSinceEpoch}';

bool isTempId(String id) => id.startsWith('tmp_');
