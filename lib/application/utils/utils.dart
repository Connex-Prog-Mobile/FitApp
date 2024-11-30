import 'dart:io';

import 'package:FitApp/application/infra/@providers/User.provider.dart';
import 'package:FitApp/application/infra/database/models/user.model.dart';
import 'package:FitApp/application/infra/database/repositories/user.repository.dart';
import 'package:FitApp/application/infra/routes/config.router.dart';
import 'package:FitApp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void navigateTo(BuildContext context, String routeName) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final userType = userProvider.userType;

  if (accessibleRoutes[userType]?.contains(routeName) ?? false) {
    Navigator.pushNamed(context, routeName);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Acesso negado!')),
    );
  }
}

class PdfGenerator {
  final UserRepository userRepository;

  PdfGenerator({required this.userRepository});

  Future<void> generateStudentPdf(BuildContext context, int userId) async {
    try {
      final Map<String, dynamic>? user =
          await userRepository.getUserById(userId);

      if (user == null) {
        throw Exception('Usuário não encontrado.');
      }

      final userData = User.fromMap(user);
      final pdf = pw.Document();

      final robotoFont = await rootBundle
          .load('lib/application/assets/fonts/Roboto/Roboto-Bold.ttf');
      final pdfRobotoFont = pw.Font.ttf(robotoFont);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Informações do Aluno',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: pdfRobotoFont,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Nome: ${userData.name}',
                    style: pw.TextStyle(fontSize: 16, font: pdfRobotoFont)),
                pw.Text('Email: ${userData.email}',
                    style: pw.TextStyle(fontSize: 16, font: pdfRobotoFont)),
                pw.Text('Altura: ${userData.height} m',
                    style: pw.TextStyle(fontSize: 16, font: pdfRobotoFont)),
                pw.Text('Peso: ${userData.weight} kg',
                    style: pw.TextStyle(fontSize: 16, font: pdfRobotoFont)),
                pw.SizedBox(height: 20),
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/informacoes_aluno.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      await _allowDownload(filePath, context);
    } catch (e) {
      print("Erro ao gerar PDF: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar PDF: $e')),
        );
      }
    }
  }

  Future<void> _allowDownload(String filePath, BuildContext context) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('default_notification_channel_id', 'Default',
            importance: Importance.max, priority: Priority.max);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    if (Platform.isAndroid) {
      // Solicitar permissão de armazenamento
      final result = await Permission.storage.request();

      // Verificar se a permissão foi concedida
      if (result == PermissionStatus.granted) {
        print("Permissão concedida com sucesso.");
        // Continuar com a lógica de salvar o PDF
        try {
          if (context.mounted) {
            await flutterLocalNotificationsPlugin.show(1,
                'PDF gerado com sucesso: $filePath', '', notificationDetails);
          }
        } catch (e) {
          print("Erro ao gerar o PDF: $e");
          if (context.mounted) {
            await flutterLocalNotificationsPlugin.show(1,
                'Permissão de armazenamento negada.', '', notificationDetails);
          }
        }
      } else {
        print("Permissão de armazenamento negada.");
        if (result.isDenied || result.isPermanentlyDenied) {
          if (context.mounted) {
            await flutterLocalNotificationsPlugin.show(1,
                'Permissão de armazenamento negada.', '', notificationDetails);
          }
        }
      }
    }
  }
}
