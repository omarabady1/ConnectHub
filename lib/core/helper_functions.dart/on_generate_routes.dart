import 'package:connect_hub/features/authentication/presentation/views/login_view.dart';
import 'package:connect_hub/features/authentication/presentation/views/signup_view.dart';
import 'package:connect_hub/features/chatbot/presentaion/views/chatbot_view.dart';
import 'package:connect_hub/features/create_post/presentation/views/create_post_view.dart';
import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/home/presentation/views/home_view.dart';
import 'package:connect_hub/features/post_details/presentation/views/post_details_view.dart';
import 'package:connect_hub/features/profile/presentation/views/profile_view.dart';
import 'package:connect_hub/features/splash/splash_view.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case SignupView.routeName:
      return MaterialPageRoute(builder: (context) => const SignupView());
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => HomeView(key: homeViewKey));
    case CreatePostView.routeName:
      return MaterialPageRoute(builder: (context) => const CreatePostView());
    case PostDetailsView.routeName:
      final post = settings.arguments as PostModel;
      return MaterialPageRoute(
        builder: (context) => PostDetailsView(post: post),
      );
    case ChatbotView.routeName:
      return MaterialPageRoute(builder: (context) => const ChatbotView());
    case ProfileView.routeName:
      return MaterialPageRoute(builder: (context) => const ProfileView());
    default:
      return MaterialPageRoute(builder: (context) => const SizedBox());
  }
}
