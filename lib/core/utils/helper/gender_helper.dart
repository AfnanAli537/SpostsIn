import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/generated/l10n.dart';

class GenderHelper {
  // Convert ID to Label for display
  static String? genderIdToLabel(int? genderId, S? s) {
    if (genderId == null || genderId == 0) return null;
    if (genderId == 1) return s?.male ?? 'Male';
    if (genderId == 2) return s?.female ?? 'Female';
    return null;
  }
  
  // Convert Label to ID for API
  static int? genderLabelToId(String? label, S? s) {
    if (label == null) return null;
    
    final genderEnum = EnumMapper.fromLabel(
      EnumMapper.genderLabels(s),
      label,
    );
    
    return genderEnum != null ? EnumMapper.getGenderId(genderEnum) : null;
  }
}