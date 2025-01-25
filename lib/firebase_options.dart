import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final DefaultFirebaseOptions =  FirebaseOptions(
  apiKey: dotenv.get("API_KEY"),  // dotenv에서 값 가져오기
  appId: dotenv.get("APP_ID"),
  messagingSenderId: dotenv.get("MESSAGING_SENDER_ID"),
  projectId: dotenv.get("PROJECT_ID"),
  storageBucket: dotenv.get("STORAGE_BUCKET"),
);

