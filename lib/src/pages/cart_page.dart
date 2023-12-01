import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/cubits/cart_cubit.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(20.6597, -103.3496),
    zoom: 11,
  );
  static final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(20.634833787881437, -103.41699354338266),
      infoWindow: InfoWindow(
          title:
              'Parroquia de San Jeronimo\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet: 'C. Sagitario 4170, La Calma, 45070 Zapopan, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_2'),
      position: LatLng(20.687425822741695, -103.40913095757375),
      infoWindow: InfoWindow(
          title:
              'Nuestra Señora de la Salud\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet: 'P.º Lomas Altas 265, Lomas del Valle, 45128 Zapopan, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_3'),
      position: LatLng(20.665764819223188, -103.40659032873587),
      infoWindow: InfoWindow(
          title:
              'Parroquia Santa Rita de Casia\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet: 'Av Guadalupe 1668, Chapalita Oriente, 45040 Zapopan, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_4'),
      position: LatLng(20.68286052206871, -103.41239039951039),
      infoWindow: InfoWindow(
          title:
              'Parroquia de San Nicolas de Bari\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet:
              'Cáncer # 4190-A Col 45120, Juan Manuel Vallarta, 45120 Zapopan, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_5'),
      position: LatLng(20.74084831273084, -103.41075167017452),
      infoWindow: InfoWindow(
          title:
              'Nuestra Señora de la caridad del Cobre\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet:
              'C. Arco Decio 1202, Arcos de Zapopan, 45130 Guadalajara, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_6'),
      position: LatLng(20.651622634002397, -103.39928772511166),
      infoWindow: InfoWindow(
          title:
              'Parroquia de la Resurrección del Señor\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet:
              'Av Plaza del Sol 253, Rinconada del Sol, 45050 Zapopan, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_7'),
      position: LatLng(20.68462294506873, -103.37692883191681),
      infoWindow: InfoWindow(
          title:
              'Parroquia de la Santa Cruz\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet:
              'Av. Manuel Acuña 2380, Ladrón de Guevara, Ladron De Guevara, 44650 Guadalajara, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_8'),
      position: LatLng(20.649229680193113, -103.40268122873586),
      infoWindow: InfoWindow(
          title: 'Plaza del Sol\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet:
              'Av. Adolfo López Mateos Sur 2375, Cd del Sol, 45050 Zapopan, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_9'),
      position: LatLng(20.71042634669587, -103.41198375757429),
      infoWindow: InfoWindow(
          title: 'Plaza Andares\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet:
              'Blvrd Puerta de Hierro 4965, Puerta de Hierro, 44100 Guadalajara, Jal.'),
    ),
    const Marker(
      markerId: MarkerId('marker_10'),
      position: LatLng(20.6736284810099, -103.40496814223849),
      infoWindow: InfoWindow(
          title:
              'La Gran Plaza Fashion Mall\n\n Hora de atención: 8:00 Am - 5:00 Pm',
          snippet:
              'Av. Ignacio L Vallarta 3959, Don Bosco Vallarta, 45049 Zapopan, Jal.'),
    ),
    // Añade más marcadores si es necesario
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: BlocProvider(
        create: (context) => CartCubit()..init(),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.cartItems.isEmpty) {
              return const Center(
                child: Text("No hay donaciones disponibles"),
              );
            } else {
              final cartItemsList = state.cartItems.toList();
              return ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Mi Carrito",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento
                    shrinkWrap:
                        true, // Necesario para ListView.builder dentro de otro ListView
                    itemCount: cartItemsList.length,
                    itemBuilder: (context, index) {
                      return ListItem(
                        item: cartItemsList[index].item,
                        quantity:
                            ValueNotifier<int>(cartItemsList[index].cantidad),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 128.0, vertical: 64.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        List<dynamic> donationInfo = await context.read<CartCubit>().cartoToDonation();
                        Navigator.of(context).pushNamed(Routes.donationConfirmation, arguments: {
                          'donationUID': donationInfo[0],
                          'donationCount': donationInfo[2],
                          'pointsAwarded': donationInfo[1],
                          'status': "Pendiente",
                        });
                      },
                      child: const Text('Donar'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Centros de Acopio",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Container(
                      height: 300, // Altura fija para el mapa
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: GoogleMap(
                          initialCameraPosition: _cameraPosition,
                          markers: _markers,
                          zoomControlsEnabled: true,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final ItemDonacion item;
  final ValueNotifier<int> quantity;

  const ListItem({super.key, required this.item, required this.quantity});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.item.nombre),
          Row(
            children: [
              RawMaterialButton(
                onPressed: () {
                  context.read<CartCubit>().deleteItemToCart(widget.item);
                },
                shape: const CircleBorder(),
                fillColor: MyColors.primary,
                child: const Icon(Icons.remove, color: Colors.white),
              ),
              ValueListenableBuilder<int>(
                valueListenable: widget.quantity,
                builder: (context, value, child) {
                  return Text(value.toString());
                },
              ),
              RawMaterialButton(
                onPressed: () {
                  context.read<CartCubit>().addItemToCart(widget.item);
                },
                shape: const CircleBorder(),
                fillColor: MyColors.yellow,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  context.read<CartCubit>().removeItem(widget.item.id);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
      subtitle: Text("Unidad: ${widget.item.unidad}"),
    );
  }
}
