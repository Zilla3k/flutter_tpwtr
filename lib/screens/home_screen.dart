import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:type_weather/service/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  final ApiService apiService = ApiService();

  Map<String, dynamic>? weatherData;
  bool isLoading = false;

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });

    final result = await apiService.fetchWeather(city);

    setState(() {
      weatherData = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Center widgets on screen device
    final totalHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final availableHeight = totalHeight - appBarHeight - statusBarHeight - 300;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131A),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('images/logo.svg', height: 28),
            const SizedBox(width: 8),
            const Text(
              'Type Weather',
              style: TextStyle(
                color: Color(0xFFFAFAFA),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          SizedBox(
            height: availableHeight,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildWelcomeText(),
                    const SizedBox(height: 20),
                    _buildSearchField(searchController),
                    const SizedBox(height: 20),
                    if (weatherData != null) _buildWeatherInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: const [
        Text(
          'Boas vindas ao TypeWeather!',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          'Escolha um local para ver a previsão do tempo',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSearchField(TextEditingController controller) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Buscar local',
            hintStyle: const TextStyle(color: Color(0xFF7F7F98)),
            filled: true,
            fillColor: const Color(0xFF1E1E29),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (city) {
            if (city.isNotEmpty) {
              fetchWeather(city);
            }
          },
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8FB2F5)),
                backgroundColor: Color(0xFF1E1E29),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWeatherInfo() {
    final temp = weatherData!['main']['temp'];
    final desc = weatherData!['weather'][0]['description'];
    final city = weatherData!['name'];
    final icon = weatherData!['weather'][0]['icon'];

    return Column(
      children: [
        Image.network('https://openweathermap.org/img/wn/$icon@2x.png'),
        Text(
          '$city: ${temp.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
        Text(desc, style: const TextStyle(fontSize: 16, color: Colors.white70)),
      ],
    );
  }
}
