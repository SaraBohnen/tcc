import 'package:app_chain_view/views/viewmodels/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/prefs_service.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            body: PageView(
              controller: controller,
              onPageChanged: vm.setPage,
              children: [
                OnboardingPage(
                  imageAsset: "assets/images/onboarding1.png",
                  title: "Gerencie facilmente",
                  description:
                      "Acompanhe todas as suas criptomoedas em um só lugar, com clareza e praticidade.",
                  buttonText: "Próximo",
                  onNext:
                      () => controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      ),
                ),
                OnboardingPage(
                  imageAsset: "assets/images/onboarding1.png",
                  title: "Navegue entre carteiras",
                  description:
                      "Adicione diferentes carteiras para gerenciar seu portfólio do seu jeito.",
                  buttonText: "Próximo",
                  onNext:
                      () => controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      ),
                ),
                OnboardingPage(
                  imageAsset: "assets/images/onboarding1.png",
                  title: "Métricas e análises inteligentes",
                  description:
                      "Acompanhe gráficos atualizados e visualize o desempenho da sua carteira de forma simples e intuitiva.",
                  buttonText: "Vamos lá!",
                  onNext: () async {
                    await PrefsService().setOnboardingDone();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                ),
              ],
            ),
            bottomNavigationBar: _buildDots(vm.currentPage),
          );
        },
      ),
    );
  }

  Widget _buildDots(int currentPage) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final active = currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 12 : 8,
              height: active ? 12 : 8,
              decoration: BoxDecoration(
                color: active ? Colors.blue : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ),
    );
  }
}
