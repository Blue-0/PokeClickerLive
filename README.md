# PokéClicker Live — navigateur & Three.js

Le client principal est désormais une application JavaScript/Vite avec un monde 3D Three.js. Le jeu se lance dans un navigateur moderne, sans Flutter, compte, clé Supabase ni API. Les Pokémon sont des modèles voxel extrudés à partir de leurs sprites pixel art, dans un décor 3D avec éclairage et particules. Les 14 sprites sont embarqués localement ; aucune image ou police distante n’est nécessaire pendant la partie.

## Démarrage

Node.js 22 LTS recommandé (Vite exige Node >=18).

```sh
npm ci
npm run dev
```

Ouvrir l'adresse affichée par Vite. `npm run build` génère le site statique dans `web/dist` ; `npm run preview` permet de vérifier cette version. Déployer le contenu de `web/dist` sur un hébergeur statique, à la racine du domaine.

```sh
npm test              # moteur de progression, sans navigateur
npm run test:browser  # parcours Chromium, bureau + mobile + repli sans WebGL
```

Les tests navigateur utilisent `/usr/bin/chromium`. Pour une autre installation, définir `CHROMIUM_PATH` vers l'exécutable Chromium. Le serveur Vite de test démarre automatiquement. Les rapports et sorties sont ignorés par Git.

## Boucle de jeu

- Cliquer sur la créature ou sur **Attaquer** (Espace hors des boutons). Les clics espacés de moins de 1,8 seconde font monter un combo jusqu'à ×1,5 ; 12 % des attaques sont critiques.
- Les victoires rapportent des Pokédollars. Améliorer la force de frappe, l'entraînement automatique et les chances de capture. Les prix augmentent progressivement ; les achats ne peuvent pas rendre le solde négatif.
- Chaque capture ajoute un compagnon qui attaque automatiquement. Les doublons renforcent ce compagnon avec un rendement décroissant : `1,5 × √quantité` DPS avant bonus de prestige.
- Après dix victoires dans une zone, un boss devient disponible. Le vaincre en trente secondes ouvre la zone suivante et garantit sa capture. Un échec permet de revenir s'entraîner sans perdre de monnaie ni de progression.
- **Élan** triple les dégâts manuels et automatiques pendant huit secondes, avec quarante-cinq secondes de recharge à partir de l'activation.
- Quatre environnements : Route 201, Forêt de Vestigion, Lac Vérité, Mont Couronné. Les zones déjà ouvertes restent accessibles pour farmer.
- Après le quatrième boss, le prestige réinitialise la partie et accorde `max(1, floor(√(revenus / 2500)))` insignes. Chaque insigne apporte +25 % de dégâts permanents. Une confirmation explique les pertes avant la remise à zéro.

## Sauvegarde et limitations

Sauvegarde locale versionnée toutes les cinq secondes, lors des achats/changements de zone et à la fermeture/masquage de la page. Au retour, l'équipe rapporte des pièces à 12 % de son DPS par seconde, pendant huit heures maximum. Ce revenu ne gagne ni combats, ni captures, ni boss. La durée des combats et la capacité temporaire ne persistent pas au rechargement.

La progression est propre au navigateur et à l'origine du site (`localStorage`, clé `pokeclicker.browser.v1`). Elle n'est ni synchronisée entre appareils ni importée des anciennes sauvegardes Flutter. Effacer les données du navigateur l'efface. Un message prévient si le stockage est indisponible. Le moteur valide les valeurs chargées mais n'est pas une protection anti-triche : il s'agit d'un jeu local.

WebGL est utilisé pour la scène interactive et les impacts. Si WebGL est indisponible, les commandes de combat restent jouables. Le mode de réduction des animations est respecté. Les boutons sont accessibles au clavier, la vie expose une barre de progression et les notifications disposent d'une région accessible.

## Docker (facultatif)

```sh
docker compose up --build web
```

Le site est servi sur le port 3000. L'ancien service PHP est conservé dans le profil `legacy-api`, sur le port 8081, mais n'est pas utilisé par la version navigateur. Le serveur PHP ne doit pas être exposé pour jouer à cette version.

## Organisation et migration

- `web/src/game.js` : règles, économie, combat, progression, validation et sérialisation de sauvegarde, indépendants du rendu.
- `web/src/scene.js` : scène Three.js, éclairage, interactions, animations, particules et post-traitement pixel art (`EffectComposer`, `RenderPixelatedPass`, `OutputPass`).
- `web/src/pokemon-assets.js` et `pokemon-voxels.js` : catalogue Pokémon, conversion des pixels opaques en cubes via `InstancedMesh`, cache mémoire et libération des ressources GPU.
- `web/public/pokemon/` : sprites PokéAPI locaux, provenance, empreintes SHA-256 et attribution. Les modèles sont des extrusions stylisées des sprites 2D, pas des modèles 3D officiels. Les sprites servent aussi de portraits dans l’équipe. Un échec de chargement conserve un modèle de remplacement et les commandes de combat.
- `web/src/main.js` : interface française, boucle temps réel, stockage et commandes accessibles.
- `web/test` et `web/e2e` : tests moteur et parcours navigateur.
- `Flutter/` : ancien client conservé pour référence ; n'est plus nécessaire au workflow principal.
- `backend-php/` : ancienne API conservée ; connexion et synchronisation cloud ne sont pas migrées vers le nouveau client.

Les anciens fichiers `.env` ne sont pas lus, intégrés au bundle ou copiés dans l'image web. N'utilisez jamais une clé de service Supabase dans un client navigateur.
