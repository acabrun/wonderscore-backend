-- ------------------------------
-- Création des tables pour l'application oQuiz
-- ------------------------------

-- par convention, on nomme nos tables et nos champs au singulier, en anglais, en miniscule et en snake_case
-- bonne pratique : on va entourer tous ces noms de double quotes (") pour éviter toute confusion à PostgreSQL

-- ------------------------------

-- On va sécuriser notre script en effectuant une transaction :

-- BEGIN;
-- nos requêtes de création de tables
-- COMMIT;

-- Les requêtes vont être "prédigérées" par POstgreSQL avant d'être envoyées à la base
-- ainsi, en cas d'erreur, même à la dernier requête, la transaction entière va être annulée
-- pas de risque que le fichier soit partiellement exécuté, c'est tout ou rien

-- début de transaction
BEGIN;

-- avant de créer les tables, par sécurité, on les supprime
DROP TABLE IF EXISTS "player", "game", "_match";

-- on est sûr que la BDD est propre, on peut commencer la création

-- pour tous nos champs id, nos clé primaires, on va utiliser le type SERIAL
-- ce type est un pseudo-type, c'est en fait un INT NOT NULL relié à une table interne qui permet de l'incrémenter à chaque nouvel enregistrement
-- la 'vraie' syntaxe serait id INTEGER NOT NULL DEFAULT nextval('<table>_id_seq'::regclass)

-- ------------------------------
-- table player
-- ------------------------------

CREATE TABLE IF NOT EXISTS "player" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL UNIQUE,
    "email" TEXT,
    "password" TEXT NOT NULL,
    "victory_nb" INT DEFAULT 0,
    "created_at" timestamp WITH TIME ZONE NOT NULL DEFAULT NOW(),
    "updated_at" timestamp WITH TIME ZONE
);

-- ------------------------------
-- table game
-- ------------------------------

CREATE TABLE IF NOT EXISTS "game" (
    "id" SERIAL PRIMARY KEY,
    "score" TEXT,
    "victory_type" TEXT NOT NULL,
    "winner" INT REFERENCES "player"("id"),
    "created_at" timestamp WITH TIME ZONE NOT NULL DEFAULT NOW(),
    "updated_at" timestamp WITH TIME ZONE
);

-- ------------------------------
-- table _match
-- ------------------------------

CREATE TABLE IF NOT EXISTS "_match" (
    "player_a_id" INT NOT NULL REFERENCES "player"("id"),
    "player_b_id" INT NOT NULL REFERENCES "player"("id"),
    "game_id" INT NOT NULL REFERENCES "game"("id"),
    -- on ne peut pas utiliser le mot-9clé PRIMARY KEY sur plusieurs champs
    -- pour indiquer une clé primaire sur plusieurs champs, on la définit à part, après la définition de nos champs
    PRIMARY KEY ("player_a_id", "player_b_id", "game_id")
);

-- SEEDING ----------------------

INSERT INTO "player" ("name","password") VALUES
('Anthony','oui'),
('Aélis','oui'),
('Hugo','oui'),
('Jerem','oui'),
('Max','oui'),
('Thomas','oui');


INSERT INTO "game" ("score", "victory_type", "winner") VALUES
('70-76','regular', 2),
('80-76','regular', 1),
(null,'military', 4),
('55-65','regular', 6);


INSERT INTO "_match" ("player_a_id", "player_b_id", "game_id") VALUES
(1, 2, 1),
(1, 2, 2),
(2, 4, 3),
(5, 6, 4);

-- aucune erreur ne s'est produite, on envoie toutes les requêtes sur le serveur PostgreSQL
COMMIT;