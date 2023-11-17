import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/cart_item.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/cubits/cart_cubit.dart';
import 'package:bamx_app/src/repository/cart_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockCartRepository;

  setUp(() async {
    await getIt.reset();
    mockCartRepository = MockCartRepository();
    getIt.registerSingleton<CartRepository>(mockCartRepository);
  });

  blocTest<CartCubit, CartState>(
    'emits CartState with cartItems when cartListener is called',
    build: () {
      when(() => mockCartRepository.getUserCart())
          .thenAnswer((_) => Stream.fromIterable([[CartItem(item: ItemDonacion(
          id: '1',
          nombre: 'nombre',
          imagen: 'imagen',
          unidad: 'unidad',
          prioridad: 1,
        ), cantidad: 1)]]));
    return CartCubit();
  },
  act: (cubit) async => await cubit.init(),
  expect: () => [
    CartState(isLoading: false, cartItems: [const CartItem(item: ItemDonacion(
      id: '1',
      nombre: 'nombre',
      imagen: 'imagen',
      unidad: 'unidad',
      prioridad: 1,
    ), cantidad: 1)]), 
    ],
  );

  blocTest<CartCubit, CartState>(
    'addItemToCart calls CartRepository.addItemToCart',
    build: () => CartCubit(),
    act: (cubit) => cubit.addItemToCart(ItemDonacion(
      id: '1',
      nombre: 'nombre',
      imagen: 'imagen',
      unidad: 'unidad',
      prioridad: 1,
    )),
    verify: (_) {
      verify(() => mockCartRepository.addItemToCart(any())).called(1);
    },
  );

  blocTest<CartCubit, CartState>(
    'removeItem calls CartRepository.removeItemFromCart',
    build: () => CartCubit(),
    act: (cubit) => cubit.removeItem('itemId'),
    verify: (_) {
      verify(() => mockCartRepository.removeItemFromCart(any())).called(1);
    },
  );

  blocTest<CartCubit, CartState>(
    'deleteItemToCart calls CartRepository.deleteItemToCart',
    build: () => CartCubit(),
    act: (cubit) => cubit.deleteItemToCart(ItemDonacion(
      id: '1',
      nombre: 'nombre',
      imagen: 'imagen',
      unidad: 'unidad',
      prioridad: 1,
    )),
    verify: (_) {
      verify(() => mockCartRepository.deleteItemToCart(any())).called(1);
    },
  );
}