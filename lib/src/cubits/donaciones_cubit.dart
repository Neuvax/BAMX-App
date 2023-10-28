import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/repository/item_donacion_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListaDonacionesCubit extends Cubit<ListaDonacionesState> {
  final ItemDonacionRepository _itemDonacionRepository = getIt();
  StreamSubscription? _itemsDonacionesSubscription;

  ListaDonacionesCubit() : super(const ListaDonacionesState());
  Future<void> init() async {
    _itemsDonacionesSubscription = _itemDonacionRepository.getItems().listen(donacionesListener);
  }

  void donacionesListener(Iterable<ItemDonacion> listaItemsDonaciones) {
    emit(ListaDonacionesState(
      isLoading: false,
      listaItemsDonaciones: listaItemsDonaciones,
    ));
  }

  @override
  Future<void> close() {
    _itemsDonacionesSubscription?.cancel();
    return super.close();
  }
}

class ListaDonacionesState extends Equatable {
  final bool isLoading;
  final Iterable<ItemDonacion> listaItemsDonaciones;

  const ListaDonacionesState({
    this.isLoading = true,
    this.listaItemsDonaciones = const [],
  });

  @override
  List<Object> get props => [isLoading, listaItemsDonaciones];
}