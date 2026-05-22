import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/my_app.dart';
import 'presentation/providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ixdkzstrnwsjewrkaftz.supabase.co',
    anonKey: 'sb_publishable_hRPsps1Gfuc-kWYWqy7asA_EYI2fQki',
  );

  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
}
