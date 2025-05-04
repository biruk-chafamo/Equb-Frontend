import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/services/equb_service.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

class EqubRepository {
  final EqubService equbService;

  EqubRepository({required this.equbService});

  Future<EqubDetail> getEqubDetail(int id) async {
    final equbJson = await equbService.getEqubDetail(id);
    return EqubDetail.fromJson(equbJson);
  }

  Future<List<EqubDetail>> getEqubs(EqubType type) async {
    final equbJson = await equbService.getEqubs(type);
    return equbJson.map((dynamic item) => EqubDetail.fromJson(item)).toList();
  }

  Future<List<EqubDetail>> getFocusedUserEqubs(int userId) async {
    final equbJson = await equbService.getFocusedUserEqubs(userId);
    return equbJson.map((dynamic item) => EqubDetail.fromJson(item)).toList();
  }

  Future<EqubDetail> createEqub(EqubCreationDTO equb) async {
    final equbJson = await equbService.createEqub(equb);
    return EqubDetail.fromJson(equbJson);
  }

  Future<Equb> updateEqub(int id, Equb equb) async {
    final equbJson = await equbService.updateEqub(id, equb);
    return Equb.fromJson(equbJson);
  }

  Future<EqubDetail> palceBid(int id, double bidAmount) async {
    final equbJson = await equbService.placeBid(id, bidAmount);

    return EqubDetail.fromJson(equbJson);
  }
}
