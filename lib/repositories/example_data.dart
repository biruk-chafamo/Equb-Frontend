// import everything from models folder
import 'package:equb_v3_frontend/models/authentication/user.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/models/payment_tracking/payment_status.dart';

User currentRoundWinner =
    User(username: 'bchafamo', firstName: 'biruk', lastName: 'chafamo');
User dani = User(username: 'Dani', firstName: 'Daniel', lastName: 'Chafamo');
User sosi = User(username: 'Sosi', firstName: 'Sosina', lastName: 'Abuhay');
User thisUser =
    User(username: 'bchafamo', firstName: 'biruk', lastName: 'chafamo');

Equb exampleEqub = Equb(
    name: 'myequb',
    capacity: 1000,
    maxMembers: 10,
    cycle: 'monthly',
    currentRound: 4,
    creationDate: '2021-01-01',
    isPrivate: false,
    isActive: true,
    isCompleted: false,
    members: [dani, sosi, thisUser]);

PaymentStatus examplePaymentStatus = PaymentStatus(
  equb: exampleEqub,
  round: 4,
  paidMembers: [dani, sosi],
  unpaidMembers: [dani],
  confirmationRequestedMembers: [sosi, dani, sosi, dani, dani],
  confirmationReceivedMembers: [sosi, dani],
);

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
  final String x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;
}

final List<ChartData> chartDataList = [
  ChartData('3', 0, 0.2, 0.14, 0.18),
  ChartData('4', 0, 0.3, 0.16, 0.21),
  ChartData('5', 0, 0.3, 0.18, 0.24),
  ChartData('6', 0, 0.5, 0.15, 0.3),
  ChartData('7', 0, 0.4, 0.09, 0.32),
  ChartData('8', 0, 0.3, 0.13, 0.26),
  ChartData('9', 0, 0.5, 0.15, 0.3),
  ChartData('10', 0, 0.4, 0.09, 0.32),
  ChartData('11', 0, 0.3, 0.13, 0.26),
];
