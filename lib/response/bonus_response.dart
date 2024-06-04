import 'package:uas_pm/model/bonus_model.dart';

class BonusResponse {
  late List<BonusModel> data;

  BonusResponse({required this.data});

  factory BonusResponse.fromJson(List<dynamic> json) {
    return BonusResponse(
      data: json.map((e) => BonusModel.fromJson(e)).toList(),
    );
  }
}

