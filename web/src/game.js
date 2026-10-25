export const ZONES = [
  {name:'Route 201', label:'Les premiers pas', color:0x9fbf79, species:['Étourmi','Keunotor','Lixy'], boss:'Luxio'},
  {name:'Forêt de Vestigion', label:'Sous la canopée', color:0x619d8a, species:['Tortipouss','Crikzik','Rozbouton'], boss:'Torterra'},
  {name:'Rive du Lac Vérité', label:'Le calme avant la tempête', color:0x75aebd, species:['Tiplouf','Mustébouée','Lixy'], boss:'Pingoléon'},
  {name:'Mont Couronné', label:'Au-dessus des nuages', color:0xaaa3c4, species:['Ouisticram','Griknot','Étourmi'], boss:'Carchacrok'},
];
export const UPGRADES = {
  click:{name:'Force de frappe', description:'+3 dégâts par clic', base:20},
  auto:{name:'Entraînement', description:'+2 dégâts auto / seconde', base:35},
  capture:{name:'Poké Balls', description:'+8 % de capture · maximum 85 %', base:50},
};
export function fresh(now=Date.now()) {
  return {version:1, coins:0, earned:0, kills:0, zone:0, unlocked:0, progress:[0,0,0,0], cleared:[], upgrades:{click:0,auto:0,capture:0}, collection:{}, prestige:0, savedAt:now};
}
export class Game {
  constructor(save=null, {now=Date.now(), random=Math.random}={}) {
    this.random=random;this.state=this.restore(save,now);this.combo=0;this.comboTimer=0;this.skillTime=0;this.cooldown=0;this.events=[];
    const elapsed=Math.max(0,Math.min(8*3600,(now-this.state.savedAt)/1000));
    const reward=Math.floor(elapsed*this.dps*.12);
    if(reward>0){this.credit(reward);this.events.push({type:'offline',coins:reward});}
    this.state.savedAt=now;this.spawn();
  }
  restore(save,now) {
    const s=fresh(now);
    if(!save||save.version!==1)return s;
    for(const k of ['coins','earned','kills','prestige'])if(Number.isFinite(save[k])&&save[k]>=0)s[k]=Math.min(1e12,Math.floor(save[k]));
    s.unlocked=Math.min(3,Math.max(0,Math.floor(Number(save.unlocked)||0)));
    s.zone=Math.min(s.unlocked,Math.max(0,Math.floor(Number(save.zone)||0)));
    s.savedAt=Number.isFinite(save.savedAt)?save.savedAt:now;
    for(const k of Object.keys(s.upgrades))s.upgrades[k]=Math.min(k==='capture'?9:200,Math.max(0,Math.floor(Number(save.upgrades?.[k])||0)));
    s.progress=s.progress.map((_,i)=>Math.min(10,Math.max(0,Math.floor(Number(save.progress?.[i])||0))));
    s.cleared=Array.isArray(save.cleared)?[...new Set(save.cleared.filter(n=>Number.isInteger(n)&&n>=0&&n<4))]:[];
    for(const name of new Set(ZONES.flatMap(z=>[...z.species,z.boss]))) {
      const count=save.collection?.[name];if(Number.isFinite(count)&&count>0)s.collection[name]=Math.min(1e6,Math.floor(count));
    }
    return s;
  }
  get multiplier(){return 1+this.state.prestige*.25;}
  get power(){return (4+this.state.upgrades.click*3)*this.multiplier;}
  get companions(){return Object.values(this.state.collection).reduce((a,b)=>a+Math.sqrt(b),0);}
  get dps(){return (this.state.upgrades.auto*2+this.companions*1.5)*this.multiplier;}
  get captureChance(){return Math.min(.85,.2+this.state.upgrades.capture*.08);}
  get comboMultiplier(){return 1+Math.min(20,this.combo)*.025;}
  get prestigeGain(){return Math.max(1,Math.floor(Math.sqrt(this.state.earned/2500)));}
  cost(key){return Math.ceil(UPGRADES[key].base*1.55**this.state.upgrades[key]);}
  credit(amount){this.state.coins+=amount;this.state.earned+=amount;}
  spawn(boss=false){
    const z=ZONES[this.state.zone], species=z.species[Math.floor(this.random()*z.species.length)];
    const hp=Math.round((28*2.25**this.state.zone)*(boss?7:1));
    this.enemy={name:boss?z.boss:species,hp,maxHp:hp,boss,time:30};
  }
  hit(){
    this.combo=this.comboTimer>0?Math.min(20,this.combo+1):1;this.comboTimer=1.8;
    const crit=this.random()<.12, damage=this.power*this.comboMultiplier*(crit?2:1)*(this.skillTime>0?3:1);
    this.damage(damage);return {damage:Math.round(damage),crit};
  }
  damage(amount){
    this.enemy.hp=Math.max(0,this.enemy.hp-amount);
    if(this.enemy.hp>0)return;
    const defeated=this.enemy,zone=this.state.zone;
    const reward=Math.round(12*2.1**zone*(defeated.boss?8:1)*this.multiplier);
    this.credit(reward);this.state.kills++;this.state.progress[zone]=Math.min(10,this.state.progress[zone]+1);
    const captured=defeated.boss||this.random()<this.captureChance;
    if(captured)this.state.collection[defeated.name]=(this.state.collection[defeated.name]||0)+1;
    if(defeated.boss){this.state.cleared=[...new Set([...this.state.cleared,zone])];this.state.unlocked=Math.max(this.state.unlocked,Math.min(3,zone+1));}
    this.events.push({type:'defeat',name:defeated.name,coins:reward,captured,boss:defeated.boss});this.spawn();
  }
  tick(dt){
    // Bounded substeps keep boss deadlines and passive combat consistent after slow frames.
    let remaining=Math.min(60,Math.max(0,dt));
    while(remaining>0){const step=Math.min(.1,remaining);remaining-=step;
      const active=Math.min(step,this.skillTime), boosted=step+active*2;
      this.skillTime=Math.max(0,this.skillTime-step);this.cooldown=Math.max(0,this.cooldown-step);
      this.comboTimer=Math.max(0,this.comboTimer-step);if(!this.comboTimer)this.combo=0;
      if(this.enemy.boss){this.enemy.time=Math.max(0,this.enemy.time-step);if(this.enemy.time<=0){this.events.push({type:'timeout'});this.spawn();continue;}}
      if(this.dps>0)this.damage(this.dps*boosted);
    }
  }
  buy(key){if(!UPGRADES[key]||(key==='capture'&&this.state.upgrades.capture>=9))return false;const cost=this.cost(key);if(this.state.coins<cost)return false;this.state.coins-=cost;this.state.upgrades[key]++;return true;}
  changeZone(zone){if(!Number.isInteger(zone)||zone<0||zone>this.state.unlocked||zone>3)return false;this.state.zone=zone;this.combo=0;this.spawn();return true;}
  boss(){if(this.enemy.boss||this.state.progress[this.state.zone]<10)return false;this.spawn(true);return true;}
  skill(){if(this.cooldown>0)return false;this.skillTime=8;this.cooldown=45;return true;}
  prestige(){if(!this.state.cleared.includes(3))return false;const badges=this.state.prestige+this.prestigeGain;this.state=fresh();this.state.prestige=badges;this.combo=0;this.comboTimer=0;this.skillTime=0;this.cooldown=0;this.spawn();return true;}
  serialize(now=Date.now()){return JSON.stringify({...this.state,savedAt:now});}
  drain(){return this.events.splice(0);}
}
