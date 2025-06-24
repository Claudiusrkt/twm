import 'package:flutter/material.dart';
import '../model/utilisateur.dart';

class UserProvider extends ChangeNotifier {
  Utilisateur? _utilisateur;

  Utilisateur? get utilisateur => _utilisateur;

  void setUtilisateur(Utilisateur utilisateur) {
    _utilisateur = utilisateur;
    notifyListeners();
  }

  void clearUtilisateur() {
    _utilisateur = null;
    notifyListeners();
  }
}
