import './style.css';
import {Game,ZONES,UPGRADES} from './game.js';
import {createScene} from './scene.js';
import {pokemonSprite} from './pokemon-assets.js';
const $=s=>document.querySelector(s), fmt=n=>new Intl.NumberFormat('fr-FR',{notation:n>=10000?'compact':'standard',maximumFractionDigits:1}).format(n);
const SAVE='pokeclicker.browser.v1';let saved=null;try{saved=JSON.parse(localStorage.getItem(SAVE));}catch{/* Corrupt saves start a new local game. */}
const game=new Game(saved);
$('#app').innerHTML=`
<header class="topbar">
  <a class="brand" href="/" aria-label="PokéClicker Live, accueil"><span class="brand-ball"></span><span>POKÉCLICKER<small>EXPÉDITION SINNOH</small></span><span class="live">LIVE</span></a>
  <div class="top-right"><span class="status-dot"></span><span id="save-status">Sauvegarde locale</span><button class="icon-button" id="help" aria-label="Comment jouer">?</button></div>
</header>
<main>
  <div class="page-heading"><div><p class="eyebrow">LE PROFESSEUR SORBIER COMPTE SUR VOUS !</p><h1>Destination : Sinnoh<span> !</span></h1><p class="subtitle">Attrapez-les. Entraînez-les. Écrivez votre légende.</p></div><div class="edition-mark"><span class="diamond-mark" aria-hidden="true"></span><span>DIAMANT <b>◆</b> PERLE<small>LE GRAND VOYAGE</small></span></div></div>
  <section class="stats" aria-label="Statistiques">
    <div><span class="stat-icon gold" aria-hidden="true">₽</span><div><small>ARGENT</small><strong id="coins">0</strong></div></div>
    <div><span class="stat-icon coral" aria-hidden="true">ATQ</span><div><small>FORCE / CLIC</small><strong id="power">4</strong></div></div>
    <div><span class="stat-icon green" aria-hidden="true">DPS</span><div><small>FORCE ÉQUIPE</small><strong id="dps">0</strong></div></div>
    <div><span class="stat-icon purple" aria-hidden="true">N°</span><div><small>CAPTURES</small><strong id="caught">0</strong></div></div>
  </section>
  <div class="console-shell"><div class="console-top"><span class="power-light"></span><span>POKÉCLICKER · SINNOH ADVENTURE</span><span class="speaker" aria-hidden="true">▥ ▥</span></div>
    <div class="layout">
      <section class="adventure screen" aria-label="Écran de combat">
        <div class="screen-topline"><span>01 / EXPLORATION</span><span>◆ EN DIRECT</span></div>
        <div class="panel-heading location-heading"><div><span class="eyebrow">POSITION ACTUELLE</span><h2 id="zone-name">Route 201</h2></div><span class="region-chip">RÉGION DE SINNOH</span></div>
        <div class="scene-wrap"><div class="scene-sky"></div><div class="location-label"><span class="status-dot"></span><span id="zone-label"></span></div>
          <div id="scene"></div><div id="scene-fallback" hidden>La 3D est indisponible. Utilisez le bouton ATTAQUER pour continuer votre aventure.</div>
          <div class="enemy-label"><div class="enemy-name-row"><h3 id="enemy-name"></h3><span id="enemy-level"></span></div><span id="enemy-kind">POKÉMON SAUVAGE</span><div class="health-label"><strong id="combat-label">Prêt pour le combat</strong><span id="health-text"></span></div><div class="hp-row"><b>PV</b><div class="health-track" role="progressbar" aria-label="Vie du Pokémon" aria-valuemin="0" aria-valuemax="100"><div id="health-fill"></div></div></div></div>
          <div id="combo" class="combo"></div><span class="scene-caption">Touchez le Pokémon pour attaquer !</span>
        </div>
        <div class="combat"><div class="battle-dialog"><span class="dialog-pointer" aria-hidden="true">▶</span><p id="battle-message">Un Pokémon sauvage apparaît !<br>Que voulez-vous faire ?</p><span class="dialog-cursor" aria-hidden="true">▼</span></div><div class="combat-actions"><button class="attack-button" id="attack"><span class="command-dot" aria-hidden="true"></span>ATTAQUER <kbd>Espace</kbd></button><button id="skill" class="skill-button">ÉLAN · ×3</button></div><div class="combat-foot"><span id="capture-info"></span><span id="boss-time">Combo : enchaînez les clics !</span></div></div>
        <div class="route-progress"><div><strong id="objective"></strong><small id="objective-hint"></small></div><button id="boss" class="outline-button">DÉFIER LE BOSS ▶</button></div>
      </section>
      <aside class="screen touch-screen" aria-label="Menu du dresseur"><div class="screen-topline"><span>02 / MENU DU DRESSEUR</span><span>POKÉMONTRE</span></div><div class="trainer"><span class="avatar" aria-hidden="true"><span class="brand-ball"></span></span><div><strong>CARTE DRESSEUR</strong><small id="trainer-level">Dresseur débutant</small></div><span class="trainer-id">ID N° 004</span></div>
        <nav class="menu-tabs" aria-label="Menu du jeu"><button data-menu="upgrades" aria-pressed="true" aria-controls="menu-upgrades"><span aria-hidden="true">▣</span>SAC</button><button data-menu="journey" aria-pressed="false" aria-controls="menu-journey"><span aria-hidden="true">⚑</span>CARTE</button><button data-menu="collection" aria-pressed="false" aria-controls="menu-collection"><span aria-hidden="true">◉</span>ÉQUIPE</button><button data-menu="prestige" aria-pressed="false" aria-controls="menu-prestige"><span aria-hidden="true">★</span>BADGES</button></nav>
        <div class="menu-content"><section id="menu-upgrades" class="panel upgrades menu-page"><div class="panel-heading"><div><span class="eyebrow">POCHE ENTRAÎNEMENT</span><h2>Le sac du dresseur</h2></div><span class="bag-icon" aria-hidden="true">▣</span></div><p class="menu-intro">Tout le nécessaire pour devenir le prochain Maître !</p><div id="upgrades"></div><div class="tip"><span aria-hidden="true">!</span> Les Pokémon capturés rejoignent votre équipe et attaquent automatiquement.</div><div class="bag-decoration" aria-hidden="true"><span class="brand-ball"></span><span>PRÉPAREZ VOTRE PROCHAINE RENCONTRE</span></div></section>
        <section id="menu-journey" class="panel journey menu-page" hidden><div class="panel-heading"><div><span class="eyebrow">CARTE DE LA RÉGION</span><h2>À travers Sinnoh</h2></div><span aria-hidden="true">⚑</span></div><div class="sinnoh-map" aria-hidden="true"><div class="map-land"></div><span class="map-route"></span><i class="map-point p0"></i><i class="map-point p1"></i><i class="map-point p2"></i><i class="map-point p3"></i><b>SINNOH</b></div><div id="zones"></div><p class="map-note">Battez le gardien pour ouvrir la prochaine route.</p></section>
        <section id="menu-collection" class="panel collection menu-page" hidden><div class="panel-heading"><div><span class="eyebrow">VOS FIDÈLES COMPAGNONS</span><h2>Équipe Pokémon <span id="team-count" class="count">0</span></h2></div></div><p class="menu-intro">Chaque capture compte. Les doublons renforcent vos compagnons.</p><div id="collection"></div></section>
        <section id="menu-prestige" class="panel prestige menu-page" hidden><div class="panel-heading"><div><span class="eyebrow">EN ROUTE VERS LA LIGUE</span><h2>La boîte à badges</h2></div></div><div class="badge-case" aria-label="Gardiens vaincus"><span data-badge="0">◆</span><span data-badge="1">❖</span><span data-badge="2">♦</span><span data-badge="3">★</span></div><h3>Votre légende commence ici.</h3><p id="prestige-info"></p><button id="prestige" class="outline-button">NOUVELLE AVENTURE ▶</button><p class="prestige-note">Le prestige remet l'aventure à zéro, mais vos insignes donnent un bonus permanent.</p></section></div>
        <div class="touch-bottom"><span class="brand-ball tiny" aria-hidden="true"></span><span id="menu-hint">Sélectionnez une amélioration.</span><span class="touch-dots" aria-hidden="true">● ● ●</span></div>
      </aside>
    </div><div class="console-bottom" aria-hidden="true"><span>● POWER</span><span>◆</span><span>POKÉCLICKER LIVE</span></div>
  </div>
  <footer><span>UNE GRANDE AVENTURE. UN CLIC À LA FOIS.</span><span>Progression locale · Sprites <a href="/pokemon/ATTRIBUTION.md">PokéAPI</a> · Rendu Three.js</span></footer>
</main>
<div id="toasts" role="status" aria-live="polite"></div><dialog id="dialog"><h2 id="dialog-title"></h2><p id="dialog-body"></p><div class="dialog-actions"><button id="dialog-cancel" class="outline-button">Fermer</button><button id="dialog-confirm" class="attack-button" hidden>Recommencer l’aventure</button></div></dialog>`;
$('#upgrades').innerHTML=Object.entries(UPGRADES).map(([key,u],i)=>`<button class="upgrade" data-upgrade="${key}"><span class="upgrade-icon ${['coral','green','purple'][i]}">${['ATQ','DPS','BALL'][i]}</span><span class="upgrade-info"><strong>${u.name} <small id="level-${key}"></small></strong><small>${u.description}</small></span><span class="price" id="cost-${key}"></span></button>`).join('');
$('#zones').innerHTML=ZONES.map((z,i)=>`<button class="zone" data-zone="${i}"><span class="zone-marker">${String(i+1).padStart(2,'0')}</span><span><strong>${z.name}</strong><small>${z.label}</small></span><span class="zone-state" id="zone-state-${i}"></span></button>`).join('');
const menuHints={upgrades:'Sélectionnez une amélioration.',journey:'Choisissez votre prochaine destination.',collection:'Vos compagnons combattent à vos côtés.',prestige:'Quatre gardiens. Une nouvelle légende.'};
function selectMenu(menu){
  if(!Object.hasOwn(menuHints,menu))return;
  for(const button of document.querySelectorAll('[data-menu]'))button.setAttribute('aria-pressed',String(button.dataset.menu===menu));
  for(const page of document.querySelectorAll('.menu-page'))page.hidden=page.id!==`menu-${menu}`;
  $('#menu-hint').textContent=menuHints[menu];
}
for(const button of document.querySelectorAll('[data-menu]'))button.onclick=()=>selectMenu(button.dataset.menu);
let visual=null;try{visual=createScene($('#scene'),(x,y)=>attack(x,y));}catch{$('#scene-fallback').hidden=false;}
function toast(message){const el=document.createElement('div');el.className='toast';el.textContent=message;$('#toasts').append(el);setTimeout(()=>el.remove(),4500);}
function attack(x,y){const result=game.hit();visual?.hit();const r=$('#attack').getBoundingClientRect();const label=document.createElement('span');label.className=`damage ${result.crit?'critical':''}`;label.textContent=`${result.crit?'CRIT ! ':''}−${result.damage}`;label.style.left=`${x??r.x+r.width/2}px`;label.style.top=`${y??r.y-80}px`;document.body.append(label);setTimeout(()=>label.remove(),850);render();}
$('#attack').addEventListener('click',()=>attack());document.addEventListener('keydown',e=>{if(e.code==='Space'&&!e.repeat&&!$('#dialog').open&&!['BUTTON','INPUT','TEXTAREA','SELECT','A'].includes(document.activeElement.tagName)){e.preventDefault();attack();}});
$('#skill').onclick=()=>{if(game.skill())toast('Élan activé : tous vos dégâts sont triplés pendant 8 secondes !');render();};
$('#boss').onclick=()=>{if(game.boss())toast('Le boss approche ! Vous avez 30 secondes.');render();};
for(const button of document.querySelectorAll('[data-upgrade]'))button.onclick=()=>{if(game.buy(button.dataset.upgrade)){save();render();}};
for(const button of document.querySelectorAll('[data-zone]'))button.onclick=()=>{if(game.changeZone(Number(button.dataset.zone))){save();render();}};
function dialog(title,body,confirm=false){$('#dialog-title').textContent=title;$('#dialog-body').textContent=body;$('#dialog-confirm').hidden=!confirm;$('#dialog').showModal();$('#dialog-cancel').focus();}
$('#help').onclick=()=>dialog('Votre guide de terrain','Cliquez sur le Pokémon ou sur Attaquer (raccourci Espace). Enchaînez les clics pour augmenter le combo. Les captures renforcent vos dégâts automatiques, même sans cliquer. Après 10 victoires, défiez le boss en 30 secondes pour ouvrir une nouvelle zone. Élan triple les dégâts pendant 8 secondes, avec 45 secondes de recharge. Les gains hors ligne sont limités à 8 heures. Après le Mont Couronné, le prestige remet la partie à zéro en échange d’un bonus permanent.');
$('#dialog-cancel').onclick=()=>$('#dialog').close();$('#prestige').onclick=()=>dialog('Écrire une nouvelle légende',`Vous gagnerez ${game.prestigeGain} insigne(s), soit +${game.prestigeGain*25} % de dégâts permanents. Les pièces, captures, améliorations et zones seront réinitialisées. Cette action est irréversible.`,true);
$('#dialog-confirm').onclick=()=>{if(game.prestige()){save();render();toast('Une nouvelle aventure commence. Votre bonus permanent vous accompagne.');}$('#dialog').close();};
let collectionKey='',saveFailed=false;
function save(){try{localStorage.setItem(SAVE,game.serialize());$('#save-status').textContent='Progression sauvegardée';}catch{if(!saveFailed)toast('Le stockage est indisponible : votre progression ne sera pas conservée.');saveFailed=true;$('#save-status').textContent='Sauvegarde indisponible';}}
function render(){const s=game.state,e=game.enemy,z=ZONES[s.zone];
  $('#coins').textContent=fmt(s.coins);$('#power').textContent=fmt(game.power*game.comboMultiplier*(game.skillTime>0?3:1));$('#dps').textContent=fmt(game.dps*(game.skillTime>0?3:1));$('#caught').textContent=fmt(Object.values(s.collection).reduce((a,b)=>a+b,0));
  $('#trainer-level').textContent=`${s.kills} victoires · Bonus permanent +${s.prestige*25} %`;
  $('#zone-name').textContent=z.name;$('#zone-label').textContent=z.label;$('#enemy-name').textContent=e.name;$('#enemy-kind').textContent=e.boss?'GARDIEN DE LA ZONE':'POKÉMON SAUVAGE';
  $('#combat-label').textContent=e.boss?'Défi du boss':'À vous de jouer';$('#health-text').textContent=`${Math.ceil(e.hp)} / ${e.maxHp} PV`;$('#health-fill').style.width=`${e.hp/e.maxHp*100}%`;$('#health-fill').dataset.health=e.hp/e.maxHp<.2?'low':e.hp/e.maxHp<.5?'medium':'high';$('#enemy-level').textContent=`N. ${5+s.zone*10+(e.boss?5:0)}`;$('.health-track').setAttribute('aria-valuenow',Math.round(e.hp/e.maxHp*100));
  $('#battle-message').textContent=e.boss?`${e.name} vous défie !\nVainquez-le avant la fin du chrono !`:`Un ${e.name} sauvage apparaît !\nQue voulez-vous faire ?`;
  document.querySelector('.adventure').classList.toggle('boss-encounter',e.boss);
  for(const badge of document.querySelectorAll('[data-badge]')){const earned=s.cleared.includes(Number(badge.dataset.badge));badge.classList.toggle('earned',earned);badge.setAttribute('aria-label',`Gardien ${Number(badge.dataset.badge)+1} : ${earned?'vaincu':'à vaincre'}`);}
  for(const point of document.querySelectorAll('.map-point')){const index=Number([...point.classList].find(c=>/^p[0-3]$/.test(c))?.slice(1));point.classList.toggle('current',index===s.zone);point.classList.toggle('unlocked',index<=s.unlocked);}
  $('#combo').textContent=game.combo>1?`COMBO ×${game.comboMultiplier.toFixed(2)} · ${game.combo} coups`:'';
  $('#capture-info').textContent=`◉ ${Math.round(game.captureChance*100)} % de chance de capture`;
  $('#boss-time').textContent=e.boss?`⏱ ${Math.ceil(e.time)} s restantes`:game.skillTime>0?`✦ Élan : ${Math.ceil(game.skillTime)} s`:'Clics rapides = combo ×1,5';
  $('#skill').disabled=game.cooldown>0;$('#skill').textContent=game.cooldown>0?`✦ ${game.skillTime>0?'Élan actif': 'Recharge'} · ${Math.ceil(game.skillTime>0?game.skillTime:game.cooldown)} s`:'ÉLAN · ×3';
  $('#objective').textContent=s.cleared.includes(s.zone)?'Zone maîtrisée · Continuez l’exploration':`${s.progress[s.zone]} / 10 rencontres remportées`;
  $('#objective-hint').textContent=s.cleared.includes(s.zone)?'Rejouez le boss ou sélectionnez la prochaine destination.':'Remportez 10 combats pour affronter le gardien.';$('#boss').disabled=s.progress[s.zone]<10||e.boss;
  for(const key of Object.keys(UPGRADES)){const max=key==='capture'&&s.upgrades.capture>=9;$(`#level-${key}`).textContent=`Niv. ${s.upgrades[key]}`;$(`#cost-${key}`).textContent=max?'MAX':`₽ ${fmt(game.cost(key))}`;$(`[data-upgrade="${key}"]`).disabled=max||s.coins<game.cost(key);}
  ZONES.forEach((_,i)=>{const b=$(`[data-zone="${i}"]`);b.disabled=i>s.unlocked;b.classList.toggle('selected',i===s.zone);b.setAttribute('aria-pressed',i===s.zone?'true':'false');$(`#zone-state-${i}`).textContent=i>s.unlocked?'Verrouillé':i===s.zone?'Ici':s.cleared.includes(i)?'✓':'→';});
  const entries=Object.entries(s.collection),key=JSON.stringify([entries,s.prestige]);if(key!==collectionKey){collectionKey=key;$('#team-count').textContent=entries.length;$('#collection').innerHTML=entries.length?entries.map(([name,count])=>`<div class="companion"><img class="companion-sprite" src="${pokemonSprite(name)}" alt="" width="56" height="56" loading="lazy"><div><strong>${name}</strong><small>×${count} · ${fmt(Math.sqrt(count)*1.5*game.multiplier)} DPS</small></div></div>`).join(''):'<div class="empty-team"><span>◉</span><div><strong>Votre premier compagnon vous attend.</strong><p>Chaque victoire est une chance de capture. Les boss sont capturés à coup sûr !</p></div></div>';}
  $('#prestige').disabled=!s.cleared.includes(3);$('#prestige-info').textContent=`${s.prestige} insigne(s) · +${s.prestige*25} % de dégâts permanents. Battez les quatre gardiens pour débloquer le prestige.`;
  visual?.setEnemy(e.name,e.boss);visual?.setZone(s.zone,z.color);
  for(const event of game.drain()){if(event.type==='offline')toast(`Bon retour ! Votre équipe a gagné ₽ ${fmt(event.coins)} pendant votre absence.`);if(event.type==='timeout')toast('Le boss s’est échappé. Renforcez votre équipe et réessayez, sans pénalité.');if(event.type==='defeat')toast(`${event.name} vaincu · +₽ ${fmt(event.coins)}${event.captured?' · Capturé !':''}${event.boss?' Nouvelle étape débloquée.':''}`);}
}
let previous=performance.now(),lastRender=0;function frame(now){const dt=Math.min((now-previous)/1000,.25);previous=now;if(!document.hidden)game.tick(dt);visual?.render(dt);if(now-lastRender>100){render();lastRender=now;}requestAnimationFrame(frame);}render();requestAnimationFrame(frame);setInterval(()=>{if(!document.hidden)save();},5000);
let hiddenAt=null;document.addEventListener('visibilitychange',()=>{if(document.hidden){hiddenAt=Date.now();save();}else{if(hiddenAt){const seconds=Math.min(8*3600,(Date.now()-hiddenAt)/1000),coins=Math.floor(seconds*game.dps*.12);if(coins>0){game.credit(coins);toast(`Votre équipe a gagné ₽ ${fmt(coins)} pendant votre absence.`);}hiddenAt=null;}previous=performance.now();render();save();}});window.addEventListener('pagehide',save);
