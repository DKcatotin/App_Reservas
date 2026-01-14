//fecha y comparacion si las fechas son del mismo dia
DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
bool isSameDate(DateTime a, DateTime b) => dateOnly(a) == dateOnly(b);
