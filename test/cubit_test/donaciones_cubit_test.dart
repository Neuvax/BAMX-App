import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/repository/item_donacion_repository.dart';
import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemDonacionRepository extends Mock implements ItemDonacionRepository {}

void main() {
  late MockItemDonacionRepository mockItemDonacionRepository;

  setUpAll(() {
    registerFallbackValue(const ItemDonacion(
      id: '1',
      nombre: 'nombre',
      imagen: 'imagen',
      unidad: 'unidad',
      prioridad: 1,
    ));
  });

  setUp(() async {
    await getIt.reset();
    mockItemDonacionRepository = MockItemDonacionRepository();
    getIt.registerSingleton<ItemDonacionRepository>(mockItemDonacionRepository);
  });

  blocTest<ListaDonacionesPrioritariasCubit, ListaDonacionesState>(
    'emits ListaDonacionesState when init is called',
    build: () {
      when(() => mockItemDonacionRepository.getPriorityItems())
          .thenAnswer((_) => Stream.fromIterable([[const ItemDonacion(
            id: '1',
            nombre: 'nombre',
            imagen: 'imagen',
            unidad: 'unidad',
            prioridad: 1,
          )]]));
      return ListaDonacionesPrioritariasCubit();
    },
    act: (cubit) async => await cubit.init(),
    expect: () => [
      const ListaDonacionesState(
        isLoading: false,
        listaItemsDonaciones: [ItemDonacion(
          id: '1',
          nombre: 'nombre',
          imagen: 'imagen',
          unidad: 'unidad',
          prioridad: 1,
        )],
      ),
    ],
  );

  blocTest<ListaDonacionesPrioritariasCubit, ListaDonacionesState>(
    'addItemToCart calls ItemDonacionRepository.addItemToCart',
    build: () {
      when(() => mockItemDonacionRepository.addItemToCart(any()))
          .thenAnswer((_) async => {});
      return ListaDonacionesPrioritariasCubit();
    },
    act: (cubit) => cubit.addItemToCart(const ItemDonacion(
      id: '1',
      nombre: 'nombre',
      imagen: 'imagen',
      unidad: 'unidad',
      prioridad: 1,
    )),
    verify: (_) {
      verify(() => mockItemDonacionRepository.addItemToCart(any())).called(1);
    },
  );

  blocTest<ListaDonacionesCubit, ListaDonacionesState>(
    'addItemToCart calls ItemDonacionRepository.addItemToCart',
    build: () {
      when(() => mockItemDonacionRepository.addItemToCart(any()))
          .thenAnswer((_) async => {});
      return ListaDonacionesCubit();
    },
    act: (cubit) => cubit.addItemToCart(const ItemDonacion(
      id: '1',
      nombre: 'nombre',
      imagen: 'imagen',
      unidad: 'unidad',
      prioridad: 1,
    )),
    verify: (_) {
      verify(() => mockItemDonacionRepository.addItemToCart(any())).called(1);
    },
  );

  blocTest<ListaDonacionesCubit, ListaDonacionesState>(
    'emits ListaDonacionesState when init is called',
    build: () {
      when(() => mockItemDonacionRepository.getNormalItems())
          .thenAnswer((_) => Stream.fromIterable([[const ItemDonacion(
            id: '1',
            nombre: 'nombre',
            imagen: 'imagen',
            unidad: 'unidad',
            prioridad: 1,
          )]]));
      return ListaDonacionesCubit();
    },
    act: (cubit) async => await cubit.init(),
    expect: () => [
      const ListaDonacionesState(
        isLoading: false,
        listaItemsDonaciones: [ItemDonacion(
          id: '1',
          nombre: 'nombre',
          imagen: 'imagen',
          unidad: 'unidad',
          prioridad: 1,
        )],
      ),
    ],
  );
  
}