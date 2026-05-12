import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/register/data/models/user_model.dart';

String getEndpointForUserType(UserType type) {
  switch (type) {
    case UserType.player:
      return Endpoints.signUpPlayer;
    case UserType.coach:
      return Endpoints.signUpCoach;
    case UserType.scout:
      return Endpoints.signUpScout;
    case UserType.club:
      return Endpoints.signUpClub;
    case UserType.institute:
      return Endpoints.signUpInstitute;
    case UserType.others:
      return Endpoints.signUpOther;
  }
}
