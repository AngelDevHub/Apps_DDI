import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';
import '../providers/weather_provider.dart';
import 'detail_screen.dart';

/// Pantalla de Búsqueda de Ciudades.
/// Utiliza un StatefulWidget para gestionar el estado local del filtrado de la lista.
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Lista estática de ciudades para simular una base de datos o API.
  final List<Map<String, dynamic>> _allCities = const [
    {'name': 'Santiago', 'temp': 24.0, 'cond': 'sunny'},
    {'name': 'Querétaro', 'temp': 22.0, 'cond': 'cloudy'},
    {'name': 'México', 'temp': 20.0, 'cond': 'rainy'},
    {'name': 'Monterrey', 'temp': 30.0, 'cond': 'sunny'},
    {'name': 'Guadalajara', 'temp': 26.0, 'cond': 'cloudy'},
  ];

  // Lista que se actualiza dinámicamente según la búsqueda del usuario.
  late List<Map<String, dynamic>> _filteredCities;
  
  // Controlador para el campo de texto de búsqueda.
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialmente, la lista filtrada muestra todas las ciudades.
    _filteredCities = _allCities;
  }

  @override
  void dispose() {
    // Es buena práctica liberar el controlador cuando el widget se destruye.
    _searchController.dispose();
    super.dispose();
  }

  /// Filtra la lista de ciudades basándose en el texto ingresado.
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCities;
    } else {
      // Filtrado insensible a mayúsculas/minúsculas.
      results = _allCities
          .where((city) =>
              city['name']!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Actualiza el estado local para reflejar los cambios en la UI.
    setState(() {
      _filteredCities = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Campo de entrada de búsqueda
              TextField(
                controller: _searchController,
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  hintText: 'Buscar ciudad...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  // Botón para limpiar el buscador si hay texto
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _runFilter('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              
              // Lista de resultados
              Expanded(
                child: _filteredCities.isNotEmpty
                    ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filteredCities.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final city = _filteredCities[index];
                          return InkWell(
                            onTap: () {
                              // INTEGRACIÓN CON PROVIDER:
                              // Al seleccionar una ciudad, actualizamos el estado global 
                              // de la aplicación para que todas las pantallas reflejen el cambio.
                              Provider.of<WeatherProvider>(context, listen: false).updateWeather(
                                city['name'],
                                city['temp'],
                                city['cond'],
                              );
                              
                              // Navegación a la pantalla de detalle.
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DetailScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    city['name']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${city['temp']}°C',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : // Estado cuando no hay resultados
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron ciudades',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              // Botón de navegación hacia atrás
              CustomButton(
                text: 'Atrás',
                onPressed: () => Navigator.pop(context),
                color: Colors.grey[700],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
