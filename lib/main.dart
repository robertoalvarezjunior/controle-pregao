import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:nicolas/view/cadastro_dialog.dart';
import 'package:nicolas/view/table_visualizacao_view.dart';
import 'package:nicolas/view_model/get_pregoes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Licitações do Nicolas',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xff065808),
          primaryContainer: Color(0xff9ee29f),
          secondary: Color(0xff365b37),
          secondaryContainer: Color(0xffaebdaf),
          tertiary: Color(0xff2c7e2e),
          tertiaryContainer: Color(0xffb8e6b9),
          appBarColor: Color(0xffb8e6b9),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xff629f80),
          primaryContainer: Color(0xff274033),
          secondary: Color(0xff81b39a),
          secondaryContainer: Color(0xff4d6b5c),
          tertiary: Color(0xff88c5a6),
          tertiaryContainer: Color(0xff356c50),
          appBarColor: Color(0xff356c50),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
      themeMode: ThemeMode.dark,

      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController txt1 = TextEditingController();
  final TextEditingController txt2 = TextEditingController();
  final GetPregoesNotifier listaPregoes = GetPregoesNotifier();

  final TextEditingController searchController = TextEditingController();

  String search = '';

  @override
  void initState() {
    super.initState();
    listaPregoes.getPregoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          labelText: "Pesquisar"),
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FilledButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CadastroDialog(),
                        ).then(
                          (value) => listaPregoes.getPregoes(),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cadastrar"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListenableBuilder(
              listenable: listaPregoes,
              builder: (context, child) => TableVisualizacaoView(
                listaPregoes: listaPregoes,
                search: search,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
