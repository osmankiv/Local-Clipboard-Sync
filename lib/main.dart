import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf; // أضفنا اسم مستعار هنا

void main() {
  runApp(const ClipboardReceiverApp());
}

class ClipboardReceiverApp extends StatelessWidget {
  const ClipboardReceiverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مستقبل الحافظة',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpServer? _server;
  String _ipAddress = 'جاري الجلب...';
  String _lastReceivedText = 'لم يتم استقبال أي نص بعد...';
  bool _isServerRunning = false;

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  Future<void> _startServer() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP() ?? 'غير متصل بالواي فاي';

    // استخدام الـ Router الخاص بمكتبة الـ shelf مع الاسم المستعار
    final router = shelf.Router();

    // مسار استقبال النص من الحاسوب
    router.post('/send-text', (Request request) async {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);
      final receivedText = data['text'] as String?;

      if (receivedText != null && receivedText.isNotEmpty) {
        // نسخ النص تلقائيًا إلى حافظة الهاتف
        await Clipboard.setData(ClipboardData(text: receivedText));

        setState(() {
          _lastReceivedText = receivedText;
        });

        return Response.ok(
          jsonEncode({'status': 'success', 'message': 'Copied to clipboard'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.badRequest(body: 'النص فارغ');
    });

    try {
      final server = await shelf_io.serve(router.call, InternetAddress.anyIPv4, 8080);
      setState(() {
        _server = server;
        _ipAddress = ip;
        _isServerRunning = true;
      });
    } catch (e) {
      setState(() {
        _isServerRunning = false;
        _ipAddress = 'خطأ في تشغيل الخادم';
      });
    }
  }

  @override
  void dispose() {
    _server?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مستقبل الحافظة المحلية'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: _isServerRunning ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isServerRunning ? Icons.wifi : Icons.wifi_off,
                      size: 40,
                      color: _isServerRunning ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isServerRunning ? 'الخادم يعمل بنجاح' : 'الخادم متوقف',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('عنوان IP الهاتف: $_ipAddress:8080'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'آخر نص تم استقباله ونسخه:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _lastReceivedText,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}