import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/donation_group.dart';
import 'package:bamx_app/src/model/user_donations.dart';
import 'package:bamx_app/src/repository/donations_repository.dart';
import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDonationRepository extends Mock implements DonationRepository {}

void main() {
  late MockDonationRepository mockDonationRepository;

  setUp(() async {
    await getIt.reset();
    mockDonationRepository = MockDonationRepository();
    getIt.registerSingleton<DonationRepository>(mockDonationRepository);
  });

  blocTest<HistorialCubit, HistorialState>(
    'emits HistorialState when init is called',
    build: () {
      when(() => mockDonationRepository.getUserDonations())
          .thenAnswer((_) => Stream.fromIterable([UserDonations(
            pendientes: [DonationGroup(donationId: "1", donationStatus: 'pendiente', totalPoints: 100, donationDate: DateTime.parse('1969-07-20 20:18:04Z') , donationItems: const [])],
            aprobadas: [DonationGroup(donationId: "2", donationStatus: 'aprobada', totalPoints: 200, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
            rechazadas: [DonationGroup(donationId: "3", donationStatus: 'rechazada', totalPoints: 300, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
          )]));
      return HistorialCubit();
    },
    act: (cubit) async => await cubit.init(),
    expect: () => [
      HistorialState(
        isLoading: false,
        pendientes: [DonationGroup(donationId: "1", donationStatus: 'pendiente', totalPoints: 100, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
        aprobadas: [DonationGroup(donationId: "2", donationStatus: 'aprobada', totalPoints: 200, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
        rechazadas: [DonationGroup(donationId: "3", donationStatus: 'rechazada', totalPoints: 300, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
      ),
    ],
  );

  blocTest<HistorialCubit, HistorialState>(
    'historialListener updates state correctly',
    build: () => HistorialCubit(),
    act: (cubit) => cubit.historialListener(UserDonations(
      pendientes: [DonationGroup(donationId: "1", donationStatus: 'pendiente', totalPoints: 100, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
      aprobadas: [DonationGroup(donationId: "2", donationStatus: 'aprobada', totalPoints: 200, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
      rechazadas: [DonationGroup(donationId: "3", donationStatus: 'rechazada', totalPoints: 300, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
    )),
    expect: () => [
      HistorialState(
        isLoading: false,
        pendientes: [DonationGroup(donationId: "1", donationStatus: 'pendiente', totalPoints: 100, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
        aprobadas: [DonationGroup(donationId: "2", donationStatus: 'aprobada', totalPoints: 200, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
        rechazadas: [DonationGroup(donationId: "3", donationStatus: 'rechazada', totalPoints: 300, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
      ),
    ],
  );

  blocTest<HistorialCubit, HistorialState>(
    'close cancels the subscription',
    build: () {
      when(() => mockDonationRepository.getUserDonations())
          .thenAnswer((_) => Stream.fromIterable([UserDonations(
            pendientes: [DonationGroup(donationId: "1", donationStatus: 'pendiente', totalPoints: 100, donationDate: DateTime.parse('1969-07-20 20:18:04Z') , donationItems: const [])],
            aprobadas: [DonationGroup(donationId: "2", donationStatus: 'aprobada', totalPoints: 200, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
            rechazadas: [DonationGroup(donationId: "3", donationStatus: 'rechazada', totalPoints: 300, donationDate: DateTime.parse('1969-07-20 20:18:04Z'), donationItems: const [])],
          )]));
      return HistorialCubit();
    },
    act: (cubit) async {
      await cubit.init();
      await cubit.close();
    },
    verify: (_) {
      verify(() => mockDonationRepository.getUserDonations().listen(any())).called(1);
    },
  );

}