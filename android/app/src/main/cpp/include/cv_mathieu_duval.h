#ifndef CV_MATHIEU_DUVAL_H
#define CV_MATHIEU_DUVAL_H

#include <string>
#include <vector>
#include <stdexcept>
#include <random>

/****************************************************************************
 * Auteur:          MATHIEU DUVAL
 * Adresse:         1885 impasse d'Arsigny, Saint-Hyacinthe, QC, J2S 8S9
 * Courriel:        m_duval76@hotmail.com
 * Téléphone:       514-605-1499
 * Description:     CV créatif pour un stagiaire en développement logiciel.
 * Date:            2024-11-17
 * Version:         1.1
 * Droits:          (c) 2024 Mathieu Duval
 ****************************************************************************/

#define GITHUB_LINK "https://github.com/mduval"
#define LINKEDIN_LINK "https://linkedin.com/in/mathieu-duval"

class CurriculumVitae {
public:
    CurriculumVitae() {
        // Étudiant passionné en dernière année de Technique de l'informatique 
        // (profil Développement logiciel) au Cégep de Saint-Hyacinthe.
        // Je suis enthousiaste à l'idée de transformer mes connaissances et 
        // compétences en contributions concrètes au sein d'une équipe dynamique.
    }
 
    std::vector<std::string> get_parcours_professionnel(const short annee);
    std::vector<std::string> get_parcours_académique(const short annee);
    std::vector<std::string> get_compétences(std::string type);
    std::string get_random_caractéristique_personnelle() const;

private:
    std::vector<std::string> langages_informatiques = 
    {"C++", "C#", "JS", "TS", "Java", "Dart", "Scala", "Kotlin", "PHP", "(T-)SQL", "HTML", "CSS"};
    std::vector<std::string> cadriciel = 
    {"React", "Angular", "Flutter", "ASP.NET Core", "WCF", "Node.js", "Spring", "WordPress"};
    std::vector<std::string> outils = 
    {"Git", "Docker", "Kubernetes", "Trello", "Jira", "Office 365" };
    std::vector<std::string> méthodologie = 
    {"Agile", "Scrum", "DevOps", "UML", "Design Patterns"};
    std::vector<std::string> EDI = 
    {"Visual Studio", "IntelliJ", "Android Studio", "VS Code"};
    std::vector<std::string> système_exploitation = 
    {"Windows", "Linux (Ubuntu, Kali)", "Mac", "Android", "iOS"};
    std::vector<std::string> base_de_données = 
    {"SQL Server", "SQLite", "Hive"};
    std::vector<std::string> langues_parlées = 
    {"Français (maitrisée)", "Anglais (maitrisée)", "Suédois (intermédiaire)"};
    std::vector<std::string> caractéristiques_personnelles = 
    {"Adore trouver des solutions", "Excellente capacité d'écoute", "Parfaitement bilingue", 
     "Grande soif d'apprentissage", "Recherche constante de perfectionnement", "Créatif", 
     "Bonne capacité pour analyser", "Efficace pour la recherche", "Méticuleux"};
};

std::vector<std::string> CurriculumVitae::get_parcours_professionnel(const short annee) {
    std::string nomEntreprise, adresse, poste, description;

    if (annee >= 2016 && annee <= 2021) {
        nomEntreprise = "Casino de Montréal \n";
        adresse = "1, avenue du Casino, Montréal, QC, H3C 4W7 \n";
        poste = "Préposé à l'entretien ménager (léger) \n";
        description = "Effectuer des tâches ménagères diverses afin de \n";
        description += "maintenir la salubrité de l'environnement de travail. \n";
    } 
    else if ((annee >= 2002 && annee <= 2003) || (annee > 2006 && annee <= 2016)) {
        nomEntreprise = "Casino de Montréal \n";
        adresse = "1, avenue du Casino, Montréal, QC, H3C 4W7 \n";
        poste = "Croupier \n";
        description = "Gestion du jeu et des paiements selon les procédures établies. \n";
        description += "Calculs mentaux rapides et sous pression. Servir la clientèle. \n";
        description += "Gestion de la monnaie et du matériel de jeu. \n";
    } else if ((annee > 2003 && annee <= 2006)) {
        nomEntreprise = "Casino Cosmopol \n";
        adresse = "Kungsgatan 65, 101 22 Stockholm, Suède \n";
        poste = "Croupier/Chef de table \n";
        description = "Mêmes tâches qu'un croupier (voir 2002-2003 & 2006-2016) \n";
        description += "Gestion de conflits et problèmes aux tables de jeu. \n";
        description += "Superviser le bon fonctionnement des jeux aux tables. \n";
        description += "Rédaction de courts rapports lors des fermetures de tables. \n";
    } else {
        throw std::invalid_argument("Divers, veuillez demander en personne. \n");
    }
    return {nomEntreprise, poste, description};
}

std::vector<std::string> CurriculumVitae::get_parcours_académique(const short annee) {
    std::string nomÉtablissement, programme, profile, diplôme;

    if (annee >= 2021 && annee <= 2025) {
        nomÉtablissement = "Cégep de Saint-Hyacinthe \n";
        programme = "Technique de l'informatique \n";
        profile = "Développement logiciel \n";
        diplôme = "DEC (en cours) \n";
    } else if (annee >= 1993 && annee <= 1995) {
        nomÉtablissement = "Cégep d'Ahuntsic \n";
        programme = "Arts et lettres \n";
        profile = "Cinéma \n";
        diplôme = "DEC (complété) \n";
    }
    return {nomÉtablissement, programme, profile, diplôme};
}

std::vector<std::string> CurriculumVitae::get_compétences(std::string type) {
    if (type == "langages_informatiques") return langages_informatiques;
    if (type == "cadriciel") return cadriciel;
    if (type == "outils") return outils;
    if (type == "méthodologie") return méthodologie;
    if (type == "EDI") return EDI;
    if (type == "système_exploitation") return système_exploitation;
    if (type == "base_de_données") return base_de_données;
    if (type == "langues_parlées") return langues_parlées;

    static const std::vector<std::string> empty_list{};
    return empty_list;
}

std::string CurriculumVitae::get_random_caractéristique_personnelle() const {
    static std::random_device rd;
    static std::mt19937 gen(rd());
    std::uniform_int_distribution<> dist(0, caractéristiques_personnelles.size() - 1);

    return caractéristiques_personnelles[dist(gen)];
}

#endif // CV_MATHIEU_DUVAL_H