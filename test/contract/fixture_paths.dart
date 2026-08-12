/// Fixtures under `captured/` are written by `tool/capture_fixtures.dart` from a
/// live local backend and must never be hand-edited. They are read only by
/// pure-parsing tests: anything that pumps a widget uses the builders in
/// `test/support/builders/` instead, because `TableCalendar` asserts its focused
/// day falls inside a window derived from `DateTime.now()`.
library;

const equbDetailPending = 'captured/equb_detail_pending.json';
const equbDetailInvited = 'captured/equb_detail_invited.json';
const equbDetailActiveBid = 'captured/equb_detail_active_bid.json';
const equbDetailFinalRound = 'captured/equb_detail_final_round.json';
const equbDetailPaymentStage = 'captured/equb_detail_payment_stage.json';
const equbDetailPaymentStageWinner =
    'captured/equb_detail_payment_stage_winner.json';
const equbDetailCompleted = 'captured/equb_detail_completed.json';

const equbsActive = 'captured/equbs_active.json';
const equbsInvited = 'captured/equbs_invited.json';
const equbsRecommended = 'captured/equbs_recommended.json';

const userCurrent = 'captured/user_current.json';
const usersSearch = 'captured/users_search.json';
const usersFriends = 'captured/users_friends.json';

const friendRequestsReceived = 'captured/friend_requests_received.json';
const equbInvitesReceived = 'captured/equb_invites_received.json';
const equbInvitesByEqub = 'captured/equb_invites_by_equb.json';

const paymentMethods = 'captured/payment_methods.json';
const paymentServices = 'captured/payment_services.json';
const paymentConfirmationRequests =
    'captured/payment_confirmation_requests.json';
const bids = 'captured/bids.json';

const authToken = 'captured/auth_token.json';
const authRefresh = 'captured/auth_refresh.json';
const errorEnvelopes = 'captured/error_envelopes.json';
const timestampSamples = 'captured/timestamp_samples.json';
const apiIndex = 'captured/api_index.json';

const equbDetailByState = <String, String>{
  'pending': equbDetailPending,
  'invited': equbDetailInvited,
  'active with an open bid': equbDetailActiveBid,
  'final round': equbDetailFinalRound,
  'payment stage': equbDetailPaymentStage,
  'payment stage as the winner': equbDetailPaymentStageWinner,
  'completed': equbDetailCompleted,
};

const bareArrayFixtures = <String>[
  equbsActive,
  equbsInvited,
  equbsRecommended,
  usersFriends,
  friendRequestsReceived,
  equbInvitesReceived,
  equbInvitesByEqub,
  paymentMethods,
  paymentServices,
  paymentConfirmationRequests,
  bids,
];
