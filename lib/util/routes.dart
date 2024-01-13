import 'package:get/get.dart';
import 'package:sisarthro_app/util/sample.bind.dart';
import 'package:sisarthro_app/views/atividade.dart';
import 'package:sisarthro_app/views/com_envio.dart';
import 'package:sisarthro_app/views/com_importa.dart';
import 'package:sisarthro_app/views/consulta/consulta.dart';
import 'package:sisarthro_app/views/manutencao.dart';
import 'package:sisarthro_app/views/principal.dart';
import 'package:sisarthro_app/views/splash.dart';
import 'package:sisarthro_app/views/captura.dart';

class Routes {
  static const SPLASH = '/';
  static const HOME = '/home';
  static const COM_IMPORTA = '/com_importa';
  static const COM_EXPORTA = '/com_exporta';
  static const ATIVIDADE = '/atividade';
  static const CAPTURA = '/captura';
  static const CONSULTA = '/consulta';
  static const LIMPEZA = '/limpeza';
}

List<GetPage<dynamic>> rotas = [
  GetPage(name: Routes.SPLASH, page: () => SplashPage()),
  GetPage(name: Routes.HOME, page: () => Principal()),
  GetPage(name: Routes.COM_IMPORTA, page: () => ComImporta()),
  GetPage(name: Routes.COM_EXPORTA, page: () => ComExporta()),
  GetPage(
      name: Routes.ATIVIDADE, page: () => Atividade(), binding: SampleBind()),
  GetPage(name: Routes.CAPTURA, page: () => Captura(), binding: SampleBind()),
   GetPage(name: Routes.CONSULTA, page: () => Consulta()),
  GetPage(
      name: Routes.LIMPEZA,
      page: () => ManutencaoView(),
      binding: SampleBind()),
];
